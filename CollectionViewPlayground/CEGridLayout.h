//
//  CEGridLayout.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/9/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kIssueLayoutAlbumTitleKind;

static NSUInteger const kRotationCount = 32;
static NSUInteger const kRotationStride = 3;
static NSUInteger const kIssueCellBaseZIndex = 100;

@interface CEGridLayout : UICollectionViewLayout 

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;

@property (nonatomic) CGFloat titleHeight;

@end
