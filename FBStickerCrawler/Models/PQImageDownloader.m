//
//  PQImageDownloader.m
//  FBStickerCrawler
//
//  Created by Le Thai Phuc Quang on 6/12/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "PQImageDownloader.h"
#import <UIKit/UIKit.h>
#import "UIImage+Sprite.h"

@implementation PQImageDownloader

- (id)initWithSticker:(PQSticker *)sticker
          atIndexPath:(NSIndexPath *)indexPath
             delegate:(id<PQImageDownloaderDelegate>)delegate {
    if ([super init]) {
        _sticker = sticker;
        _indexPath = indexPath;
        _downloaderDelegate = delegate;
    }
    return self;
}

- (void)main {
    @autoreleasepool {
        if (self.isCancelled) {
            return;
        }
        
        NSString *imgUri = _sticker.frameCount == 1 ? _sticker.uri : _sticker.spriteUri;
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUri]];
        
        if (self.isCancelled) {
            imgData = nil;
            return;
        }
        
        UIImage *img = [UIImage imageWithData:imgData];
        if (_sticker.frameCount == 1) {
            _sticker.spriteArray = @[img];
        }
        else {
            _sticker.spriteArray = [img spritesWithSpriteSheetImage:img
                                                        columnCount:(_sticker.frameCount - 1) / _sticker.framesPerCol + 1
                                                           rowCount:(_sticker.frameCount - 1) / _sticker.framesPerRow + 1
                                                        spriteCount:_sticker.frameCount];
        }
        //img = nil;
        imgData = nil;
        
        if (self.isCancelled) {
            return;
        }
        
        [(NSObject *)self.downloaderDelegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:)
                                                              withObject:self
                                                           waitUntilDone:NO];
    }
}

@end
