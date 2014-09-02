//
//  CEGridLayout.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/9/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEGridLayout.h"
#import "CEGridIssueCell.h"

NSString * const kIssueLayoutCellKind = @"IssueCell";
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
    self.itemInsets = UIEdgeInsetsMake(62.0f, 22.0f, 13.0f, 22.0f);
    self.itemSize = CGSizeMake(kPhoneIssueCellWidth, kPhoneIssueCellHeight);
    
    self.interItemSpacingY = 20.0f;
    self.numberOfColumns = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? 3 : 2;
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

#pragma mark -
#pragma mark - Prepare Layout

- (void) prepareLayout {
    
    [super prepareLayout];
    
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
            
            cellLayoutInfo[indexPath] = itemAttributes;
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
                            (self.itemSize.height + self.interItemSpacingY) * row);
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
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
                     (rowCount - 1) * self.interItemSpacingY + self.itemInsets.bottom;
    
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

@end
