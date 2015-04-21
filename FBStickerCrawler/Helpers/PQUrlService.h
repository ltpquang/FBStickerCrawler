//
//  PQUrlService.h
//  FBStickerCrawler
//
//  Created by Le Thai Phuc Quang on 4/10/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PQUrlService : NSObject
+ (NSString *)urlToGetAllStickerPacks;
+ (NSString *)urlToGetStickerPackWithId:(NSString *)packId;
@end
