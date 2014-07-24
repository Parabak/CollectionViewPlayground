//
//  CEFloatCollectionViewDataSource.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/10/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEFlowContentInfoView.h"

@interface CEFloatCollectionViewDataSource : NSObject <UICollectionViewDataSource, IDGItemViewDelegate> {

    // is equall to total issues count
    NSInteger _columnsCount;
    NSArray *_fakeSource;
    
    // should be replaced by delegate
    UICollectionView *_collectionView;
}

@property (nonatomic, assign) BOOL editMode;
/// For Demonstation Only ///
@property (nonatomic, assign) BOOL showUpdateIcon;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) getColumnsCount;

@end
