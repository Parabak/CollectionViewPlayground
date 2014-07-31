//
//  CECarouselItemView.m
//  CollectionViewPlayground
//
//  Created by Baranouski Aliaksandr on 31/07/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECarouselItemView.h"

NSString *const kCarouselItemIdentifier = @"IssueCarouselCell";

@implementation CECarouselItemView

@synthesize clampedOffset = _clampedOffset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    if (!CATransform3DEqualToTransform(self.layer.transform, self.transform3D)
        && !CATransform3DEqualToTransform(self.transform3D, CATransform3DIdentity)) {
        
        self.layer.transform = self.transform3D;
    }
}

#pragma mark -
#pragma mark - Properties
- (void)setClampedOffset: (CGFloat) clampedOffset {
    //TODO: clear code
    CGFloat direction = clampedOffset - _nonmormalizedClampedOffset;
    _nonmormalizedClampedOffset = clampedOffset;
    
    CGFloat border = 1.0f;
    if (direction < 0.0f) {
        
        if ( clampedOffset <= -0.5f) { // -0.3f
            
            clampedOffset = -border;
        } else if (clampedOffset >= 0.5f){ // 0.7f
            
            clampedOffset = border;
        } else {
            
            clampedOffset = 0.0f;
        }
        
    } else {
        
        if ( clampedOffset >= -0.5f && clampedOffset <= 0.5f) { // > -0.7f   ... < 0.3f
            
            clampedOffset = 0.0f;
        } else if ( clampedOffset > 0.5f) { // 0.3f
            
            clampedOffset = border;
        } else if ( clampedOffset < -0.5f){ // -0.7f
            
            clampedOffset = -border;
        }
    }
    
    if (clampedOffset != _clampedOffset) {
        
        _clampedOffset = clampedOffset;
    }
}

- (BOOL) shouldBeAnimated {
    
    CGFloat tilt = 0.9f;
    
    CGFloat calculatedRotationAngel = self.clampedOffset * M_PI_4 * tilt;
    CGFloat y_inversion = -1.0f;
    CGFloat realRotationAngel = y_inversion * [(NSNumber *)[self.layer valueForKeyPath:@"transform.rotation.y"] floatValue];
    
    CGFloat calculatedTransformX = self.transform3D.m41;
    CGFloat realTransformX = self.layer.transform.m41;
    
    CGFloat fault = 0.01;//0.001f;
    
    CGFloat delta = (fabs(calculatedRotationAngel - realRotationAngel));
    BOOL y_changed = delta > fault;
    
    delta = fabsf(calculatedTransformX - realTransformX);
    fault = 1.5f;
    BOOL x_changed = delta > fault;
    
    return (y_changed || x_changed) ;
}

#pragma mark -
#pragma mark - Calculate Transformation

- (void) calculateTransformationForOffset: (CGFloat) offsetFromCenteredItem  {
    CGFloat _perspective = -1.0f / 500.0f;
    CGSize _viewpointOffset = CGSizeZero;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = _perspective;
    transform = CATransform3DTranslate(transform, -_viewpointOffset.width, -_viewpointOffset.height, 0.0f);
    
    CGFloat tilt = 0.9f;
    
    // normalisation for interval [-1.0f; 0.0f] and [0.0f; 1.0f]
    CGFloat genericClampedOffset = fmaxf(-1.0f, fminf(1.0f, offsetFromCenteredItem));
    
    [self setClampedOffset: genericClampedOffset];
    CGFloat angle = self.clampedOffset * M_PI_4 * tilt;
    CGFloat z = fabsf(self.clampedOffset) * -kIssueItemWidth / 3;
    
    // It should be a constant
    CGFloat xOffset = 200.0f;
    CGFloat x = self.clampedOffset * xOffset;//;
    
    transform = CATransform3DTranslate(transform, x, 0.0f, z);
    self.transform3D = CATransform3DRotate(transform, angle, 0.0f, -1.0f, 0.0f);
}

@end
