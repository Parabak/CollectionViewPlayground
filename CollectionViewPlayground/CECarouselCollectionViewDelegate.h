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

@protocol CECarouselSelectionDelegate <NSObject>

@required

- (void) itemSelectedAtIndexPath: (NSIndexPath *) indexPath;

@end

@interface CECarouselCollectionViewDelegate : NSObject <UICollectionViewDelegate> {
    
    NSTimer *_scrollingSettleTimer;
    UIScrollView *_scrollview;
    
    CGFloat _currentOffset;
    CGFloat _previousOffset;
    NSIndexPath *_selectedIndex;
    
    BOOL _rigthScrollingDirection;
}

@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, assign) CGFloat currentOffset;
@property (nonatomic, assign) CGFloat offsetBetweenIssues;
@property (nonatomic, strong) NSIndexPath* selectedIndex;

@property (nonatomic, assign) id<CECarouselSelectionDelegate> delegate;

- (void) updateCurrentOffset: (UIScrollView*) scrollView;

// TODO: hide
- (CGFloat) offsetForItemAtIndex: (NSInteger)index;

@end
