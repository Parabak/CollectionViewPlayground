//
//  CECarouselFooterView.h
//  CollectionViewPlayground
//
//  Created by Baranouski Aliaksandr on 01/08/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEIssueFooterReusableView.h"

extern NSString * const kCarouselSupplementaryItemIdentifier;

@interface CECarouselFooterView : CEIssueFooterReusableView {
    
    CGFloat _nonmormalizedClampedOffset;
}

@property (nonatomic, assign) CGFloat clampedOffset;
@property (nonatomic, assign) BOOL shouldBeAnimated;
@property (nonatomic, assign) CATransform3D transform3D;


- (void) calculateTransformationForOffset: (CGFloat) offsetFromCenteredItem;


@end
