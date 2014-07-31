//
//  CEFlowContentInfoView.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/10/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEFlowContentInfoView.h"

NSString *const kFlowContentInfoViewInendifier = @"IssueFloatCell";

// visible constants
CGFloat const kIssueItemWidth = 265.0f; // 365
CGFloat const kIssueItemHeight = 325.0f; // 555

// private constants
CGFloat const kIssueCoverHeight = 250;//490.0f;
CGFloat const kIssueSupplementleHeight = 60.0f;
CGFloat const kIconsTitlePadding = 5.0f;

// notification user info dictionary
NSString *const kDownloadingItemIndex = @"DownloadingItemIndex";
NSString *const kProgressBarValue = @"ProgressBarValue";


const CGSize imageViewSize = {kIssueItemWidth, kIssueCoverHeight};

@implementation UIProgressView (customView)

- (CGSize)sizeThatFits:(CGSize)size {
    
    CGSize newSize = CGSizeMake(kIssueItemWidth, kIssueSupplementleHeight);

    return newSize;
}

@end

@interface CEFlowContentInfoView () {

    CGFloat _nonmormalizedClampedOffset;
}

@end

@implementation CEFlowContentInfoView

@synthesize clampedOffset = _clampedOffset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(showProgressBar:)
                                                     name: @"testNotificationProgress"
                                                   object: nil];
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:    self.imageView];
        [self addSubview:    self.activityIndicator];
        [self insertSubview: self.maskView belowSubview: self.activityIndicator];
		[self addSubview:    self.lblTitle];
		[self addSubview:    self.updateIcon];
        [self addSubview:    self.progressView];
		[self addSubview: self.downloadedIcon];
        
        // for test purposes
        self.centerLine = [[UIView alloc] initWithFrame: CGRectFromString(@"{{0.0f, 0.0f},{2.0f, 80.0f}}")];
        [self.centerLine setBackgroundColor: [UIColor colorWithRed: 17.0f / 255.0f
                                                        green:210.0f / 255.0f
                                                         blue: 1.0f
                                                        alpha: 1.0f]];
        
        [self addSubview: self.centerLine];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) layoutSubviews {
	
	_imageView.frame = CGRectMake(0, 0, imageViewSize.width, imageViewSize.height);
    
    _activityIndicator.center = _imageView.center;
    
    _maskView.frame = self.bounds;
    
    [_lblTitle sizeToFit];

	_lblTitle.frame = CGRectMake((_imageView.frame.size.width - _lblTitle.frame.size.width) / 2,
                                 _imageView.frame.origin.y + _imageView.frame.size.height + 15,
                                 _lblTitle.frame.size.width, _lblTitle.frame.size.height);
	
    
    _progressView.frame = CGRectMake(0.0f, imageViewSize.height,
                                     _imageView.frame.size.width,
                                     kIssueSupplementleHeight);
    
	_updateIcon.center = CGPointMake(_lblTitle.frame.origin.x - _updateIcon.frame.size.width - kIconsTitlePadding,
                                     _lblTitle.center.y);
	_downloadedIcon.center = _updateIcon.center;
    
    _deleteIconButton.center = CGPointMake(_downloadedIcon.center.x + 1, _downloadedIcon.center.y);
    _btnDelete.frame = CGRectMake(_imageView.frame.origin.x,
                                      _imageView.frame.origin.y + _imageView.frame.size.height - 1,
                                      _imageView.frame.size.width,
                                      kIssueSupplementleHeight);
    
//    BOOL isUpdateIconVisible = (_updateIcon.image != nil && _updateIcon.hidden == NO);
    BOOL isDownloadedIconVisible = (_downloadedIcon.image != nil && _downloadedIcon.hidden == NO);
//    BOOL isIconVisible = isUpdateIconVisible || isDownloadedIconVisible || _deleteIconButton.superview;
    BOOL isIconVisible  = _deleteIconButton.superview != nil;
    
    if (isIconVisible || isDownloadedIconVisible) {
        
        [self layoutWithVisibleIcons];
    }
    else {
        
        [self layoutTitleLable];
    }
    
    [self sizeToFit];
    
    [self.centerLine setCenter: _imageView.center];
    
    if (!CATransform3DEqualToTransform(self.layer.transform, self.transform3D)
        && !CATransform3DEqualToTransform(self.transform3D, CATransform3DIdentity)) {
        
        self.layer.transform = self.transform3D;
    }
}


