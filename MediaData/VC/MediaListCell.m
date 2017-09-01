//
//  MediaListCell.m
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import "MediaListCell.h"
#import "UIImageView+MediaData.h"

@interface MediaListCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MediaListCell

- (void)setMedia:(Media *)media
{
    _media = media;
    [self.imageView setImageFromURLString:self.media.thumbnail];
}

@end
