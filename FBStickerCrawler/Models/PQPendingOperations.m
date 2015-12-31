//
//  PQPendingOperations.m
//  FBStickerCrawler
//
//  Created by Le Thai Phuc Quang on 6/12/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "PQPendingOperations.h"

@implementation PQPendingOperations
- (NSMutableDictionary *)downloadsInProgress {
    if (!_downloadsInProgress) {
        _downloadsInProgress = [[NSMutableDictionary alloc] init];
    }
    return _downloadsInProgress;
}

- (NSOperationQueue *)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.name = @"Download Queue";
        _downloadQueue.maxConcurrentOperationCount = 1;
    }
    return _downloadQueue;
}
@end
