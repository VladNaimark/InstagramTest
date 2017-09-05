//
//  MediaVC.h
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigatableVC.h"

@class Media;

@interface MediaVC : NavigatableVC

@property (nonatomic, strong) Media *media;

@end
