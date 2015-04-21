//
//  PQStickerPackTableViewCell.m
//  FBStickerCrawler
//
//  Created by Le Thai Phuc Quang on 4/10/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "PQStickerPackTableViewCell.h"
#import "PQStickerPack.h"
#import <UIImageView+AFNetworking.h>

@interface PQStickerPackTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *packDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *preview0ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *preview1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *preview2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *preview3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *preview4ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *preview5ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *preview6ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *preview7ImageView;
@end

@implementation PQStickerPackTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellUsingStickerPack:(PQStickerPack *)stickerPack {
    _nameLabel.text = stickerPack.name;
    _artistLabel.text = stickerPack.artist;
    _packDescriptionLabel.text = stickerPack.packDescription;
    
    _thumbnailImageView.image = nil;
    [_thumbnailImageView setImageWithURL:[NSURL URLWithString:stickerPack.thumbnail]];
    
    NSArray *previewImageViews = @[_preview0ImageView,
                                   _preview1ImageView,
                                   _preview2ImageView,
                                   _preview3ImageView,
                                   _preview4ImageView,
                                   _preview5ImageView,
                                   _preview6ImageView,
                                   _preview7ImageView];
    
    for (int i = 0; i < previewImageViews.count; ++i) {
        UIImageView *iv = [previewImageViews objectAtIndex:i];
        iv.image = nil;
        [iv setImageWithURL:[NSURL URLWithString:[stickerPack.previews objectAtIndex:i]]];
    }
}
@end
