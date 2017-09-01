//
//  UIImageView+MediaData.m
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import "UIImageView+MediaData.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (MediaData)

- (void)setImageFromURLString:(NSString *)imageURL
{
    [self setImageFromURL:[NSURL URLWithString:imageURL]];
}

- (void)setImageFromURL:(NSURL *)imageURL
{
    [self sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"no_image"] options:SDWebImageRetryFailed];
}

@end
