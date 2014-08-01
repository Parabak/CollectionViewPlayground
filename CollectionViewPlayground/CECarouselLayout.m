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
NSString * const kCarouselLayoutSupplementaryKind = @"IssueCarouselTitle";

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
            cellLayoutInfo[indexPath] = itemAttributes;
                        
            UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind: kCarouselLayoutSupplementaryKind
                                                                                                                               withIndexPath: indexPath];
            titleAttributes.frame = [self frameForSupplementaryViewAtIndexPath: indexPath];
            titleLayoutInfo[indexPath] = titleAttributes;
        }
    }
    
    newLayoutInfo[kCarouselLayoutIssueViewKind] = cellLayoutInfo;
    newLayoutInfo[kCarouselLayoutSupplementaryKind] = titleLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

#pragma mark -
#pragma mark - Private

- (CGRect) frameForIssueAtIndexPath: (NSIndexPath *) indexPath {
    
    CGFloat originX = floorf(self.itemInsets.left + kItemsOffset * indexPath.item); //kItemsOffset
    CGFloat originY = self.itemInsets.top;
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (CGRect) frameForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForIssueAtIndexPath:indexPath];
    
    CGFloat centerY = frame.origin.y + frame.size.height;
    
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


@end
