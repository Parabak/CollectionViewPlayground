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

#pragma mark -
#pragma mark - Datasource Delegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    CEIssueFooterReusableView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind: kind
                                                                              withReuseIdentifier: kIssueTitleIdentifier
                                                                                     forIndexPath: indexPath];
    
    return titleView;
}

@end
