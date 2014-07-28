//
//  CECollectionViewDelegate.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/9/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEFloatCollectionViewDelegate.h"
#import "CEFlowLayout.h"
#import "CEFlowContentInfoView.h"

@interface CEFloatCollectionViewDelegate () {
    
    CGPoint _middlePoint;
    CGFloat _currentOffset;
    CGFloat _scaleFactor;
    
    NSIndexPath *selectedIndex;
}

- (void) updateCurrentOffset: (UIScrollView*) scrollView;

@end

@implementation CEFloatCollectionViewDelegate

#pragma mark -
#pragma mark - Properties

- (CGFloat) offsetBetweenIssues {

    return [CEFlowLayout getOffset];
}

#pragma mark -
#pragma mark - Collection View delegate

@synthesize currentOffset = _currentOffset;

- (void)collectionView: (UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedIndex != indexPath) {
        
        // issue should be centered
        _currentOffset = indexPath.item;
                
        [collectionView scrollRectToVisible: CGRectMake(self.offsetBetweenIssues * _currentOffset, 0, collectionView.frame.size.width, collectionView.frame.size.height)
                                   animated: YES];
    } else {
        
        // open issue
        for (CEFlowContentInfoView *cell in collectionView.visibleCells) {
            
            if (cell.tag == indexPath.item && cell.isEnabled) {
                
                 NSLog(@"open issue");
            }
        }
    }
    
    selectedIndex = indexPath;
    
    [_scrollingSettleTimer invalidate];
	_scrollingSettleTimer = nil;
}

#pragma mark -
#pragma mark - Scroll View Delegate

- (void) scrollViewDidScroll: (UIScrollView *)scrollView {
    
    _scrollview = scrollView;
    [self updateCurrentOffset: scrollView];
}

- (void) scrollViewDidEndDragging: (UIScrollView *) scrollView willDecelerate: (BOOL) decelerate {

    _scrollview = scrollView;
    
	if(!decelerate) {
        
        NSLog(@"scrollViewDidEndDragging");
		[scrollView scrollRectToVisible: CGRectIntegral( CGRectMake(self.offsetBetweenIssues * _currentOffset, 0,
                                                                    scrollView.bounds.size.width,
                                                                    scrollView.bounds.size.height) )
                               animated: YES];
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
    
	[_scrollview scrollRectToVisible: CGRectIntegral( CGRectMake(self.offsetBetweenIssues * _currentOffset, 0,
                                                                 _scrollview.frame.size.width,
                                                                 _scrollview.frame.size.height) )
                            animated: YES];
    
	[_scrollingSettleTimer invalidate];
	_scrollingSettleTimer = nil;
}



#pragma mark -
#pragma mark - Private

- (void) updateCurrentOffset: (UIScrollView*) scrollView {
		
	_middlePoint = CGPointMake(scrollView.contentOffset.x + scrollView.frame.size.width / 2.0f - (kIssueItemWidth / 2), 200);
    
    _currentOffset = lroundf(scrollView.contentOffset.x / self.offsetBetweenIssues);
    
	for(UIView *issueView in [scrollView subviews]) {
        
        CGFloat unscaledX = issueView.frame.origin.x - (kIssueItemWidth - issueView.frame.size.width) / 2.0f;
        
        _scaleFactor = [self scaleAtPosition: unscaledX - scrollView.contentOffset.x
                                inScrollView: scrollView forTest: issueView];
        
        [issueView setTransform: CGAffineTransformMakeScale(_scaleFactor, _scaleFactor)];
        
        if (_currentOffset == issueView.tag) {
            
            [scrollView bringSubviewToFront: issueView];
        }
	}
}

- (CGFloat) scaleAtPosition: (float) positionX  inScrollView: (UIScrollView *) scrollView forTest: (UIView*) issueTest {
    
    CGFloat halfWidth = scrollView.bounds.size.width / 2.0f;

    CGFloat distanceToClipFromCenter = 170;
    CGFloat boundary = halfWidth - distanceToClipFromCenter;
    CGFloat width = scrollView.bounds.size.width;
    
	positionX += (kIssueItemWidth / 2);
        
	if(positionX >= halfWidth) {
        
		if((positionX - halfWidth) > halfWidth - boundary) {
			return 0.5;
		}
		else {
            
//            positionX - boundary = positionX - halfWidth + distanceToClipFromCenter = 170
//            NSLog(@"(ositionX - boundary %f",  positionX - boundary);
     
            CGFloat mainFactor = (0.5 * (positionX - boundary) / (halfWidth - boundary)); // [0.5;1] from 1 to 0.5 firection
            
//            if (issueTest.tag == 1) {
//                
//                CGFloat factor = mainFactor - 0.5f;
//                CGFloat diff = mainFactor + powf(factor, 2.0f);
//                diff = diff > 1.0f ? 1.0f : diff;
//
//                NSLog(@"%f\n=====", factor);
//                
////                NSLog(@"main scale %f", 1.5f - mainFactor);
////                NSLog(@"my scale %f", 1.5 - diff);
////                NSLog(@"delta %f", diff - mainFactor);
////                NSLog(@"====");
//                
//                return 1.5f - diff;
//            }

            return 1.5f - mainFactor;
		}
	}
	else {
        
		if(positionX - boundary <= 0) {
			return 0.5;
		}
        
		else {
            
			return ((positionX - boundary) / (width - (boundary * 2))) + 0.5;
		}
	}
    
	// Shouldnt get here.. Will flip the view if we somehow do
	return -1.0;
}


@end
