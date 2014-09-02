//
//  CECarouselAnimations.h
//  CollectionViewPlayground
//
//  Created by Baranouski Aliaksandr on 31/07/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <Foundation/Foundation.h>

extern CGFloat const kBounceAnimationDuration;

@interface CECarouselAnimations : NSObject

+ (CAKeyframeAnimation*) bouncingAnimationForItem: (UIView*) item;

+ (CAKeyframeAnimation*) bouncingScaleAnimationForItem: (UIView*) item;

@end
