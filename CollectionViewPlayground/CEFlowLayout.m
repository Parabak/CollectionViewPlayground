//
//  CEFlowLayout.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/10/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEFlowLayout.h"
#import "CEFloatCollectionViewDataSource.h"

CGFloat const kIssueOffset = 300.0f; 
CGFloat const kTitleHeight = 60.0f;

NSString * const kFloatLayoutIssueViewKind = @"IssueFloatView";
NSString * const kFloatLayoutIssueTitleKind = @"AlbumTitle";

@interface CEFlowLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;

@end

@implementation CEFlowLayout

#pragma mark -
#pragma mark - Static Methods

+ (CGFloat) getOffset {
    
    return kIssueOffset;
}

#pragma mark -
#pragma mark - Lifecycle

- (id) init
{
    self = [super init];
    
    if (self) {
        
        [self setupForOrientation: [UIApplication sharedApplication].statusBarOrientation];
    }
    
    return self;
}

- (id) initWithCoder: (NSCoder *) aDecoder {
    
    self = [super init];
    
    if (self) {
        
        [self setupForOrientation: [UIApplication sharedApplication].statusBarOrientation];
    }
    
    return self;
}

- (void) setupForOrientation: (UIInterfaceOrientation) interfaceOrientation {
    
    CGRect bounds = [UIScreen mainScreen].bounds;
	if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
		
		CGFloat width = bounds.size.width;
		bounds.size.width = bounds.size.height;
		bounds.size.height = width;
	}
    
    CGFloat yPadding = (bounds.size.height - kIssueItemHeight) / 2.0f;
    self.itemInsets = UIEdgeInsetsMake(yPadding,
                                       (bounds.size.width - kIssueItemWidth) / 2.0f,
                                       80.0f,
                                       (bounds.size.width - kIssueItemWidth) / 2.0f);
    self.itemSize = CGSizeMake(kIssueItemWidth, kIssueItemHeight);
        
    self.numberOfColumns = [((CEFloatCollectionViewDataSource*)self.collectionView.dataSource) getColumnsCount];

    self.titleHeight = kTitleHeight;
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
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection: section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem: item inSection: section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: indexPath];
            
            itemAttributes.frame = [self frameForIssueAtIndexPath: indexPath];
            itemAttributes.transform = [self tranformationForIssueAtIndexPath: indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
            
            
//            UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind: kFloatLayoutIssueTitleKind
//                                                                                                                               withIndexPath: indexPath];
//            titleAttributes.frame = [self frameForIssueTitleAtIndexPath: indexPath];
//            titleLayoutInfo[indexPath] = titleAttributes;

        }
    }

    newLayoutInfo[kFloatLayoutIssueViewKind] = cellLayoutInfo;
    newLayoutInfo[kFloatLayoutIssueTitleKind] = titleLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

#pragma mark -
#pragma mark - Private

- (CGRect) frameForIssueAtIndexPath: (NSIndexPath *) indexPath {

    CGFloat originX = floorf(self.itemInsets.left + kIssueOffset * indexPath.item);
    CGFloat originY = self.itemInsets.top;
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (CGRect) frameForIssueTitleAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForIssueAtIndexPath:indexPath];
    CGAffineTransform affineTransformation = [self tranformationForIssueAtIndexPath: indexPath];
    
    CGFloat centerY = frame.origin.y + frame.size.height / 2.0f;
    CGFloat originTitleY = centerY + frame.size.height * affineTransformation.a / 2.0f;
    
    frame.origin.y = originTitleY;
    frame.size.height = self.titleHeight;
    
    NSLog(@"%@", NSStringFromCGRect(frame));
    
    return frame;
}

- (CGAffineTransform) tranformationForIssueAtIndexPath: (NSIndexPath*) indexPath {
    
    NSInteger currentSelectedItem = lroundf(self.collectionView.contentOffset.x / kIssueOffset);
    CGAffineTransform transform = CGAffineTransformMakeScale( 0.5f, 0.5f);
    
    if (currentSelectedItem == indexPath.item) {
        
        transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }
    
    return transform;
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
    
    return self.layoutInfo[kFloatLayoutIssueTitleKind][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[kFloatLayoutIssueViewKind][indexPath];
}

- (CGSize) collectionViewContentSize
{
    NSInteger columnsCount = [((CEFloatCollectionViewDataSource*)self.collectionView.dataSource) getColumnsCount];

    CGFloat width = self.itemInsets.left + (columnsCount - 1) * kIssueOffset + self.itemSize.width + self.itemInsets.right;
    
    return CGSizeMake(width, self.collectionView.bounds.size.height);
}

@end
