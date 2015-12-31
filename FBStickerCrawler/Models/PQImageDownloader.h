//
//  PQImageDownloader.h
//  FBStickerCrawler
//
//  Created by Le Thai Phuc Quang on 6/12/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PQSticker.h"

@protocol PQImageDownloaderDelegate;

@interface PQImageDownloader : NSOperation
@property (nonatomic, assign) id<PQImageDownloaderDelegate> downloaderDelegate;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) PQSticker *sticker;

- (id)initWithSticker:(PQSticker *)sticker
          atIndexPath:(NSIndexPath *)indexPath
             delegate:(id<PQImageDownloaderDelegate>)delegate;
@end

@protocol PQImageDownloaderDelegate <NSObject>
- (void)imageDownloaderDidFinish:(PQImageDownloader *)downloader;
@end