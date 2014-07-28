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

@synthesize currentOffset = _currentOffset;


#pragma mark -
#pragma mark - Properties
- (CGFloat) offsetBetweenIssues {
    
    return [CECarouselLayout getOffset];
}

#pragma mark -
#pragma mark - Scroll View Delegate

- (void) updateCurrentOffset: (UIScrollView*) scrollView {
    
    _previousOffset = _currentOffset;
    _currentOffset = (scrollView.contentOffset.x / self.offsetBetweenIssues);
    
    // here we should use borders
    if (_currentOffset >= 0.0f && _currentOffset <= 9) {
        
        [self transformItemViews];
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [super collectionView: collectionView didSelectItemAtIndexPath: indexPath];
}

- (void) decelerationSettled {
    
//	[_scrollview scrollRectToVisible: CGRectIntegral( CGRectMake([CECarouselLayout getOffset] * _currentOffset, 0,
//                                                                 _scrollview.frame.size.width,
//                                                                 _scrollview.frame.size.height) )
//                            animated: YES];
//    
	[_scrollingSettleTimer invalidate];
	_scrollingSettleTimer = nil;
}

- (void) scrollViewDidEndDragging: (UIScrollView *) scrollView willDecelerate: (BOOL) decelerate {
    
    _scrollview = scrollView;
    
//	if(!decelerate) {
//        
        NSLog(@"scrollViewDidEndDragging");
//		[scrollView scrollRectToVisible: CGRectIntegral( CGRectMake(self.offsetBetweenIssues * _currentOffset, 0,
//                                                                    scrollView.bounds.size.width,
//                                                                    scrollView.bounds.size.height) )
//                               animated: YES];
//	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Transformation

- (void) transformItemViews {
    
    NSMutableArray *animatedItems = [NSMutableArray array];
    
    for (UIView *issueView in _scrollview.subviews) {
        
        CGFloat unscaledX = issueView.frame.origin.x - (kIssueItemWidth - issueView.frame.size.width) / 2.0f;
        
        CGFloat offset = [self offsetForItemAtIndex: issueView.tag];
        [self transformForItemViewWithOffset: offset
                                   positionX: unscaledX - _scrollview.contentOffset.x
                                     itemTag: issueView.tag
                                    itemView: issueView];

        if ([issueView respondsToSelector: @selector(shouldBeAnimated)]) {

            if (((CEFlowContentInfoView*)issueView).shouldBeAnimated) {
            
                [animatedItems addObject: issueView];
            }
        }
    }
    
    [self animateItems: animatedItems];
//    [self animateTransformsInItems: animatedItems];
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
                
                if (item.tag == 0 || item.tag == 1) {
                    
//                    [self printTransformMatrix: item];
                }
            }];
            
            break;
        }
    }
}

- (void) animateTransformsInItems: (NSArray *) items {
    
    
    for (NSInteger index = 0; index < items.count; index++) {
        
        CEFlowContentInfoView *item = items[index];
        
        if (item.shouldBeAnimated) {
            
            CAKeyframeAnimation *flippingAnimation;
            if (item.flippingAnimation == nil) {
                
                [item.layer removeAnimationForKey: @"flippingAnimation"];
                
                flippingAnimation = [CAKeyframeAnimation animationWithKeyPath: @"transform"];
            } else {
                
                flippingAnimation = item.flippingAnimation;
            }
            
            // TODO: do it in method where latest fransformation is calculated
            
            [item.transformations addObject: [NSValue valueWithCATransform3D: item.transform3D]];
            
            [flippingAnimation setValues: item.transformations];
            
            NSMutableArray *times = [NSMutableArray array];
            for (NSInteger value = 0; value < item.transformations.count; value++) {
                
                [times addObject: @(1.0f / item.transformations.count)];
            }
            [flippingAnimation setKeyTimes:times];
            
            flippingAnimation.fillMode = kCAFillModeForwards;
            flippingAnimation.removedOnCompletion = NO;
            
            [item.layer addAnimation: flippingAnimation forKey: @"flippingAnimation"];
            
            if (item.tag == lroundf(_currentOffset)) {
                
                [_scrollview bringSubviewToFront: item];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSMutableArray *remainItems = [NSMutableArray array];
                
                for (NSInteger remainIndex = index + 1; remainIndex < items.count; remainIndex++) {
                    
                    if (remainIndex < items.count ) {
                        
                        [remainItems addObject: items[remainIndex]];
                    }
                }
                
                [self animateTransformsInItems: remainItems];
            });
        }
        
        break;
    }

    
