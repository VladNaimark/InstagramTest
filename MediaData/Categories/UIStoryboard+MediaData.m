//
//  UIStoryboard+MediaData.m
//  MediaData
//
//  Created by Vlad Naimark on 9/5/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import "UIStoryboard+MediaData.h"

@implementation UIStoryboard (MediaData)

+ (UIStoryboard*)main
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
}

@end
