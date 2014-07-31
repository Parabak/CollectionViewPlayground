//
//  CECarouselItemView.h
//  CollectionViewPlayground
//
//  Created by Baranouski Aliaksandr on 31/07/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEFlowContentInfoView.h"

extern NSString *const kCarouselItemIdentifier;

@interface CECarouselItemView : CEFlowContentInfoView {

    CGFloat _nonmormalizedClampedOffset;
}

@property (nonatomic, assign) CGFloat clampedOffset;
@property (nonatomic, assign) BOOL shouldBeAnimated;
@property (nonatomic, assign) CATransform3D transform3D;


- (void) calculateTransformationForOffset: (CGFloat) offsetFromCenteredItem;

@end
