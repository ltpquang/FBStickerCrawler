//
//  PQUrlService.m
//  FBStickerCrawler
//
//  Created by Le Thai Phuc Quang on 4/10/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "PQUrlService.h"

@implementation PQUrlService
+ (NSString *)baseUrl {
    return @"http://audeecon.herokuapp.com/api/v1/packs";
}

+ (NSString *)urlToGetAllStickerPacks {
    NSString *result = [NSString stringWithFormat:@"%@", [self baseUrl]];
    NSLog(@"%@", result);
    return result;
}

+ (NSString *)urlToGetAllStickerPacksForUser:(NSString *)username {
    return [NSString new];
}

+ (NSString *)urlToGetStickerPackWithId:(NSString *)packId {
    //?size=240
    NSString *result = [NSString stringWithFormat:@"%@/%@?size=240", [self urlToGetAllStickerPacks], packId];
    NSLog(@"%@", result);
    return result;
}
@end
