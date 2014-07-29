//
//  CEFloatCollectionViewDataSource.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/10/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEFloatCollectionViewDataSource.h"
#import "CEFloatCollectionViewDelegate.h"
#import "CEIssueFooterReusableView.h"

@implementation CEFloatCollectionViewDataSource

- (id) init {
    
    self = [super init];
    
    if (self) {
        
        NSMutableArray *numbers = [NSMutableArray array];
        for (NSInteger index = 0; index < 10; index++) {
            
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

    issueCell.delegate = self;
    issueCell.tag = indexPath.item;
    issueCell.editMode = self.editMode;
    [issueCell.lblTitle setText: [NSString stringWithFormat: @"Issue title %i", ((NSNumber*)_fakeSource[indexPath.item]).integerValue]];
    
    return issueCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    CEIssueFooterReusableView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind: kind
                                                                              withReuseIdentifier: kIssueTitleIdentifier
                                                                                     forIndexPath: indexPath];
    
    return titleView;
}

#pragma mark -
#pragma mark - IDGItemViewDelegate

- (void) itemViewDeleteButtonTouched:(NSInteger)index {
    
    NSMutableArray *numbers = [NSMutableArray arrayWithArray: _fakeSource];
    if (numbers.count > index) {
        
        [numbers removeObjectAtIndex: index];
        _fakeSource = [NSArray arrayWithArray: numbers];
        
        [_collectionView reloadData];
    }
}

@end
