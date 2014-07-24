//
//  CECollectionViewDataSource.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/9/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECollectionViewDataSource.h"

#import "CEGridIssueCell.h"
#import "CEIssueFooterReusableView.h"

#import "BHAlbum.h"
#import "BHPhoto.h"

@implementation CECollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *) collectionView {
    
    return self.albums.count;
}

- (NSInteger)collectionView: (UICollectionView *) collectionView
     numberOfItemsInSection: (NSInteger) section {
    
    BHAlbum *album = self.albums[section];
    
    return album.photos.count;
}

- (UICollectionViewCell *)collectionView: (UICollectionView *) collectionView
                  cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    CEGridIssueCell *issueCell = [collectionView dequeueReusableCellWithReuseIdentifier: kIssueGridCellIdentifier
                                                                           forIndexPath: indexPath];
    
    if (issueCell) {
        
        [issueCell setBackgroundColor: [UIColor whiteColor]];
        
        BHAlbum *album = self.albums[indexPath.section];
        BHPhoto *photo = album.photos[indexPath.item];
        
        // load photo images in the background
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [photo image];
            
        dispatch_async(dispatch_get_main_queue(), ^{
                // then set them via the main queue if the cell is still visible.

            issueCell.imageView.image = image;
    
            });
        }];
        
        operation.queuePriority = (indexPath.item == 0) ?
        NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
        
        [self.thumbnailQueue addOperation:operation];
    }
    
    return issueCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    CEIssueFooterReusableView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind: kind
                                                                              withReuseIdentifier: kIssueTitleIdentifier
                                                                                     forIndexPath: indexPath];
    
    BHAlbum *album = self.albums[indexPath.section];
    
    titleView.titleLabel.text = album.name;
    
    return titleView;
}

#pragma mark -
#pragma mark - Init sources

- (id) init {
    
    self = [super init];
    
    if (self) {
        
        self.albums = [NSMutableArray array];
        
        self.thumbnailQueue = [[NSOperationQueue alloc] init];
        self.thumbnailQueue.maxConcurrentOperationCount = 3;

        
        NSURL *urlPrefix =
        [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
        
        NSInteger photoIndex = 0;
        
        for (NSInteger a = 0; a < 12; a++) {
            BHAlbum *album = [[BHAlbum alloc] init];
            album.name = [NSString stringWithFormat:@"Photo Album %d",a + 1];
            
            NSUInteger photoCount = arc4random()%4 + 2;
            for (NSInteger p = 0; p < photoCount; p++) {
                // there are up to 25 photos available to load from the code repository
                NSString *photoFilename = [NSString stringWithFormat:@"thumbnail%d.jpg",photoIndex % 25];
                NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFilename];
                BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
                [album addPhoto:photo];
                
                photoIndex++;
            }
            
            [self.albums addObject:album];
        }
    }
    
    return self;
}

@end
