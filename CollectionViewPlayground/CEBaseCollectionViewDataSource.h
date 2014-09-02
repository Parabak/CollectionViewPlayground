//
//  CEBaseCollectionViewDataSource.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 8/6/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CEFlowContentInfoView.h"

@interface CEBaseCollectionViewDataSource : NSObject <UICollectionViewDataSource, IDGItemViewDelegate> {
    
    // is equall to total issues count
    NSArray *_dataSource;
    
    //TOTAL should be replaced by delegate
    UICollectionView *_collectionView;
}

@property (nonatomic, assign) BOOL editMode;

@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

/// For Demonstation Only ///
@property (nonatomic, assign) BOOL showUpdateIcon;

- (NSInteger) getColumnsCount;
- (void) loadIssuePreviewForView: (CEFlowContentInfoView *) issueCell
                     atIndexPath: (NSIndexPath *) indexPath;

@end
