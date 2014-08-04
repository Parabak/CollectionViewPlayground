//
//  CECarouselViewController.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CECarouselCollectionViewDataSource.h"
#import "CECarouselCollectionViewDelegate.h"


@class CECarouselLayout;

@interface CECarouselViewController : UICollectionViewController <CECarouselSelectionDelegate>

@property (nonatomic, strong) CECarouselLayout *carouselLayout;

@property (nonatomic, strong) CECarouselCollectionViewDataSource *collectionViewDataSource;
@property (nonatomic, strong) CECarouselCollectionViewDelegate *collectionViewDelegate;

@end
