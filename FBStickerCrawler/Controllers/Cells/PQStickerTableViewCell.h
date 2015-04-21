//
//  PQStickerTableViewCell.h
//  FBStickerCrawler
//
//  Created by Le Thai Phuc Quang on 4/10/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PQSticker;

@interface PQStickerTableViewCell : UITableViewCell
- (void)configCellUsingSticker:(PQSticker *)sticker;
@end
