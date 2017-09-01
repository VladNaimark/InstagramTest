//
//  UIImageView+MediaData.h
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MediaData)

- (void)setImageFromURL:(NSURL *)imageURL;
- (void)setImageFromURLString:(NSString *)imageURL;

@end
