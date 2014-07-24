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


@class CECollectionViewDataSource, CEFloatCollectionViewDelegate;

@interface CECollectionViewController : UICollectionViewController

@property (nonatomic, weak) IBOutlet CEGridLayout *gridLayout;

@property (nonatomic, strong) CEFloatCollectionViewDelegate *collectionViewDelegate;
@property (nonatomic, strong) CECollectionViewDataSource *collectionViewDataSource;

@end
