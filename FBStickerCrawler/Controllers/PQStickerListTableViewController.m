//
//  PQStickerListTableViewController.m
//  FBStickerCrawler
//
//  Created by Le Thai Phuc Quang on 4/10/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "PQStickerListTableViewController.h"
#import "PQStickerPack.h"
#import "PQRequestingService.h"
#import "PQStickerTableViewCell.h"
#import "PQPendingOperations.h"

@interface PQStickerListTableViewController ()
// Data
@property (strong, nonatomic) PQStickerPack *stickerPack;
@property (strong, nonatomic) PQRequestingService *requestingService;
@property (strong, nonatomic) NSArray *stickers;
@property (strong, nonatomic) PQPendingOperations *pendingOperations;
// UI
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation PQStickerListTableViewController
- (void)configUsingStickerPack:(PQStickerPack *)stickerPack {
    _stickerPack = stickerPack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    
}

- (void)didReceiveMemoryWarning {
    NSLog(@"memory warning");
    [self cancelAllOperations];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self start];
}

- (void)dealloc {
    for (PQSticker *sticker in _stickers) {
        sticker.spriteArray = nil;
    }
}

- (void)start {
    [_refreshControl beginRefreshing];
    [_mainTableView setContentOffset:CGPointMake(0, _mainTableView.contentOffset.y-_refreshControl.frame.size.height) animated:YES];
    [self refresh];
}

#pragma mark - Setup data
- (void)setupData {
    _requestingService = [PQRequestingService new];
    _stickers = [NSArray new];
    _pendingOperations = [PQPendingOperations new];
}

#pragma mark - Setup UI
- (void)setupRefreshControl {
    _refreshControl = [UIRefreshControl new];
    [_mainTableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)setupUI {
    self.title = _stickerPack.name;
    [self setupRefreshControl];
}

#pragma mark - Refresh control delegate
- (void)refresh {
    [_stickerPack downloadStickersUsingRequestingService:_requestingService
                                                 success:^{
                                                     _stickers = _stickerPack.stickers;
                                                     [_mainTableView reloadData];
                                                     [_refreshControl endRefreshing];
                                                 }
                                                 failure:^(NSError *error) {
                                                     [_refreshControl endRefreshing];
                                                 }];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _stickers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PQStickerTableViewCell *cell = (PQStickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"StickerCell" forIndexPath:indexPath];
    
    PQSticker *sticker = (PQSticker *)[_stickers objectAtIndex:indexPath.row];
    
    [cell resetContent];
    [cell startLoadingIndicator:YES];
    
    if (sticker.hasImage) {
        [cell configCellUsingSticker:sticker];
    }
    else {
        //if (!tableView.dragging && !tableView.decelerating) {
            [self startOperationForSticker:sticker atIndexPath:indexPath];
        //}
    }
    
    return cell;
}

#pragma mark - Operations tasks
- (void)startOperationForSticker:(PQSticker *)sticker atIndexPath:(NSIndexPath *)indexPath {
    [self startDownloadingOperationForSticker:sticker atIndexPath:indexPath];
}

- (void)startDownloadingOperationForSticker:(PQSticker *)sticker atIndexPath:(NSIndexPath *)indexPath {
    if (![_pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        PQImageDownloader *imageDownloader = [[PQImageDownloader alloc] initWithSticker:sticker
                                                                            atIndexPath:indexPath
                                                                               delegate:self];
        [_pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [_pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}

- (void)imageDownloaderDidFinish:(PQImageDownloader *)downloader {
    NSIndexPath *indexPath = downloader.indexPath;
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 1
    [self suspendAllOperations];
    NSLog(@"Begin dragging");
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 2
    if (!decelerate) {
        [self loadImagesForOnscreenCells];
        [self resumeAllOperations];
    }
    NSLog(@"End dragging - %hhd", decelerate);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 3
    [self loadImagesForOnscreenCells];
    [self resumeAllOperations];
    NSLog(@"End decelerating");
}

- (void)suspendAllOperations {
    [_pendingOperations.downloadQueue setSuspended:YES];
}

- (void)resumeAllOperations {
    [_pendingOperations.downloadQueue setSuspended:NO];
}

- (void)cancelAllOperations {
    [_pendingOperations.downloadQueue cancelAllOperations];
}

- (void)loadImagesForOnscreenCells {
    
    // 1
    NSSet *visibleRows = [NSSet setWithArray:[_mainTableView indexPathsForVisibleRows]];
    
    // 2
    NSSet *pendingOperations = [NSSet setWithArray:[self.pendingOperations.downloadsInProgress allKeys]];
    
    NSMutableSet *toBeCancelled = [pendingOperations mutableCopy];
    NSMutableSet *toBeStarted = [visibleRows mutableCopy];
    
    // 3
    [toBeStarted minusSet:pendingOperations];
    // 4
    [toBeCancelled minusSet:visibleRows];
    
    // 5
    for (NSIndexPath *anIndexPath in toBeCancelled) {
        
        PQImageDownloader *pendingDownload = [self.pendingOperations.downloadsInProgress objectForKey:anIndexPath];
        [pendingDownload cancel];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:anIndexPath];
    }
    toBeCancelled = nil;
    
    // 6
    for (NSIndexPath *anIndexPath in toBeStarted) {
        
        PQSticker *sticker = [self.stickers objectAtIndex:anIndexPath.row];
        [self startOperationForSticker:sticker atIndexPath:anIndexPath];
    }
    toBeStarted = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
