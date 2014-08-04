//
//  CECarouselItemView.h
//  CollectionViewPlayground
//
//  Created by Baranouski Aliaksandr on 31/07/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEFlowContentInfoView.h"

extern CGFloat const kOffsetTriggerValue; // it's value in percents. Means the distance between item and center position.
extern NSString *const kCarouselItemIdentifier;

@interface CECarouselItemView : CEFlowContentInfoView {

    CGFloat _nonmormalizedClampedOffset;
}

@property (nonatomic, assign) CGFloat clampedOffset;
@property (nonatomic, assign) BOOL shouldBeAnimated;
@property (nonatomic, assign) CATransform3D transform3D;

//For demostration
@property (nonatomic, strong) NSString *presentedImageURL;

- (void) calculateTransformationForOffset: (CGFloat) offsetFromCenteredItem;

@end
