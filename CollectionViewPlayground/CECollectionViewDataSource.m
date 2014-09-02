//
//  CECollectionViewDataSource.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/9/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECollectionViewDataSource.h"
#import "CEGridIssueCell.h"
#import "CEIssue.h"


@implementation CECollectionViewDataSource


- (UICollectionViewCell *)collectionView: (UICollectionView *) collectionView
                  cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    CEGridIssueCell *issueCell = [collectionView dequeueReusableCellWithReuseIdentifier: kIssueGridCellIdentifier
                                                                           forIndexPath: indexPath];
    
    issueCell.tag = indexPath.section;
    issueCell.editMode = self.editMode;
    [issueCell.lblTitle setText: [NSString stringWithFormat: @"Issue title %i", indexPath.section]];
    
    [self loadIssuePreviewForView: issueCell atIndexPath: indexPath];
    
    return issueCell;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *) collectionView {
    
    return _dataSource.count;
}

- (NSInteger)collectionView: (UICollectionView *) collectionView
     numberOfItemsInSection: (NSInteger) section {
    
    return 1;
}

- (CEIssue *) issueForIndexPath: (NSIndexPath *) indexPath {
    
    return _dataSource[indexPath.section];
}


@end
