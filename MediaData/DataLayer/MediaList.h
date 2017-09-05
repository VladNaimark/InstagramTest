//
//  MediaList.h
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Media;

@interface MediaList : NSObject

+ (instancetype)mediaListWithDictionary:(NSDictionary*)data;
- (void)updateWithDictionary:(NSDictionary*)data;

@property (nonatomic, readonly) NSArray<Media*> *media;
@property (nonatomic, readonly) NSString *nextPageUrl;

@end
