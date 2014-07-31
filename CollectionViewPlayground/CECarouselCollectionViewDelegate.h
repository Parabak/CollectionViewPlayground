//
//  CECarouselCollectionViewDelegate.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

// for test
#import "CEFloatCollectionViewDelegate.h"

@interface CECarouselCollectionViewDelegate : NSObject <UICollectionViewDelegate> {
    
    NSTimer *_scrollingSettleTimer;
    UIScrollView *_scrollview;
    
    CGFloat _currentOffset;
    NSIndexPath *_selectedIndex;
}

@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, assign) CGFloat currentOffset;
@property (nonatomic, assign) CGFloat offsetBetweenIssues;
@property (nonatomic, strong) NSIndexPath* selectedIndex;

- (void) updateCurrentOffset: (UIScrollView*) scrollView;

// TODO: hide
- (CGFloat) offsetForItemAtIndex: (NSInteger)index;

@end
