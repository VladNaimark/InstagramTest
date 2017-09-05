//
//  MediaVM.m
//  MediaData
//
//  Created by Vlad Naimark on 9/5/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import "MediaVM.h"
#import "Media.h"

@interface MediaVM ()

@property (nonatomic, strong) Media *media;

@end


@implementation MediaVM

+ (instancetype)createWithMedia:(Media *)media
{
    if (!media)
    {
        return nil;
    }
    
    MediaVM *instance = [[MediaVM alloc] initWithMedia:media];
    return instance;
}

-(instancetype)initWithMedia:(Media*)media
{
    if (!media)
    {
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        self.media = media;
    }
    return self;
}

- (NSString*)commentCountText
{
    return [NSString stringWithFormat:@"%d", self.media.commentsCount];
}

- (NSString*)likeCountText
{
    return [NSString stringWithFormat:@"%d", self.media.likesCount];
}

- (NSString*)tagsText
{
    NSMutableString *tags = [NSMutableString new];
    for (NSString *tag in self.media.tags)
    {
        if (tags.length)
        {
            [tags appendString:@"\n"];
        }
        [tags appendString:@"#"];
        [tags appendString:tag];
    }
    return [NSString stringWithString:tags];
}

@end
