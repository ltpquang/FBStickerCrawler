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

@interface PQStickerListTableViewController ()
// Data
@property (strong, nonatomic) PQStickerPack *stickerPack;
@property (strong, nonatomic) PQRequestingService *requestingService;
@property (strong, nonatomic) NSArray *stickers;
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
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [self start];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _stickers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PQStickerTableViewCell *cell = (PQStickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"StickerCell" forIndexPath:indexPath];
    
    [cell configCellUsingSticker:[_stickers objectAtIndex:indexPath.row]];
    
    return cell;
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
