//
//  MediaVM.h
//  MediaData
//
//  Created by Vlad Naimark on 9/5/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Media;

@interface MediaVM : NSObject

+(instancetype)createWithMedia:(Media*)media;
-(instancetype)initWithMedia:(Media*)media;
-(instancetype)init NS_UNAVAILABLE;

@property (nonatomic, readonly) Media *media;

@property (nonatomic, readonly) NSString *commentCountText;
@property (nonatomic, readonly) NSString *likeCountText;
@property (nonatomic, readonly) NSString *tagsText;

@end
