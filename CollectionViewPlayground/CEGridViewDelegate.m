//
//  CEGridViewDelegate.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 9/1/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEGridViewDelegate.h"
#import "CEGridIssueCell.h"
#import "CECarouselAnimations.h"

@implementation CEGridViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CEGridIssueCell *selectedView = (CEGridIssueCell*) [collectionView cellForItemAtIndexPath: indexPath];

    if (selectedView.isEnabled) {
        
        CAKeyframeAnimation *bouncingAnimation = [CECarouselAnimations bouncingScaleAnimationForItem: selectedView];
        [selectedView.layer addAnimation: bouncingAnimation forKey: @"bouncing"];
        
//        [self.delegate itemSelectedAtIndexPath: indexPath];
    }
}

@end
