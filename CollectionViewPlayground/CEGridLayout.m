//
//  CEGridLayout.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/9/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEGridLayout.h"

static NSString * const kIssueLayoutCellKind = @"IssueCell";
NSString * const kIssueLayoutAlbumTitleKind = @"AlbumTitle";

@interface CEGridLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;

@end



@implementation CEGridLayout

#pragma mark - Lifecycle

- (id) init
{
    self = [super init];
    
    if (self) {
        
        [self setup];
    }
    
    return self;
}

- (id) initWithCoder: (NSCoder *) aDecoder {
    
    self = [super init];
    
    if (self) {
        
        [self setup];
    }
    
    return self;
}

- (void) setup {
    
    // TODO: use constants
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    self.itemSize = CGSizeMake(125.0f, 125.0f);
//#define CELL_IPHONE_WIDTH	133.0f
//#define CELL_IPHONE_HEIGHT	200.0f
    
    self.interItemSpacingY = 12.0f;
    self.numberOfColumns = 2;
    self.titleHeight = 26.0f;
    
    NSMutableArray *rotations = [NSMutableArray arrayWithCapacity: kRotationCount];
    
    CGFloat percentage = 0.0f;
    for (NSInteger i = 0; i < kRotationCount; i++) {
        // ensure that each angle is different enough to be seen
        CGFloat newPercentage = 0.0f;
        do {
            newPercentage = ((CGFloat)(arc4random() % 220) - 110) * 0.0001f;
        } while (fabsf(percentage - newPercentage) < 0.006);
        percentage = newPercentage;
        
        CGFloat angle = 2 * M_PI * (1.0f + percentage);
        CATransform3D transform = CATransform3DMakeRotation(angle, 0.0f, 0.0f, 1.0f);
        
        [rotations addObject:[NSValue valueWithCATransform3D:transform]];
    }
    
    self.rotations = rotations;
}

- (CATransform3D)transformForAlbumPhotoAtIndex: (NSIndexPath *) indexPath {
    
    NSInteger offset = (indexPath.section * kRotationStride + indexPath.item);
    return [self.rotations[offset % kRotationCount] CATransform3DValue];
}

#pragma mark -
#pragma mark - Properties

- (void)setItemInsets:(UIEdgeInsets)itemInsets {
    
    if (!UIEdgeInsetsEqualToEdgeInsets( _itemInsets, itemInsets)) {
        
        _itemInsets = itemInsets;
        
        [self invalidateLayout];
    }
}

- (void) setItemSize:(CGSize)itemSize {
    
    if (!CGSizeEqualToSize(_itemSize, itemSize)) {
        
        _itemSize = itemSize;
        
        [self invalidateLayout];
    }
}

- (void) setInterItemSpacingY:(CGFloat)interItemSpacingY
{
    if (_interItemSpacingY != interItemSpacingY) {
    
        _interItemSpacingY = interItemSpacingY;
    
        [self invalidateLayout];
    }
}

- (void) setNumberOfColumns:(NSInteger)numberOfColumns
{
    if (_numberOfColumns != numberOfColumns) {
    
        _numberOfColumns = numberOfColumns;
        
        [self invalidateLayout];
    }
}

- (void)setTitleHeight:(CGFloat)titleHeight
{
    if (_titleHeight != titleHeight) {
    
        _titleHeight = titleHeight;
        
        [self invalidateLayout];
    }
}


#pragma mark -
#pragma mark - Prepare Layout

- (void) prepareLayout {
    
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *titleLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            itemAttributes.frame = [self frameForIssueAtIndexPath:indexPath];
            itemAttributes.transform3D = [self transformForAlbumPhotoAtIndex:indexPath];
            itemAttributes.zIndex = kIssueCellBaseZIndex + itemCount - item;
            
            cellLayoutInfo[indexPath] = itemAttributes;
            
            if (indexPath.item == 0) {
                
                UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind: kIssueLayoutAlbumTitleKind
                                                                                                                                   withIndexPath: indexPath];
                titleAttributes.frame = [self frameForIssueTitleAtIndexPath:indexPath];
                
                titleLayoutInfo[indexPath] = titleAttributes;
            }
        }
    }
    
    newLayoutInfo[kIssueLayoutCellKind] = cellLayoutInfo;
    newLayoutInfo[kIssueLayoutAlbumTitleKind] = titleLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

#pragma mark -
#pragma mark - Private

- (CGRect) frameForIssueAtIndexPath: (NSIndexPath *) indexPath
{
    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;
    
    CGFloat spacingX = self.collectionView.bounds.size.width - self.itemInsets.left - self.itemInsets.right - (self.numberOfColumns * self.itemSize.width);
    
    if (self.numberOfColumns > 1) {
        
        spacingX = spacingX / (self.numberOfColumns - 1);
    }
    
    CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);
    
    CGFloat originY = floor(self.itemInsets.top  +
                            (self.itemSize.height + self.titleHeight + self.interItemSpacingY) * row);
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (CGRect) frameForIssueTitleAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForIssueAtIndexPath:indexPath];
    frame.origin.y += frame.size.height;
    frame.size.height = self.titleHeight;
    
    return frame;
}

- (NSArray *)layoutAttributesForElementsInRect: (CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity: self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - Attributes

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return self.layoutInfo[kIssueLayoutAlbumTitleKind][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[kIssueLayoutCellKind][indexPath];
}

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
    // make sure we count another row if one is only partially filled
    if ([self.collectionView numberOfSections] % self.numberOfColumns) {
        
        rowCount++;
    }
    
    CGFloat height = self.itemInsets.top +
                     rowCount * self.itemSize.height +
                    rowCount * self.titleHeight +
                     (rowCount - 1) * self.interItemSpacingY + self.itemInsets.bottom;
    
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

@end
