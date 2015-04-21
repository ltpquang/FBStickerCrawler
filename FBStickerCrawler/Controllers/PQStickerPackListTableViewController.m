//
//  PQStickerPackListTableViewController.m
//  FBStickerCrawler
//
//  Created by Le Thai Phuc Quang on 4/10/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "PQStickerPackListTableViewController.h"
#import "PQRequestingService.h"
#import "PQStickerPack.h"
#import "PQStickerPackTableViewCell.h"
#import "PQStickerListTableViewController.h"

@interface PQStickerPackListTableViewController ()
// Data
@property (strong, nonatomic) NSArray *stickerPacks;
@property (strong, nonatomic) NSArray *searchResultStickerPacks;
@property (strong, nonatomic) PQRequestingService *requestingService;
@property (strong, nonatomic) PQStickerPack *selectedPack;

@property BOOL isSearching;
// UI
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISearchBar *searchBar;
@end

@implementation PQStickerPackListTableViewController
#pragma mark - Controller delegates
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    if (_stickerPacks.count != 0) return;
    [self start];
}

- (void)start {
    [_refreshControl beginRefreshing];
    [_mainTableView setContentOffset:CGPointMake(0, _mainTableView.contentOffset.y-_refreshControl.frame.size.height) animated:YES];
    [self refresh];
}

#pragma mark - Setup data
- (void)setupData {
    _stickerPacks = [NSArray new];
    _requestingService = [PQRequestingService new];
}

#pragma mark - Setup UI
- (void)configBackButtonForFutureView {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)setupRefreshControl {
    _refreshControl = [UIRefreshControl new];
    [_mainTableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)setupSearchBar {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [_searchBar setDelegate:self];
    [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    self.navigationItem.titleView = _searchBar;
}

- (void)setupUI {
    self.title = @"Stickers";
    [self setupSearchBar];
    [self setupRefreshControl];
    [self configBackButtonForFutureView];
}

#pragma mark - Refresh control delegate
- (void)refresh {
    [_requestingService getAllStickerPacksWithSuccess:^(NSArray *result) {
        _stickerPacks = result;
        [_mainTableView reloadData];
        [_refreshControl endRefreshing];
    }
                                              failure:^(NSError *error) {
                                                  [_refreshControl endRefreshing];
                                              }];
}

#pragma mark - Search bar delegates
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_searchBar setShowsCancelButton:YES animated:YES];
    _isSearching = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar setText:nil];
    [_searchBar endEditing:YES];
    _isSearching = NO;
    [_mainTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //Search and update table
    //NSLog(@"%@", searchText);
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    _searchResultStickerPacks = [_stickerPacks filteredArrayUsingPredicate:resultPredicate];
    [_mainTableView reloadData];
    
}

#pragma mark - Table view data source
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _isSearching ? _searchResultStickerPacks.count : _stickerPacks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PQStickerPackTableViewCell *cell = (PQStickerPackTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"StickerPackCell" forIndexPath:indexPath];
    
    NSArray *stickers = _isSearching ? _searchResultStickerPacks : _stickerPacks;
    
    [cell configCellUsingStickerPack:(PQStickerPack *)[stickers objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)computePackDescriptionHeightWithText:(NSString *)description {
    
    CGRect bound = [description boundingRectWithSize:CGSizeMake(_mainTableView.bounds.size.width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:15.0]}
                                             context:nil];
    return bound.size.height + 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *stickers = _isSearching ? _searchResultStickerPacks : _stickerPacks;
    CGFloat descriptionHeight = [self computePackDescriptionHeightWithText:[[stickers objectAtIndex:indexPath.row] packDescription]];
    //NSLog(@"%f", descriptionHeight + 270);
    return descriptionHeight + 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *stickers = _isSearching ? _searchResultStickerPacks : _stickerPacks;
    _selectedPack = [stickers objectAtIndex:indexPath.row];
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"GoToStickerPackSegue" sender:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GoToStickerPackSegue"]) {
        PQStickerListTableViewController *vc = (PQStickerListTableViewController *)[segue destinationViewController];
        [vc configUsingStickerPack:_selectedPack];
    }
}

@end
