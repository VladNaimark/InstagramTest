//
//  MediaListCell.h
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;

@interface MediaListCell : UICollectionViewCell

@property (nonatomic, strong) Media* media;

@end
