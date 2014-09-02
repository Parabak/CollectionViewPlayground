//
//  CECarouselCollectionViewDataSource.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECarouselCollectionViewDataSource.h"
#import "CECarouselItemView.h"
#import "CECarouselCollectionViewDelegate.h"

@implementation CECarouselCollectionViewDataSource

- (UICollectionViewCell *)collectionView: (UICollectionView *) collectionView
                  cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    CECarouselItemView *issueCell = [collectionView dequeueReusableCellWithReuseIdentifier: kCarouselItemIdentifier
                                                                                 forIndexPath: indexPath];
    
    issueCell.tag = indexPath.item;
    issueCell.delegate = self;
    issueCell.editMode = self.editMode;
    
    [issueCell.lblTitle setText: [NSString stringWithFormat: @"Issue title %i", indexPath.item]];
    [self loadIssuePreviewForView: issueCell atIndexPath: indexPath];

    issueCell.clampedOffset = 0;
    CGFloat currentOffset = ((CECarouselCollectionViewDelegate*) collectionView.delegate).currentOffset;
    [issueCell calculateTransformationForOffset: indexPath.item - currentOffset];
    
    return issueCell;
}


@end
