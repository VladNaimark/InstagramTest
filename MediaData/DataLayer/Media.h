//
//  Media.h
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Media : NSObject

+ (instancetype)mediaWithDictionary:(NSDictionary*)data;

@property (nonatomic, readonly) NSString *ID;
@property (nonatomic, readonly) NSString *thumbnail;
@property (nonatomic, readonly) NSString *standartImage;
@property (nonatomic, readonly) int likesCount;
@property (nonatomic, readonly) int commentsCount;
@property (nonatomic, readonly) NSArray<NSString*> *tags;

@end