//    CAKeyframeAnimation *boundsOvershootAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    
//    CATransform3D startingScale = CATransform3DScale (layer.transform, 0, 0, 0);
//    CATransform3D overshootScale = CATransform3DScale (layer.transform, 1.2, 1.2, 1.0);
//    CATransform3D undershootScale = CATransform3DScale (layer.transform, 0.9, 0.9, 1.0);
//    CATransform3D endingScale = layer.transform;
//    
//    NSArray *boundsValues = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:startingScale],
//                             [NSValue valueWithCATransform3D:overshootScale],
//                             [NSValue valueWithCATransform3D:undershootScale],
//                             [NSValue valueWithCATransform3D:endingScale], nil];
//    [boundsOvershootAnimation setValues:boundsValues];
//    
//    NSArray *times = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],
//                      [NSNumber numberWithFloat:0.5f],
//                      [NSNumber numberWithFloat:0.9f],
//                      [NSNumber numberWithFloat:1.0f], nil];
//    [boundsOvershootAnimation setKeyTimes:times];
//    
//    
//    NSArray *timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
//                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                nil];
//    [boundsOvershootAnimation setTimingFunctions:timingFunctions];
//    boundsOvershootAnimation.fillMode = kCAFillModeForwards;
//    boundsOvershootAnimation.removedOnCompletion = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    // only on completion all stack of animations for one item can be removed.
    // if we implement it in such way we will not 'lost' any step of the scrolling animation
    for (CEFlowContentInfoView *itemview in _scrollview.subviews) {
        
        if (itemview.flippingAnimation == anim) {
            
            [itemview.transformations removeAllObjects];
        }
        
        break;
    }
}

- (void) printTransformMatrix: (UIView *) view {
    
    NSLog(@"\nTAG %i\n%f %f %f %f\n%f %f %f %f\n%f %f %f %f\n%f %f %f %f",
          view.tag,
          view.layer.transform.m11,
          view.layer.transform.m12,
          view.layer.transform.m13,
          view.layer.transform.m14,
          view.layer.transform.m21,
          view.layer.transform.m22,
          view.layer.transform.m23,
          view.layer.transform.m24,
          view.layer.transform.m31,
          view.layer.transform.m32,
          view.layer.transform.m33,
          view.layer.transform.m34,
          view.layer.transform.m41,
          view.layer.transform.m42,
          view.layer.transform.m43,
          view.layer.transform.m44);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 
#pragma mark - Calculations

- (CGFloat) offsetForItemAtIndex: (NSInteger)index
{
    //calculate relative position
    CGFloat offset = index - _currentOffset;

    CGFloat _numberOfItems = 10.0f;

    if (_numberOfItems == 1)
    {
        offset = 0.0f;
    }
    
    return offset;
}

- (void)transformForItemViewWithOffset: (CGFloat) offset
                                      positionX: (CGFloat) positionX
                                        itemTag: (NSInteger) tag
                                       itemView: (UIView*) itemView {
    

    CGFloat _perspective = -1.0f / 500.0f;
    CGSize _viewpointOffset = CGSizeZero;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = _perspective;
    transform = CATransform3DTranslate(transform, -_viewpointOffset.width, -_viewpointOffset.height, 0.0f);
    
    CGFloat tilt = 0.9f;
    CGFloat spacing = 0.55f;
    
    // normalisation for interval [-1.0f; 0.0f] and [0.0f; 1.0f]
    CGFloat clampedOffset = fmaxf(-1.0f, fminf(1.0f, offset));
    
    CGFloat angel = -clampedOffset * M_PI_4 * tilt;
    
    CGFloat z = fabsf(clampedOffset) * -kIssueItemWidth * 0.5f;
    
    CGFloat x = (clampedOffset * 0.5f * tilt + offset * spacing) * 365 / 2;
    
    if ([itemView respondsToSelector: @selector(setClampedOffset:)]) {

        [((CEFlowContentInfoView*)itemView) setClampedOffset: clampedOffset];
        angel = ((CEFlowContentInfoView*)itemView).clampedOffset * M_PI_4 * tilt;
        
        z = fabsf(((CEFlowContentInfoView*)itemView).clampedOffset) * -kIssueItemWidth / 3;
       
        //TODO: REMOVE. calculate in one place
        CGFloat test = ((CEFlowContentInfoView*)itemView).clampedOffset;
       
        if (test == -1) {
            
            x = -300.0f;
        } else if (test == 1) {
            
            x = 300.0f;
        } else {
            
            x = 0.0f;
        }
        
        x += offset;
    }
    
    transform = CATransform3DTranslate(transform, x, 0.0f, z);
    
    if ([itemView respondsToSelector: @selector(transform3D)]) {
        
        ((CEFlowContentInfoView*)itemView).transform3D = CATransform3DRotate(transform, angel, 0.0f, -1.0f, 0.0f);

        
    }
}

@end