- (CGSize) sizeThatFits: (CGSize) size {
    
    CGFloat height = _imageView.frame.origin.y + _imageView.frame.size.height + kIssueSupplementleHeight;
    
    return CGSizeMake(imageViewSize.width, height);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - Delete Actions

- (void)setEditMode:(BOOL)editMode {
    
    _editMode = editMode;
    
    if (_editMode) {
        
        [self showDeleteIcon];
    } else {
        
        [self hideAllDeleteStuff];
    }
}

- (void) showDeleteIcon {
    
    [self.btnDelete setHidden: YES];
    [self.deleteIconButton setHidden: NO];
}

- (void) showDeleteButton {

    [self.btnDelete setHidden: NO];
    _recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDeleteButtonRecognizer:)];
    [_imageView addGestureRecognizer:_recognizer];
    
    _imageView.userInteractionEnabled = YES;
//    if (_delegate && [_delegate respondsToSelector:@selector(itemViewDidShowDeleteButton:)]) {
//        
//        [_delegate itemViewDidShowDeleteButton:self];
//    }
}

- (void) hideAllDeleteStuff {
    
    [_btnDelete removeFromSuperview];
    [_deleteIconButton removeFromSuperview];
}

- (void) removeDeleteButtonRecognizer: (UITapGestureRecognizer *) recognizer {
    
    [_btnDelete removeFromSuperview];
    
    [_imageView removeGestureRecognizer:_recognizer];
}

- (void) deleteButtonTouched {
    
    [self.delegate itemViewDeleteButtonTouched: self.tag];
}

- (void) showProgressBar: (NSNotification *) item {

    NSDictionary *userInfo = item.userInfo;
    if (((NSNumber*)[userInfo objectForKey: kDownloadingItemIndex]).integerValue == self.tag) {
        
        NSNumber *value = [userInfo objectForKey: kProgressBarValue];
        
        if (self.progressView.progress == 1.0f) {
            
            return;
        }
        
        self.progressView.hidden = NO;
        [self bringSubviewToFront: self.progressView];
        [self animateMaskAlpha: 0.45f withDuration:0.22f];
        
        CGFloat animationDuration = 1.0f;
        
        [UIView animateWithDuration: animationDuration animations:^{
           
            [self.activityIndicator startAnimating];
            [self.progressView setProgress: value.floatValue
                                  animated: YES];
        }];
        
        
        // we should call it, because comletion block of animation is called instandly, without any delay
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (self.progressView.progress >= 1.0f) {
                
                [self.activityIndicator stopAnimating];
                
                [self animateMaskAlpha: 0.0f withDuration:0.22f];

                self.progressView.hidden = YES;
                self.updateIcon.hidden = YES;
                self.downloadedIcon.hidden = NO;
                [self layoutSubviews];
            }
        });
    }
}

#pragma mark -
#pragma mark - Private

- (void) animateMaskAlpha: (CGFloat) alpha withDuration: (CGFloat) duration {
    
    [UIView animateWithDuration: duration animations:^{
        
        self.maskView.alpha = alpha;
    }];
}

#pragma mark -
#pragma mark - Public

- (BOOL) isEnabled {
    
    return !self.activityIndicator.isAnimating;
}


#pragma mark -
#pragma mark - Properties

- (UIImageView *) imageView {
    
    if (_imageView == nil) {
        
        _imageView = [[UIImageView alloc] init];
        //        _imageView.layer.borderWidth = [StyleSheet shared].idgItemBorderWidth;
        //		_imageView.layer.borderColor = [StyleSheet shared].idgItemBorderColor.CGColor;
        _imageView.layer.borderWidth = 3.0f;
        _imageView.layer.borderColor = [UIColor redColor].CGColor;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    return _imageView;
}

- (UIActivityIndicatorView *) activityIndicator {
    
    if (_activityIndicator == nil) {
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    }
    
    return _activityIndicator;
}

- (UIView *) maskView {
    
    if (_maskView == nil) {
        
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.0f;
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _maskView;
}

- (UILabel *)lblTitle {
    
    if (_lblTitle == nil) {
        
        _lblTitle = [[UILabel alloc] init];
		_lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.numberOfLines = 1;
        _lblTitle.minimumScaleFactor = 0.6f;
        _lblTitle.adjustsFontSizeToFitWidth = YES;
		_lblTitle.textColor = [UIColor darkGrayColor];
		_lblTitle.backgroundColor = [UIColor clearColor];
        //		_lblTitle.font = [StyleSheet shared].idgItemTitleFont;
    }
    
    return _lblTitle;
}

- (UIImageView *)updateIcon {
    
    if (_updateIcon == nil) {
        
        UIImage *image = [UIImage imageNamed: @"update_icon"];
		_updateIcon = [[UIImageView alloc] initWithImage: image];
        [_updateIcon sizeToFit];
//        _updateIcon.hidden = YES;
    }
    
    return _updateIcon;
}

- (UIProgressView *) progressView {
    
    if (_progressView == nil) {
        
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor greenColor];
        _progressView.progressViewStyle = UIProgressViewStyleBar;
        _progressView.hidden = YES;
    }
    
    return _progressView;
}

- (UIImageView *) downloadedIcon {
    
    if (_downloadedIcon == nil) {
        
        //        image = [StyleSheet shared].okIcon;
		_downloadedIcon = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"ok_icon"]];
        [_downloadedIcon sizeToFit];
        _downloadedIcon.hidden = YES;
    }
    
    return _downloadedIcon;
}

