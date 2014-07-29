//
//  CECarouselLayout.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECarouselLayout.h"
#import "CECarouselCollectionViewDataSource.h"
#import "CECarouselCollectionViewDelegate.h"

CGFloat const kItemsOffset = 100.0f;
CGFloat const kSupplementaryItemHeight = 60.0f;

NSString * const kCarouselLayoutIssueViewKind = @"IssueCarouselView";
NSString * const kCarouselLayoutIssueTitleKind = @"IssueCarouselTitle";

@interface CECarouselLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;

@end

@implementation CECarouselLayout

+ (CGFloat) getOffset {
    
    return kItemsOffset;
}

#pragma mark -
#pragma mark - Prepare Layout

- (void) prepareLayout {
    
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *titleLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection: section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem: item inSection: section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: indexPath];
            
            itemAttributes.frame = [self frameForIssueAtIndexPath: indexPath];
            itemAttributes.transform3D = [self getTransformationForIndexPath: indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
            
            
            UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind: kCarouselLayoutIssueTitleKind
                                                                                                                               withIndexPath: indexPath];
            titleAttributes.frame = [self frameForIssueTitleAtIndexPath: indexPath];
            titleLayoutInfo[indexPath] = titleAttributes;
        }
    }
    
    newLayoutInfo[kCarouselLayoutIssueViewKind] = cellLayoutInfo;
    newLayoutInfo[kCarouselLayoutIssueTitleKind] = titleLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

#pragma mark -
#pragma mark - Private

- (CGRect) frameForIssueAtIndexPath: (NSIndexPath *) indexPath {
    
    CGFloat originX = floorf(self.itemInsets.left + kItemsOffset * indexPath.item);
    CGFloat originY = self.itemInsets.top;
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (CGRect) frameForIssueTitleAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForIssueAtIndexPath:indexPath];
//    CGAffineTransform affineTransformation = [self tranformationForIssueAtIndexPath: indexPath];
    
    CGFloat centerY = frame.origin.y + frame.size.height;
//    CGFloat originTitleY = centerY + frame.size.height * affineTransformation.a / 2.0f;
    
    frame.origin.y = centerY;
    frame.size.height = self.titleHeight;
    
    return frame;
}

- (CGSize) collectionViewContentSize
{
    NSInteger columnsCount = [((CECarouselCollectionViewDataSource*)self.collectionView.dataSource) getColumnsCount];
    
    CGFloat width = self.itemInsets.left + (columnsCount - 1) * kItemsOffset + self.itemSize.width + self.itemInsets.right;
    
    return CGSizeMake(width, self.collectionView.bounds.size.height);
}

- (CATransform3D) getTransformationForIndexPath: (NSIndexPath*) indexPath {
        // todo
    CGFloat _perspective = -1.0f / 500.0f;
    CGSize _viewpointOffset = CGSizeZero;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = _perspective;
    transform = CATransform3DTranslate(transform, -_viewpointOffset.width, -_viewpointOffset.height, 0.0f);
    
    CGFloat tilt = 0.9f;
    
    CGFloat currentOffset = ((CECarouselCollectionViewDelegate*) self.collectionView.delegate).currentOffset;
    
    CGFloat clampedOffset = 0.0f;
    if (indexPath.item > currentOffset) {
        
        clampedOffset = -1.0f;
    } else if (indexPath.item < currentOffset) {
        
        clampedOffset = 1.0f;
    }
    
    CGFloat angel = -clampedOffset * M_PI_4 * tilt;
    CGFloat z = fabsf(clampedOffset) * -kIssueItemWidth * 0.5f;
    
    transform = CATransform3DTranslate(transform, 0, 0.0f, z);
    
    return CATransform3DRotate(transform, angel, 0.0f, -1.0f, 0.0f);
    
}

@end
