//
//  CECollectionViewDataSource.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/9/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CECollectionViewDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *albums;

@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

@end
