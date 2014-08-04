//
//  CECarouselAnimations.m
//  CollectionViewPlayground
//
//  Created by Baranouski Aliaksandr on 31/07/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECarouselAnimations.h"

CGFloat const kBounceAnimationDuration = 0.6f;

@implementation CECarouselAnimations

+ (CAKeyframeAnimation*) bouncingAnimationForItem: (UIView*) item {
    
    CAKeyframeAnimation *bouncingAnimation = [CAKeyframeAnimation animationWithKeyPath: @"transform"];
    
    CATransform3D startingScale = CATransform3DIdentity;
    CATransform3D undershootScale = CATransform3DTranslate(item.layer.transform, 0.0f, 0.0f, -50.0f);
    BOOL landscapeOrientation = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    CATransform3D overshootScale = CATransform3DTranslate(item.layer.transform, 0.0f, 0.0f, landscapeOrientation ? 375.0f : 315.0f);
    
    NSArray *boundsValues = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:startingScale],
                             [NSValue valueWithCATransform3D: undershootScale],
                             [NSValue valueWithCATransform3D :overshootScale], nil];
    [bouncingAnimation setValues:boundsValues];
    
    NSArray *times = [NSArray arrayWithObjects:[NSNumber numberWithFloat: 0.0f],
                      [NSNumber numberWithFloat: 0.2f],
                      [NSNumber numberWithFloat: 1.0f], nil];
    [bouncingAnimation setKeyTimes:times];
    [bouncingAnimation setDuration: 0.6f];
    
    NSArray *timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], nil];
    
    [bouncingAnimation setTimingFunctions:timingFunctions];
    bouncingAnimation.fillMode = kCAFillModeForwards;
    bouncingAnimation.removedOnCompletion = YES;
    
    [item.superview bringSubviewToFront: item];
    
    return bouncingAnimation;
}

@end
