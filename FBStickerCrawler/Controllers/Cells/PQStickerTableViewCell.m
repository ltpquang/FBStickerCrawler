//
//  PQStickerTableViewCell.m
//  FBStickerCrawler
//
//  Created by Le Thai Phuc Quang on 4/10/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "PQStickerTableViewCell.h"
#import "PQSticker.h"

@interface PQStickerTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end


@implementation PQStickerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)startLoadingIndicator:(BOOL)start {
    if (start) {
        [_loadingIndicator startAnimating];
    }
    else {
        [_loadingIndicator stopAnimating];
    }
}

- (void)resetContent {
    _mainImage.image = nil;
}

- (void)configCellUsingSticker:(PQSticker *)sticker {
    _mainImage.image = nil;
    CGRect frame = _mainImage.frame;
    frame.size = CGSizeMake(sticker.width, sticker.height);
    _mainImage.frame = frame;
    [sticker populateStickerToUIImageVIew:_mainImage
                               onComplete:^{
                                   [_loadingIndicator stopAnimating];
                               }];
}

@end
