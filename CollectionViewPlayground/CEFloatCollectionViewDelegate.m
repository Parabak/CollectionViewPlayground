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

    CGFloat _scaleFactor;
    
 
}

- (void) updateCurrentOffset: (UIScrollView*) scrollView;

- (void) openIssue: (UICollectionViewCell*) sender;

@end

@implementation CEFloatCollectionViewDelegate

#pragma mark -
#pragma mark - Properties

- (CGFloat) offsetBetweenIssues {

    return [CEFlowLayout getOffset];
}

#pragma mark -
#pragma mark - Collection View delegate

@synthesize selectedIndex = _selectedIndex;
@synthesize currentOffset = _currentOffset;

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
    
    _scrollview = scrollView;
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
    
    // TODO: _scrollview is nil on start
    
//    NSLog(@"scrollToOffset x = %f", self.offsetBetweenIssues * _currentOffset);
    
    [_scrollview scrollRectToVisible: CGRectIntegral( CGRectMake(self.offsetBetweenIssues * _currentOffset, 0,
                                                                 _scrollview.frame.size.width,
                                                                 _scrollview.frame.size.height) )
                            animated: YES];
}

#pragma mark -
#pragma mark - Private

- (void) updateCurrentOffset: (UIScrollView*) scrollView {
		
	_middlePoint = CGPointMake(scrollView.contentOffset.x + scrollView.frame.size.width / 2.0f - (kIssueItemWidth / 2), 200);
    
    _currentOffset = lroundf(scrollView.contentOffset.x / self.offsetBetweenIssues);
    
    self.selectedIndex = [NSIndexPath indexPathForItem: roundf(_currentOffset) inSection: 0];
//    NSLog(@"current offset %f, selected index %i", _currentOffset, _selectedIndex.item);
    
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

// this should be move out to 'Animation' class
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
    
            CGFloat mainFactor = (0.5 * (positionX - boundary) / (halfWidth - boundary)); // [0.5;1] from 1 to 0.5 firection


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

- (void) openIssue:(UICollectionViewCell *)sender {
    
    NSLog(@"Open issue with index %i", _selectedIndex.item);
}

#pragma mark -
#pragma mark - Properties

- (NSIndexPath *) selectedIndex {
    
    if (_selectedIndex == nil) {
        
        _selectedIndex = [NSIndexPath indexPathForItem: 0 inSection: 0];
    }
    
    return _selectedIndex;
}


@end
