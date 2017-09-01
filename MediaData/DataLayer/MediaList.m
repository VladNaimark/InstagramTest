//
//  MediaList.m
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import "MediaList.h"

@interface MediaList ()

@property (nonatomic, strong) NSArray<Media*> *media;
@property (nonatomic, strong) NSString *nextPageUrl;

@end

@implementation MediaList

+ (instancetype)mediaListWithDictionary:(NSDictionary*)data
{
    MediaList *list = [MediaList new];
    [list updateWithDictionary:data];
    return list;
}

- (void)updateWithDictionary:(NSDictionary*)data
{
    self.nextPageUrl = data[@"pagination"][@"next_url"];
    NSMutableArray *media = [NSMutableArray arrayWithArray:self.media];
    for (NSDictionary *mediaData in data[@"data"])
    {
        [media addObject:[Media mediaWithDictionary:mediaData]];
    }
    
    self.media = [NSArray arrayWithArray:media];
}

@end
