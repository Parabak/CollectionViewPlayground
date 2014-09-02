//
//  CECollectionViewSelectionDelegate.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 9/1/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CECollectionViewSelectionDelegate <NSObject>

@required

- (void) itemSelectedAtIndexPath: (NSIndexPath *) indexPath;

@end

