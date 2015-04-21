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

- (void)configCellUsingSticker:(PQSticker *)sticker {
    _mainImage.image = nil;
    [_loadingIndicator startAnimating];
    [sticker populateStickerToUIImageVIew:_mainImage
                               onComplete:^{
                                   [_loadingIndicator stopAnimating];
                               }];
}

@end
