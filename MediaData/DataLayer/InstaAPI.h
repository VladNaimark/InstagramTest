//
//  InstaAPI.h
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MediaList;

@interface InstaAPI : NSObject

+(instancetype)sharedInstance;

@property (nonatomic, readonly) NSURL *loginURL;
@property (nonatomic, readonly) NSString *accessToken;

- (BOOL)checkAndUpdateToken:(NSURL*)url;

- (void)logout;
- (void)getMedia:(MediaList *)mediaList count:(int)count completion:(void(^)(MediaList *mediaList, NSError *error))completion;

@end
