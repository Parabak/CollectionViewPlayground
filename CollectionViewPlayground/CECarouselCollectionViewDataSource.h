//
//  CECarouselCollectionViewDataSource.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CEFlowContentInfoView.h"

@interface CECarouselCollectionViewDataSource : NSObject <UICollectionViewDataSource, IDGItemViewDelegate>{
    
    // is equall to total issues count
    NSInteger _columnsCount;
    NSArray *_fakeSource;
    
    // should be replaced by delegate
    UICollectionView *_collectionView;
}

// for demonstrate
@property (nonatomic, assign) BOOL editMode;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) getColumnsCount;

@end
