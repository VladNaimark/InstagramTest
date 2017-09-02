//
//  InstaAPI.m
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import <AFNetworking.h>
#import "InstaAPI.h"
#import "Constants.h"


@interface InstaAPI () <NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURL *loginURL;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation InstaAPI

+(instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.loginURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token", CLIENT_ID, REDIRECT_URI]];
        self.accessToken = @"";
        self.sessionManager = [AFHTTPSessionManager new];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer new];
    }
    return self;
}

- (BOOL)checkAndUpdateToken:(NSURL*)url
{
    NSString *sURL = url.absoluteString;
    NSRange range = [sURL rangeOfString:REDIRECT_URI];
    if (range.location != 0)
    {
        return NO;
    }
    
    NSString *template = [NSString stringWithFormat:@"%@#access_token=", REDIRECT_URI];
    self.accessToken = [sURL stringByReplacingOccurrencesOfString:template withString:@""];
    return YES;
}

- (void)logout
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableArray *cookiesToClean = [NSMutableArray new];
    for (NSHTTPCookie *cookie in cookieStorage.cookies)
    {
        if ([cookie.domain isEqualToString:@"www.instagram.com"] || [cookie.domain isEqualToString:@"api.instagram.com"])
        {
            [cookiesToClean addObject:cookie];
        }
    }
    for (NSHTTPCookie *cookie in cookiesToClean)
    {
        [cookieStorage deleteCookie:cookie];
    }
    self.accessToken = @"";
}

- (void)getMedia:(MediaList *)mediaList count:(int)count completion:(void(^)(MediaList *mediaList, NSError *error))completion;
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (!mediaList.nextPageUrl)
    {
        params[@"count"] = @(count);
    }
    [self sendRequestToEndPoint:mediaList ? mediaList.nextPageUrl : @"/users/self/media/recent/"
                 withParameters:params
                     completion:^(NSHTTPURLResponse *response, NSDictionary *data, NSError *error)
     {
         if (error)
         {
             if (completion)
             {
                 completion(nil, error);
             }
             return;
         }
         
         MediaList *currentMediaList = mediaList;
         [currentMediaList updateWithDictionary:data];
         if (!currentMediaList)
         {
             currentMediaList = [MediaList mediaListWithDictionary:data];
         }
         
         if (completion)
         {
             completion(currentMediaList, error);
         }
     }];
}

#pragma mark - private

- (void)sendRequestToEndPoint:(NSString*)endPoint withParameters:(NSDictionary*)parameters completion:(void (^)(NSHTTPURLResponse *response, NSDictionary *data, NSError *error))completion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    params[@"access_token"] = self.accessToken;
    NSString *url;
    if ([endPoint rangeOfString:@"http"].location == 0)
    {
        url = endPoint;
    }
    else
    {
        url = [@"https://" stringByAppendingString:[@"api.instagram.com/v1/" stringByAppendingPathComponent:endPoint]];
    }
    NSURLSessionDataTask *task = [self.sessionManager GET:url
                                               parameters:params
                                                 progress:nil
                                                  success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject)
                                  {
                                      if (completion)
                                      {
                                          completion((NSHTTPURLResponse *) task.response, responseObject, nil);
                                      }
                                  }
                                                  failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error)
                                  {
                                      if (completion)
                                      {
                                          completion((NSHTTPURLResponse *) task.response, nil, error);
                                      }
                                  }];
    if (!task)
    {
        if (completion)
        {
            completion(nil, nil, [NSError errorWithDomain:@"com.mediadata" code:-1001 userInfo:@{NSLocalizedDescriptionKey : @"Network request is not available"}]);
        }
    }
}

@end
