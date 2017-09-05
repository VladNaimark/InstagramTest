//
//  NavigatableVC.h
//  MediaData
//
//  Created by Vlad Naimark on 9/5/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Navigator.h"

@interface NavigatableVC : UIViewController<NavigatableVC>

@property (nonatomic, weak) Navigator* navigator;

@end
