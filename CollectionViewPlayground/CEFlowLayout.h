//
//  CEFlowLayout.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/10/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEFlowContentInfoView.h"

//extern CGFloat const kIssueOffset;
//extern CGFloat const kTitleHeight;

extern NSString * const kFloatLayoutIssueTitleKind;

@interface CEFlowLayout : UICollectionViewLayout

@property (nonatomic, assign) UIEdgeInsets itemInsets;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) NSInteger numberOfColumns;

@property (nonatomic, assign) CGFloat titleHeight;

- (void) setupForOrientation: (UIInterfaceOrientation) interfaceOrientation;


// statis Methods
+ (CGFloat) getOffset;

@end
