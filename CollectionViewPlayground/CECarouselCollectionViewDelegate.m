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
    
    // TODO: here we should use borders
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
                
            } completion: nil];
            
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

    CGFloat _numberOfItems = 10.0f;

    if (_numberOfItems == 1)
    {
        offset = 0.0f;
    }
    
    return offset;
}

//- (void)transformForItemViewWithOffset: (CGFloat) offset
//                              itemView: (UIView*) itemView {
//    
//
//    CGFloat _perspective = -1.0f / 500.0f;
//    CGSize _viewpointOffset = CGSizeZero;
//    
//    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = _perspective;
//    transform = CATransform3DTranslate(transform, -_viewpointOffset.width, -_viewpointOffset.height, 0.0f);
//    
//    CGFloat tilt = 0.9f;
//    CGFloat spacing = 0.55f;
//    
//    // normalisation for interval [-1.0f; 0.0f] and [0.0f; 1.0f]
//    CGFloat clampedOffset = fmaxf(-1.0f, fminf(1.0f, offset));
//    
//    CGFloat angel = -clampedOffset * M_PI_4 * tilt;
//    
//    CGFloat z = fabsf(clampedOffset) * -kIssueItemWidth * 0.5f;
//    
//    CGFloat x = (clampedOffset * 0.5f * tilt + offset * spacing) * 365 / 2;
//    
//    if ([itemView respondsToSelector: @selector(setClampedOffset:)]) {
//
//        [((CEFlowContentInfoView*)itemView) setClampedOffset: clampedOffset];
//        angel = ((CEFlowContentInfoView*)itemView).clampedOffset * M_PI_4 * tilt;
//        
//        z = fabsf(((CEFlowContentInfoView*)itemView).clampedOffset) * -kIssueItemWidth / 3;
//       
//        //TODO: REMOVE. calculate in one place
//        CGFloat test = ((CEFlowContentInfoView*)itemView).clampedOffset;
//       
//        if (test == -1) {
//            
//            x = -300.0f;
//        } else if (test == 1) {
//            
//            x = 300.0f;
//        } else {
//            
//            x = 0.0f;
//        }
//        
//        x += offset;
//    }
//    
//    transform = CATransform3DTranslate(transform, x, 0.0f, z);
//    
//    if ([itemView respondsToSelector: @selector(transform3D)]) {
//        
//        ((CEFlowContentInfoView*)itemView).transform3D = CATransform3DRotate(transform, angel, 0.0f, -1.0f, 0.0f);
//    }
//}

@end
