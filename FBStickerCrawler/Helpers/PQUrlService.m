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
    return @"http://audeecon.herokuapp.com/api/v1/packs/";
}

+ (NSString *)urlToGetAllStickerPacks {
    return [NSString stringWithFormat:@"%@", [self baseUrl]];
}

+ (NSString *)urlToGetStickerPackWithId:(NSString *)packId {
    return [NSString stringWithFormat:@"%@/%@", [self urlToGetAllStickerPacks], packId];
}
@end
