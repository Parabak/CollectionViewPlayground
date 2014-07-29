//
//  CECarouselCollectionViewDelegate.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <Foundation/Foundation.h>

// for test
#import "CEFloatCollectionViewDelegate.h"

@interface CECarouselCollectionViewDelegate : CEFloatCollectionViewDelegate//NSObject <UICollectionViewDelegate>

- (void) updateCurrentOffset: (UIScrollView*) scrollView;

@end