- (UIButton *) deleteIconButton {
    
    if (_deleteIconButton == nil) {
        
        _deleteIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteIconButton setImage: [UIImage imageNamed: @"delete_button"] forState:UIControlStateNormal];
        [_deleteIconButton addTarget: self
                              action: @selector(showDeleteButton)
                    forControlEvents: UIControlEventTouchUpInside];
        [_deleteIconButton sizeToFit];
        
        if (!MINIsRetina()) {
            
            [_deleteIconButton.layer setShouldRasterize: YES];
            [_deleteIconButton.layer setRasterizationScale: 3.0f];
        }
    }
    
    return _deleteIconButton;
}

- (UIButton *) btnDelete {
    
    if(_btnDelete == nil) {
        
		_btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDelete setBackgroundColor:[UIColor redColor]];
		_btnDelete.titleLabel.font = [UIFont systemFontOfSize: 20.0f];
        [_btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //		[_btnDelete setTitle: MINLocalizedString(@"DELETE", nil) forState: UIControlStateNormal];
        [_btnDelete setTitle: @"Delete" forState: UIControlStateNormal];
        [_btnDelete setFrame: CGRectMake(_btnDelete.frame.origin.x, _btnDelete.frame.origin.y, self.frame.size.width, kIssueSupplementleHeight)];
        
		[_btnDelete addTarget: self
                       action: @selector(deleteButtonTouched)
             forControlEvents: UIControlEventTouchUpInside];
        
	}
    
    return _btnDelete;
}

// FOR CAROUSEL

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
    
    CGFloat xOffset = 200.0f;
    CGFloat x = self.clampedOffset * xOffset;// + offsetFromCenteredItem;
    CGFloat tx = self.layer.transform.m41;
    
//    if (self.tag == 13) {
//        
//        NSLog(@"tx = %f x = %f", tx, x);
//        NSLog(@"%i", (y_changed || x_changed) && tx != x);
//    }
    
    return (y_changed || x_changed) ; //&& tx != x
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
#pragma mark - Additional Layout

- (void) layoutWithVisibleIcons {
    
    CGFloat maxWidth = imageViewSize.width;// - (_downloadedIcon.frame.size.width + _downloadedIcon.frame.size.width / 2.0);
    
    CGFloat actualWidth = MIN(maxWidth, _lblTitle.frame.size.width);
    
    CGFloat combinedWidth = actualWidth + (_downloadedIcon.frame.size.width + _downloadedIcon.frame.size.width / 2.0);
    CGFloat origin = (_imageView.frame.size.width - combinedWidth) / 2;
    
    _updateIcon.frame = CGRectMake(origin,
                                   _imageView.frame.origin.y + _imageView.frame.size.height + 15,
                                   _updateIcon.frame.size.width, _updateIcon.frame.size.height);
    _downloadedIcon.center = _updateIcon.center;
    
    if (_deleteIconButton.superview) {
        
        _deleteIconButton.center = _updateIcon.center;
    }
    
    _lblTitle.frame = CGRectMake(_updateIcon.frame.origin.x + _updateIcon.frame.size.width + _updateIcon.frame.size.width / 2,
                                 _imageView.frame.origin.y + _imageView.frame.size.height + 15,
                                 actualWidth, _lblTitle.frame.size.height);
}

- (void) layoutTitleLable {
    
    CGFloat maxWidth = imageViewSize.width;
    
    _lblTitle.frame = CGRectMake((_imageView.frame.size.width - maxWidth) / 2,
                                 _imageView.frame.origin.y + _imageView.frame.size.height + 15,
                                 maxWidth, _lblTitle.frame.size.height);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Carousel
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

+ (void) printTransformMatrix: (CATransform3D ) transform {
    
    NSLog(@"\n%f %f %f %f\n%f %f %f %f\n%f %f %f %f\n%f %f %f %f",
          transform.m11,
          transform.m21,
          transform.m31,
          transform.m41,
          transform.m12,
          transform.m22,
          transform.m32,
          transform.m42,
          transform.m13,
          transform.m23,
          transform.m33,
          transform.m43,
          transform.m14,
          transform.m24,
          transform.m34,
          transform.m44);
}

@end
