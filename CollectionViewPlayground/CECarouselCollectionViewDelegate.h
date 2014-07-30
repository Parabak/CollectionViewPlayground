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

@interface CECarouselCollectionViewDelegate : CEFloatCollectionViewDelegate {
    
}

- (void) updateCurrentOffset: (UIScrollView*) scrollView;

// TODO: hide
- (CGFloat) offsetForItemAtIndex: (NSInteger)index;

@end
