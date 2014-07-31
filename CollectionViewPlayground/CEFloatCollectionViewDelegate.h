//
//  CECollectionViewDelegate.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/9/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <Foundation/Foundation.h>
 

@interface CEFloatCollectionViewDelegate : NSObject <UICollectionViewDelegate> {
    
    NSTimer *_scrollingSettleTimer;
    UIScrollView *_scrollview;
    
    CGFloat _currentOffset;
    NSIndexPath *_selectedIndex;
}

@property (nonatomic, assign) CGFloat currentOffset;

@property (nonatomic, assign) CGFloat offsetBetweenIssues;

@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, strong) NSIndexPath* selectedIndex;

// hide it
//- (void) decelerationSettled;



@end
