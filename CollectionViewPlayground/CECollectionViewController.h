//
//  CEViewController.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/9/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CEGridLayout.h"
#import "CEGridIssueCell.h"
#import "CEIssueFooterReusableView.h"
#import "CECollectionViewSelectionDelegate.h"


@class CECollectionViewDataSource, CEGridViewDelegate;

@interface CECollectionViewController : UICollectionViewController <CECollectionViewSelectionDelegate>

@property (nonatomic, weak) IBOutlet CEGridLayout *gridLayout;

@property (nonatomic, strong) CEGridViewDelegate *collectionViewDelegate;
@property (nonatomic, strong) CECollectionViewDataSource *collectionViewDataSource;

@end
