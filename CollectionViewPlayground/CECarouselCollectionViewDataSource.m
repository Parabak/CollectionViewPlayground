//
//  CECarouselCollectionViewDataSource.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECarouselCollectionViewDataSource.h"
#import "CECarouselItemView.h"
#import "CEIssueFooterReusableView.h"

#import "CECarouselCollectionViewDelegate.h"

@implementation CECarouselCollectionViewDataSource

- (id) init {
    
    self = [super init];
    
    if (self) {
        
        NSMutableArray *numbers = [NSMutableArray array];
        for (NSInteger index = 0; index < 20; index++) {
            
            [numbers addObject: @(index)];
        }
        
        _fakeSource = [NSMutableArray arrayWithArray: numbers];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Public

- (NSInteger) getColumnsCount {
    
    return _fakeSource.count;
}

#pragma mark -
#pragma mark - Datasource Delegate

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *) collectionView {
    
    return 1;
}

- (NSInteger)collectionView: (UICollectionView *) collectionView
     numberOfItemsInSection: (NSInteger) section {
    
    _collectionView = collectionView;
    
    return _fakeSource.count;
}

- (UICollectionViewCell *)collectionView: (UICollectionView *) collectionView
                  cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    CECarouselItemView *issueCell = [collectionView dequeueReusableCellWithReuseIdentifier: kCarouselItemIdentifier
                                                                                 forIndexPath: indexPath];
    
    issueCell.tag = indexPath.item;
    [issueCell.lblTitle setText: [NSString stringWithFormat: @"Issue title %i", ((NSNumber*)_fakeSource[indexPath.item]).integerValue]];
    
    
    //TODO: move to item method
    issueCell.clampedOffset = 0;

    CGFloat currentOffset = ((CECarouselCollectionViewDelegate*) collectionView.delegate).currentOffset;
    [issueCell calculateTransformationForOffset: indexPath.item - currentOffset];
    
    return issueCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    CEIssueFooterReusableView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind: kind
                                                                              withReuseIdentifier: kIssueTitleIdentifier
                                                                                     forIndexPath: indexPath];
    
    titleView.titleLabel.text = [NSString stringWithFormat: @"reusable view. index %i", indexPath.item];
    
    return titleView;
}

@end
