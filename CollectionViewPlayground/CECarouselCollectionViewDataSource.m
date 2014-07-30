//
//  CECarouselCollectionViewDataSource.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECarouselCollectionViewDataSource.h"
#import "CEFlowContentInfoView.h"
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
    
    CEFlowContentInfoView *issueCell = [collectionView dequeueReusableCellWithReuseIdentifier: kFlowContentInfoViewInendifier
                                                                                 forIndexPath: indexPath];

    issueCell.tag = indexPath.item;
    [issueCell.lblTitle setText: [NSString stringWithFormat: @"Issue title %i", ((NSNumber*)_fakeSource[indexPath.item]).integerValue]];
    
    //TODO: move to item method
    [issueCell setNeedsLayout];
    [issueCell layoutIfNeeded];
    CGFloat currentOffset = ((CECarouselCollectionViewDelegate*) collectionView.delegate).currentOffset;
    [issueCell calculateTransformationForOffset: indexPath.item - currentOffset];
    issueCell.layer.transform = issueCell.transform3D;
    
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

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - Playground with Transformations


- (CATransform3D) getTransformationForIndexPath: (NSIndexPath*) indexPath collectionView: (UICollectionView*) collectionView {
        
    CGFloat _perspective = -1.0f / 500.0f;
    CGSize _viewpointOffset = CGSizeZero;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = _perspective;
    transform = CATransform3DTranslate(transform, -_viewpointOffset.width, -_viewpointOffset.height, 0.0f);
    
    CGFloat tilt = 0.9f;
    
    CGFloat currentOffset = ((CECarouselCollectionViewDelegate*) collectionView.delegate).currentOffset;
    
    CGFloat clampedOffset = 0.0f;
    
    CGFloat offset = indexPath.item - currentOffset;
    CGFloat x = (clampedOffset * 0.5f * tilt + offset * 0.55f) * 365 / 2;
    
    if (indexPath.item > currentOffset) {
        
        clampedOffset = -1.0f;
        x = -200.0f;
    } else if (indexPath.item < currentOffset) {
        
        clampedOffset = 1.0f;
        x = 200.0f;
    }
    
    
    CGFloat angel = -clampedOffset * M_PI_4 * tilt;
    
    CGFloat z = fabsf(clampedOffset) * -kIssueItemWidth * 0.5f;
    
    transform = CATransform3DTranslate(transform, x, 0.0f, z);
    
    return CATransform3DRotate(transform, angel, 0.0f, -1.0f, 0.0f);
    
}

@end
