//
//  CECarouselCollectionViewDataSource.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECarouselCollectionViewDataSource.h"
#import "CECarouselItemView.h"
#import "CECarouselFooterView.h"
#import "CECarouselCollectionViewDelegate.h"

#import "CEIssue.h"
#import "BHPhoto.h"

@interface CECarouselCollectionViewDataSource ()

// Test
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

@end

@implementation CECarouselCollectionViewDataSource

- (id) init {
    
    self = [super init];
    
    if (self) {
        
        NSMutableArray *issues = [NSMutableArray array];

        self.thumbnailQueue = [[NSOperationQueue alloc] init];
        self.thumbnailQueue.maxConcurrentOperationCount = 3;
        
        for (NSInteger index = 0; index < 20; index++) {
            
            CEIssue *issue = [[CEIssue alloc] init];
            NSURL *urlPath = [NSURL URLWithString: [self getURLStringForIndex: index]];
            issue.issuePreview = [BHPhoto photoWithImageURL: urlPath];
            
            [issues addObject: issue];
        }
        
        _fakeSource = [NSMutableArray arrayWithArray: issues];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Public

- (NSInteger) getColumnsCount {
    
    return _fakeSource.count;
}

#pragma mark -
#pragma mark - Datasource Delegate

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *) collectionView {
    
    return 1;
}

- (NSInteger)collectionView: (UICollectionView *) collectionView
     numberOfItemsInSection: (NSInteger) section {
    
    _collectionView = collectionView;
    
    return _fakeSource.count;
}

- (UICollectionViewCell *)collectionView: (UICollectionView *) collectionView
                  cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    CECarouselItemView *issueCell = [collectionView dequeueReusableCellWithReuseIdentifier: kCarouselItemIdentifier
                                                                                 forIndexPath: indexPath];
    
    issueCell.tag = indexPath.item;
    [issueCell.lblTitle setText: [NSString stringWithFormat: @"Issue title %i", indexPath.item]];
    
    CEIssue *issue = _fakeSource[indexPath.item];
    
    // load photo images in the background
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [issue.issuePreview image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            issueCell.imageView.image = image;
            
        });
    }];
    operation.queuePriority = (indexPath.item == 0) ?
    NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    [self.thumbnailQueue addOperation:operation];
    
    //TODO: move to item method
    issueCell.clampedOffset = 0;

    CGFloat currentOffset = ((CECarouselCollectionViewDelegate*) collectionView.delegate).currentOffset;
    [issueCell calculateTransformationForOffset: indexPath.item - currentOffset];
    
    return issueCell;
}


#pragma mark - Test section
- (NSString *) getURLStringForIndex: (NSInteger) index {
    
    NSArray *urlsStrings = @[
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=22140704&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=21140627&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=23140606&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=21140530&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=22140509&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=24140506&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=21140430&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=24140406&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=23140404&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=21140328&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=24140326&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=24140317&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=22140307&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=21140228&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=23140207&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=24140202&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=21140201&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=21140131&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=24140120&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=22140117&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=24140101&format=preview-double",
    @"https://epaper-idg.mineus.com/macwelt/live/ipad/v3/issue-page-preview?id=23140101&format=preview-double"];
    
    if (index < urlsStrings.count) {
        
        return urlsStrings[index];
    } else {
        
        return @"";
    }
}

@end
