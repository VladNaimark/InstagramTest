//
//  Navigator.m
//  MediaData
//
//  Created by Vlad Naimark on 9/5/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import "Navigator.h"
#import "MediaVC.h"
#import "MediaGridVC.h"
#import "LoginVC.h"
#import "UIStoryboard+MediaData.h"

typedef enum : NSUInteger {
    APP_STATE_LOGIN,
    APP_STATE_GRID,
    APP_STATE_DETAIL,
} APP_STATE;

@interface Navigator ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) APP_STATE appState;

@property (nonatomic, strong) UINavigationController *rootVC;
@property (nonatomic, strong) Media *media;

@end

@implementation Navigator

- (void)start
{
    self.rootVC = [UINavigationController new];
    _appState = APP_STATE_LOGIN;
    
    UIViewController<NavigatableVC> *loginVC = [self navigatableVCWithIdentifier:NSStringFromClass([LoginVC class])];
    loginVC.navigator = self;
    self.rootVC.viewControllers = @[loginVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.rootVC;
    [self.window makeKeyAndVisible];
}

- (void)didLogin
{
    self.appState = APP_STATE_GRID;
}

- (void)didLogout
{
    self.appState = APP_STATE_LOGIN;
}

- (void)showDetails:(Media*)media
{
    self.media = media;
    self.appState = APP_STATE_DETAIL;
}

- (void)hideDetails
{
    self.media = nil;
    self.appState = APP_STATE_GRID;
}

- (void)setAppState:(APP_STATE)appState
{
    if (appState == _appState)
    {
        return;
    }
    
    static NSDictionary *correctStateChanges;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        correctStateChanges = @{@(APP_STATE_LOGIN) : @[@(APP_STATE_GRID)],
                                @(APP_STATE_GRID) : @[@(APP_STATE_LOGIN), @(APP_STATE_DETAIL)],
                                @(APP_STATE_DETAIL) : @[@(APP_STATE_GRID)]};
    });
    
    if (![correctStateChanges[@(self.appState)] containsObject:@(appState)])
    {
        NSAssert(0, @"Unsupported state change %lu -> %lu", (unsigned long)_appState, (unsigned long)appState);
        return;
    }
    
    switch (appState)
    {
        case APP_STATE_LOGIN:
            if (_appState == APP_STATE_GRID)
            {
                [self.rootVC popViewControllerAnimated:YES];
            }
            break;
            
        case APP_STATE_GRID:
            if (_appState == APP_STATE_LOGIN)
            {
                UIViewController<NavigatableVC> *gridVC = [self navigatableVCWithIdentifier:NSStringFromClass([MediaGridVC class])];
                gridVC.navigator = self;
                [self.rootVC pushViewController:gridVC animated:YES];
            }
            else if (_appState == APP_STATE_DETAIL)
            {
                [self.rootVC popViewControllerAnimated:YES];
            }
            break;
            
        case APP_STATE_DETAIL:
            if (_appState == APP_STATE_GRID)
            {
                MediaVC *mediaVC = (MediaVC*)[self navigatableVCWithIdentifier:NSStringFromClass([MediaVC class])];
                mediaVC.media = self.media;
                mediaVC.navigator = self;
                [self.rootVC pushViewController:mediaVC animated:YES];
            }
            break;
    }
    
    _appState = appState;
}

- (UIViewController<NavigatableVC>*)navigatableVCWithIdentifier:(NSString*)identifier
{
    UIViewController<NavigatableVC>* vc = [[UIStoryboard main] instantiateViewControllerWithIdentifier:identifier];
    if ([vc conformsToProtocol:@protocol(NavigatableVC)])
    {
        return vc;
    }
    return nil;
}

@end
