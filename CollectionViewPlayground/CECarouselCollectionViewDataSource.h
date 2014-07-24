//
//  CECarouselCollectionViewDataSource.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CECarouselCollectionViewDataSource : NSObject <UICollectionViewDataSource>{
    
    // is equall to total issues count
    NSInteger _columnsCount;
    NSArray *_fakeSource;
    
    // should be replaced by delegate
    UICollectionView *_collectionView;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) getColumnsCount;

@end
