//
//  Media.m
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import "Media.h"

@interface Media ()

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *standartImage;
@property (nonatomic, assign) int likesCount;
@property (nonatomic, assign) int commentsCount;
@property (nonatomic, strong) NSArray<NSString*> *tags;

@end

@implementation Media

+ (instancetype)mediaWithDictionary:(NSDictionary*)data
{
    Media *media = [Media new];
    media.ID = data[@"id"];
    media.thumbnail = data[@"images"][@"thumbnail"][@"url"];
    media.standartImage = data[@"images"][@"standard_resolution"][@"url"];
    media.likesCount = [data[@"likes"][@"count"] intValue];
    media.commentsCount = [data[@"comments"][@"count"] intValue];
    media.tags = data[@"tags"];
    return media;
}

@end
