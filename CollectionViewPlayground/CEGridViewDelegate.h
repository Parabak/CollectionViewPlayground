//
//  CEGridViewDelegate.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 9/1/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CECollectionViewSelectionDelegate.h"

@interface CEGridViewDelegate : NSObject <UICollectionViewDelegate>

@property (nonatomic, assign) id<CECollectionViewSelectionDelegate> delegate;

@end
