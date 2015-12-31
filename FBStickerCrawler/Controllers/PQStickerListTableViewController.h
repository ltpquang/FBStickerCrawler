//
//  PQStickerListTableViewController.h
//  FBStickerCrawler
//
//  Created by Le Thai Phuc Quang on 4/10/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PQImageDownloader.h"
@class PQStickerPack;

@interface PQStickerListTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PQImageDownloaderDelegate>
- (void)configUsingStickerPack:(PQStickerPack *)stickerPack;
@end
