//
//  CEFlowViewController.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/10/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CEFlowLayout.h"
#import "CEFloatCollectionViewDataSource.h"
#import "CEFloatCollectionViewDelegate.h"

@interface CEFlowViewController : UICollectionViewController

@property (nonatomic, weak) IBOutlet CEFlowLayout *floatLayout;

@property (nonatomic, strong) CEFloatCollectionViewDataSource *collectionViewDataSource;
@property (nonatomic, strong) CEFloatCollectionViewDelegate *collectionViewDelegate;

@end
