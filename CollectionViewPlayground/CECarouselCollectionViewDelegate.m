//
//  CECarouselCollectionViewDelegate.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECarouselCollectionViewDelegate.h"

#import "CECarouselLayout.h"
#import "CECarouselItemView.h"
#import "CECarouselAnimations.h"

#define SCROLL_DURATION 0.4

@interface CECarouselCollectionViewDelegate () {
    
    CGFloat _toggle;
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) NSTimeInterval toggleTime;

@property (nonatomic, assign) CGFloat startVelocity;

@property (nonatomic, assign) CGFloat endOffset;

@property (nonatomic, assign, getter = isScrolling) BOOL scrolling;

@end


@implementation CECarouselCollectionViewDelegate

@synthesize selectedIndex = _selectedIndex;
@synthesize currentOffset = _currentOffset;

#pragma mark -
#pragma mark - Properties

- (CGFloat) offsetBetweenIssues {

    return [CECarouselLayout getOffset];
}

- (NSIndexPath *) selectedIndex {
    
    if (_selectedIndex == nil) {
        
        _selectedIndex = [NSIndexPath indexPathForItem: 0 inSection: 0];
    }
    
    return _selectedIndex;
}

#pragma mark -
#pragma mark - Collection View delegate
- (void)collectionView: (UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedIndex.item != indexPath.item || self.selectedIndex.section != indexPath.section) {
        
        // issue should be centered
        _currentOffset = indexPath.item;
        
        [self scrollToOffset];
    } else {
        
        // open issue
        for (CEFlowContentInfoView *cell in collectionView.visibleCells) {
            
            if (cell.tag == indexPath.item && cell.isEnabled) {
                
                [self openIssue: cell];
            }
        }
    }
    
    self.selectedIndex = indexPath;
    
    [_scrollingSettleTimer invalidate];
	_scrollingSettleTimer = nil;
}

#pragma mark -
#pragma mark - Scroll View Delegate

- (void) scrollViewDidScroll: (UIScrollView *)scrollView {
    
    _rigthScrollingDirection = (scrollView.contentOffset.x - _previousOffset) > 0.0f;
    _previousOffset = scrollView.contentOffset.x;
    
    [self updateCurrentOffset: scrollView];
}

- (void) scrollViewDidEndDragging: (UIScrollView *) scrollView willDecelerate: (BOOL) decelerate {
    
    _scrollview = scrollView;
    
	if(!decelerate) {
        
        [self scrollToOffset];
	}
}

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView {
    
	/*
	 We cannot call scrollRectToVisible directly here because iOS 6 sends scrollViewDidEndDecelerating even
	 when the user stops a deceleration animation by dragging in the other direction. Technically, this is correct
	 since the speed does equal 0 at that point. However, it would cause flickering - see Chili issue #249.
	 */
    
    _scrollview = scrollView;
    
	[_scrollingSettleTimer invalidate];
	_scrollingSettleTimer = [NSTimer scheduledTimerWithTimeInterval: 0.2 target: self selector: @selector(decelerationSettled) userInfo: nil repeats: NO];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	
    _scrollview = scrollView;
    
	[_scrollingSettleTimer invalidate];
	_scrollingSettleTimer = nil;
}

- (void) decelerationSettled {
    
    [self scrollToOffset];
    
	[_scrollingSettleTimer invalidate];
	_scrollingSettleTimer = nil;
}

- (void) scrollToOffset {

    [_scrollview scrollRectToVisible: CGRectIntegral( CGRectMake(self.offsetBetweenIssues * [self normalizedOffset], 0,
                                                                 _scrollview.frame.size.width,
                                                                 _scrollview.frame.size.height) )
                            animated: YES];
}


#pragma mark -
#pragma mark - Scroll View Delegate

- (void) updateCurrentOffset: (UIScrollView*) scrollView {
    
    _previousOffset = _currentOffset;
    _currentOffset = (scrollView.contentOffset.x / (self.offsetBetweenIssues));
    
    self.selectedIndex = [NSIndexPath indexPathForItem: [self normalizedOffset] inSection: 0];
    
    CGFloat numberOfItems = [self getNumberOfItems];
    if (_currentOffset >= 0.0f && _currentOffset <= (numberOfItems - 1)) {
        
        [self transformItemViews];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Transformation

- (void) transformItemViews {
    
    NSMutableArray *animatedItems = [NSMutableArray array];
    
    for (UIView *issueView in _scrollview.subviews) {
                
        CGFloat offset = [self offsetForItemAtIndex: issueView.tag];
        
        if ([issueView respondsToSelector: @selector(calculateTransformationForOffset:)]) {

            [((CECarouselItemView*) issueView) calculateTransformationForOffset: offset];
        }
                
        if ([issueView respondsToSelector: @selector(shouldBeAnimated)]) {

            if (((CECarouselItemView*)issueView).shouldBeAnimated) {
            
                [animatedItems addObject: issueView];
            }
        }
    }
    
    [self animateItems: animatedItems];
}

- (void) animateItems: (NSArray *) animatedItems {
    
    for (NSInteger index = 0; index < animatedItems.count; index++) {
        
        CECarouselItemView *item = animatedItems[index];
        
        if (item.shouldBeAnimated) {
            
            [UIView animateWithDuration: SCROLL_DURATION
                                  delay: 0.0f
                                options: 0.0f
                             animations: ^{
                
                                 item.layer.transform = item.transform3D;
                
                                 if (item.tag == [self normalizedOffset]) {
                    
                                     [_scrollview bringSubviewToFront: item];
                                 }
                                
            } completion: nil];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
#pragma mark - Calculations

- (CGFloat) offsetForItemAtIndex: (NSInteger)index
{
    //calculate relative position
    CGFloat offset = index - [self normalizedOffset];//_currentOffset;
    
    if ([self getNumberOfItems] == 1)
    {
        offset = 0.0f;
    }
    
    return offset;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Methods
- (void) openIssue:(UICollectionViewCell *)sender {
    
    [self animateTransformsInItem: sender];
}

- (CGFloat) getNumberOfItems {
    
    UICollectionView *castedScrollView = (UICollectionView*) self.scrollview;
    CGFloat numberOfItems = [castedScrollView.dataSource collectionView: castedScrollView numberOfItemsInSection: 0];
    
    return numberOfItems;
}

- (void) animateTransformsInItem: (UICollectionViewCell *) item {
    
    CAKeyframeAnimation *bouncingAnimation = [CECarouselAnimations bouncingAnimationForItem: item];
    [item.layer addAnimation: bouncingAnimation forKey: @"bouncing"];
}

- (float) normalizedOffset {
    
    double intPart = 0.0f;
    float fractPart = modf((double)_currentOffset, &intPart);
    
    CGFloat normalizedOffset = _currentOffset;
    if (_rigthScrollingDirection) {
        
        if (fractPart >= 0.8f) {
            
            normalizedOffset = ceilf(_currentOffset);
        } else {
            
            normalizedOffset = floorf(_currentOffset);
        }
    } else {
        
        if (fractPart <= 0.2f) {
            
            normalizedOffset = floorf(_currentOffset);
        } else {
            
            normalizedOffset = ceilf(_currentOffset);
        }
    }
    
    return normalizedOffset;
}

@end
