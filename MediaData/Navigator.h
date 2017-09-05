//
//  Navigator.h
//  MediaData
//
//  Created by Vlad Naimark on 9/5/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

@import UIKit;

#import <Foundation/Foundation.h>

@class Navigator;

@protocol NavigatableVC <NSObject>

@property (nonatomic, weak) Navigator *navigator;

@end


@class Media;

@interface Navigator : NSObject

- (void)start;

- (void)didLogin;
- (void)didLogout;
- (void)showDetails:(Media*)media;
- (void)hideDetails;

@end
