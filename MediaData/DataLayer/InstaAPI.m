//
//  InstaAPI.m
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import <AFNetworking.h>
#import "InstaAPI.h"
#import "MediaList.h"
#import "Constants.h"

static NSString *const CLIENT_SECRET = @"7a316fbc1ac14f139ab4045442fcfd62";
static NSString *const CLIENT_ID = @"515632bc76bb4f8ea4702243d86a1422";
static NSString *const REDIRECT_URI = @"https://mediadata.com/auth/instagram/callback";

static NSString *const LOGIN_URL = @"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token";
static NSString *const RECENT_MEDIA_ENDPOINT = @"/users/self/media/recent/";
static NSString *const API_BASE = @"api.instagram.com/v1/";


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
        self.loginURL = [NSURL URLWithString:[NSString stringWithFormat:LOGIN_URL, CLIENT_ID, REDIRECT_URI]];
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
    static NSArray *instagramCookieDomains;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instagramCookieDomains = @[@"www.instagram.com", @"api.instagram.com"];
    });
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableArray *cookiesToClean = [NSMutableArray new];
    for (NSHTTPCookie *cookie in cookieStorage.cookies)
    {
        if ([instagramCookieDomains containsObject:cookie.domain])
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
    [self sendRequestToEndPoint:mediaList ? mediaList.nextPageUrl : RECENT_MEDIA_ENDPOINT
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
    if ([endPoint hasPrefix:@"http"])
    {
        url = endPoint;
    }
    else
    {
        url = [@"https://" stringByAppendingString:[API_BASE stringByAppendingPathComponent:endPoint]];
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
            completion(nil, nil, [NSError errorWithDomain:ERROR_DOMAIN
                                                     code:-1001
                                                 userInfo:@{NSLocalizedDescriptionKey : LOCALIZE(@"Network request is not available", @"Error")}]);
        }
    }
}

@end
