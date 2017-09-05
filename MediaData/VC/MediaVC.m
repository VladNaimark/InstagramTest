//
//  MediaVC.m
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import "MediaVC.h"
#import "UIImageView+MediaData.h"
#import "Media.h"

@interface MediaVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@end

@implementation MediaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configure];
}

- (void)setMedia:(Media *)media
{
    _media = media;
    if (!self.viewLoaded)
    {
        return;
    }
    
    [self configure];
}

- (void)configure
{
    [self.imageView setImageFromURLString:self.media.standartImage];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d", self.media.commentsCount];
    self.likesCountLabel.text = [NSString stringWithFormat:@"%d", self.media.likesCount];
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
    self.tagsLabel.text = tags;
}

@end
