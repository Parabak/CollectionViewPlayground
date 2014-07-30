//
//  CECarouselCollectionViewDelegate.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECarouselCollectionViewDelegate.h"

#import "CECarouselLayout.h"
#import "CEFlowContentInfoView.h"

#define MIN_TOGGLE_DURATION 0.2
#define MAX_TOGGLE_DURATION 0.4
#define SCROLL_DURATION 0.4

@interface CECarouselCollectionViewDelegate () {
    
    CGFloat _toggle;
    CGFloat _previousOffset;
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


#pragma mark -
#pragma mark - Properties

- (CGFloat) offsetBetweenIssues {

//    return 65 + 35;
//    return (35.0f + 265 / 4);
//    return (35.0f + 265 / 2) * 0.5;
    return [CECarouselLayout getOffset];
}

#pragma mark -
#pragma mark - Scroll View Delegate

- (void) updateCurrentOffset: (UIScrollView*) scrollView {
    
    _previousOffset = _currentOffset;
    _currentOffset = (scrollView.contentOffset.x / (self.offsetBetweenIssues));
    
//    NSLog(@"_currentOffset %f",_currentOffset);
    
    self.selectedIndex = [NSIndexPath indexPathForItem: roundf(_currentOffset) inSection: 0];
    
    // TODO: here we should use borders
    if (_currentOffset >= 0.0f && _currentOffset <= 19) {
        
        [self transformItemViews];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [super scrollViewDidScroll: scrollView];
    
//    NSLog(@"did scroll %f", scrollView.contentOffset.x);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private 

- (void) scrollToOffset {
    
    
    [_scrollview scrollRectToVisible: CGRectIntegral( CGRectMake([self offsetBetweenIssues] * lroundf(_currentOffset), 0,
                                                                 _scrollview.frame.size.width,
                                                                 _scrollview.frame.size.height) )
                            animated: YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Transformation

- (void) transformItemViews {
    
    NSMutableArray *animatedItems = [NSMutableArray array];
    
    for (UIView *issueView in _scrollview.subviews) {
        
        // it can be calculated in itemview
        
        CGFloat offset = [self offsetForItemAtIndex: issueView.tag];
        
        if ([issueView respondsToSelector: @selector(calculateTransformationForOffset:)]) {

            [((CEFlowContentInfoView*) issueView) calculateTransformationForOffset: offset];
        }
                
        if ([issueView respondsToSelector: @selector(shouldBeAnimated)]) {

            if (((CEFlowContentInfoView*)issueView).shouldBeAnimated) {
            
                [animatedItems addObject: issueView];
            }
        }
    }
    
    [self animateItems: animatedItems];
}

- (void) animateItems: (NSArray *) animatedItems {
    
    for (NSInteger index = 0; index < animatedItems.count; index++) {
        
        CEFlowContentInfoView *item = animatedItems[index];
        
        if (item.shouldBeAnimated) {
            
            [UIView animateWithDuration: 0.4f
                                  delay: 0.0f
                                options: 0.0f //UIViewAnimationOptionBeginFromCurrentState
                             animations: ^{
                
                item.layer.transform = item.transform3D;
                
                                 if (item.tag == 1) {
                                     
                                     [CEFlowContentInfoView printTransformMatrix: item.layer.transform];
                                 }
                                 
                if (item.tag == lroundf(_currentOffset)) {
                    
                    [_scrollview bringSubviewToFront: item];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    NSMutableArray *remainItems = [NSMutableArray array];
                    
                    for (NSInteger remainIndex = index + 1; remainIndex < animatedItems.count; remainIndex++) {
                        
                        if (remainIndex < animatedItems.count ) {
                            
                            [remainItems addObject: animatedItems[remainIndex]];
                        }
                    }

                    [self animateItems: remainItems];
                });
                
            } completion:^(BOOL finished) {
                
                if (item.tag == 0) {
                    
//                    NSLog(@"frame %@", NSStringFromCGRect(item.frame));
                }
            }];
            
            break;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
#pragma mark - Calculations

- (CGFloat) offsetForItemAtIndex: (NSInteger)index
{
    //calculate relative position
    CGFloat offset = index - _currentOffset;
    
    CGFloat _numberOfItems = 20.0f;

    if (_numberOfItems == 1)
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

// TODO: move out it to 'Animation' class
- (void) animateTransformsInItem: (UICollectionViewCell *) item {
    
    CAKeyframeAnimation *boundsOvershootAnimation = [CAKeyframeAnimation animationWithKeyPath: @"transform"];
    
    CATransform3D startingScale = CATransform3DIdentity;
    CATransform3D undershootScale = CATransform3DTranslate(item.layer.transform, 0.0f, 0.0f, -50.0f);
    CATransform3D overshootScale = CATransform3DTranslate(item.layer.transform, 0.0f, 0.0f, 300.0f);
    
    NSArray *boundsValues = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:startingScale],
                             [NSValue valueWithCATransform3D: undershootScale],
                             [NSValue valueWithCATransform3D :overshootScale], nil];
    [boundsOvershootAnimation setValues:boundsValues];

    NSArray *times = [NSArray arrayWithObjects:[NSNumber numberWithFloat: 0.0f],
                                               [NSNumber numberWithFloat: 0.2f],
                                                [NSNumber numberWithFloat: 1.0f], nil];
    [boundsOvershootAnimation setKeyTimes:times];
    [boundsOvershootAnimation setDuration: 0.6f];

    NSArray *timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], nil];
                      
    [boundsOvershootAnimation setTimingFunctions:timingFunctions];
    boundsOvershootAnimation.fillMode = kCAFillModeForwards;
    boundsOvershootAnimation.removedOnCompletion = YES;
    
    [item.superview bringSubviewToFront: item];
    
    [item.layer addAnimation: boundsOvershootAnimation forKey: @"bouncing"];
}


@end
