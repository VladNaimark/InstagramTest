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
#import "MediaVM.h"

@interface MediaVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property (nonatomic, strong) MediaVM *mediaVM;

@end

@implementation MediaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configure];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:LOCALIZE(@"Back", @"General")
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(back:)];
    self.navigationItem.leftBarButtonItem=newBackButton;
}

- (void)back:(id)sender
{
    [self.navigator hideDetails];
}

- (void)setMedia:(Media *)media
{
    _media = media;
    self.mediaVM = [MediaVM createWithMedia:media];
    if (!self.viewLoaded)
    {
        return;
    }
    
    [self configure];
}

- (void)configure
{
    [self.imageView setImageFromURLString:self.media.standartImage];
    self.commentCountLabel.text = self.mediaVM.commentCountText;
    self.likesCountLabel.text = self.mediaVM.likeCountText;
    self.tagsLabel.text = self.mediaVM.tagsText;
}

@end
