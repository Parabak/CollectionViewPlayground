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
CGFloat const kIssueItemWidth = 365.0f;
CGFloat const kIssueItemHeight = 555.0f;

// private constants
CGFloat const kIssueCoverHeight = 490.0f;
CGFloat const kIssueSupplementleHeight = 60.0f;
CGFloat const kTitleImagePadding = 15.0f;
CGFloat const kIconsTitlePadding = 5.0f;

// notification user info dictionary
NSString *const kDownloadingItemIndex = @"DownloadingItemIndex";
NSString *const kProgressBarValue = @"ProgressBarValue";


@implementation UIProgressView (customView)

- (CGSize)sizeThatFits:(CGSize)size {
    
    CGSize newSize = CGSizeMake(kIssueItemWidth, kIssueSupplementleHeight);

    return newSize;
}

@end

@implementation CEFlowContentInfoView

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
		[self addSubview:    self.downloadedIcon];
        [self addSubview:    self.deleteIconButton];
        [self addSubview:    self.btnDelete];
        
        if (!MINIsRetina()) {
            
            [_deleteIconButton.layer setShouldRasterize: YES];
            [_deleteIconButton.layer setRasterizationScale: 3.0f];
        }
        
        [self.layer setMinificationFilter: kCAFilterTrilinear];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) layoutSubviews {
	
	_imageView.frame = CGRectMake(0, 0, self.imageViewSize.width, self.imageViewSize.height);
    
    _activityIndicator.center = _imageView.center;
    
    _maskView.frame = self.bounds;
    
    [_lblTitle sizeToFit];

	_lblTitle.frame = CGRectMake((_imageView.frame.size.width - _lblTitle.frame.size.width) / 2,
                                 _imageView.frame.origin.y + _imageView.frame.size.height + self.titleImagePadding,
                                 _lblTitle.frame.size.width, _lblTitle.frame.size.height);
	
    _progressView.frame = CGRectMake(0.0f, self.imageViewSize.height,
                                     _progressView.frame.size.width,
                                     _progressView.frame.size.height);
    
	_updateIcon.center = CGPointMake(_lblTitle.frame.origin.x - _updateIcon.frame.size.width - kIconsTitlePadding,
                                     _lblTitle.center.y);
	_downloadedIcon.center = _updateIcon.center;
    
    _deleteIconButton.center = CGPointMake(_downloadedIcon.center.x + 1, _downloadedIcon.center.y);
    _btnDelete.frame = CGRectMake(_imageView.frame.origin.x,
                                  _imageView.frame.origin.y + _imageView.frame.size.height - 1,
                                  _imageView.frame.size.width,
                                  self.supplementHeight);
    
//    BOOL isUpdateIconVisible = (_updateIcon.image != nil && _updateIcon.hidden == NO);
    BOOL isDownloadedIconVisible = (_downloadedIcon.image != nil && _downloadedIcon.hidden == NO);
//    BOOL isIconVisible = isUpdateIconVisible || isDownloadedIconVisible || _deleteIconButton.superview;
    BOOL isIconVisible  = !_deleteIconButton.hidden;
    
    if (isIconVisible || isDownloadedIconVisible) {
        
        [self layoutWithVisibleIcons];
    }
    else {
        
        [self layoutTitleLable];
    }
    
    [self sizeToFit];
    
//    [self.centerLine setCenter: _imageView.center];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

- (CGSize) sizeThatFits: (CGSize) size {
    
    CGFloat height = _imageView.frame.origin.y + _imageView.frame.size.height + self.supplementHeight;
    
    return CGSizeMake(self.imageViewSize.width, height);
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
    
    self.downloadedIcon.hidden = YES;
    self.updateIcon.hidden = YES;
    [self.deleteIconButton setHidden: NO];
}

- (void) showDeleteButton {

    [self.deleteIconButton setHidden: YES];
    [self.btnDelete setHidden: NO];
    _recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDeleteButtonRecognizer:)];
    [_imageView addGestureRecognizer:_recognizer];
    
    _imageView.userInteractionEnabled = YES;
}

- (void) hideAllDeleteStuff {
    
    [_updateIcon setHidden: NO];
    [_btnDelete setHidden: YES];
    [_deleteIconButton setHidden: YES];
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

- (CGFloat) supplementHeight {
    
    return kIssueSupplementleHeight;
}

- (CGFloat) titleImagePadding {
    
    return kTitleImagePadding;
}

- (CGSize) imageViewSize {
    
    return CGSizeMake(kIssueItemWidth, kIssueCoverHeight);
}

- (UIImageView *) imageView {
    
    if (_imageView == nil) {
        
        _imageView = [[UIImageView alloc] init];
        //        _imageView.layer.borderWidth = [StyleSheet shared].idgItemBorderWidth;
        //		_imageView.layer.borderColor = [StyleSheet shared].idgItemBorderColor.CGColor;
        _imageView.layer.borderWidth = 2.0f;
		_imageView.layer.borderColor = [UIColor colorWithRed: 223.0f / 255.0f
                                                       green:223.0f / 255.0f
                                                        blue:223.0f / 255.0f
                                                       alpha: 1.0f].CGColor;
        
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
        [_btnDelete setFrame: CGRectMake(_btnDelete.frame.origin.x, _btnDelete.frame.origin.y, self.frame.size.width, self.supplementHeight)];
        
		[_btnDelete addTarget: self
                       action: @selector(deleteButtonTouched)
             forControlEvents: UIControlEventTouchUpInside];
        
	}
    
    return _btnDelete;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
#pragma mark - Additional Layout

- (void) layoutWithVisibleIcons {
    
    CGFloat maxWidth = self.imageViewSize.width - (_downloadedIcon.frame.size.width + _downloadedIcon.frame.size.width / 2.0);
    
    CGFloat actualWidth = MIN(maxWidth, _lblTitle.frame.size.width);
    
    CGFloat combinedWidth = actualWidth + (_downloadedIcon.frame.size.width + _downloadedIcon.frame.size.width / 2.0);
    CGFloat origin = (_imageView.frame.size.width - combinedWidth) / 2;
    
    _updateIcon.frame = CGRectMake(origin,
                                   _imageView.frame.origin.y + _imageView.frame.size.height + self.titleImagePadding,
                                   _updateIcon.frame.size.width, _updateIcon.frame.size.height);
    _downloadedIcon.center = _updateIcon.center;
    

    _deleteIconButton.center = _updateIcon.center;
    
    if (_deleteIconButton.hidden) {
    
        _lblTitle.frame = CGRectMake(_updateIcon.frame.origin.x + _updateIcon.frame.size.width + _updateIcon.frame.size.width / 2,
                                     _imageView.frame.origin.y + _imageView.frame.size.height + self.titleImagePadding,
                                     actualWidth, _lblTitle.frame.size.height);
    } else {
        
        _lblTitle.frame = CGRectMake(_deleteIconButton.frame.origin.x + _deleteIconButton.frame.size.width + _deleteIconButton.frame.size.width / 2,
                                     _imageView.frame.origin.y + _imageView.frame.size.height + self.titleImagePadding,
                                     actualWidth, _lblTitle.frame.size.height);
    }
}

- (void) layoutTitleLable {
    
    CGFloat maxWidth = self.imageViewSize.width;
    
    _lblTitle.frame = CGRectMake((_imageView.frame.size.width - maxWidth) / 2,
                                 _imageView.frame.origin.y + _imageView.frame.size.height + self.titleImagePadding,
                                 maxWidth, _lblTitle.frame.size.height);
}

@end
