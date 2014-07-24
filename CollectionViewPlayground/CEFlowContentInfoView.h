//
//  CEFlowContentInfoView.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/10/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IDGItemViewDelegate <NSObject>

@optional

- (void) itemViewDeleteButtonTouched: (NSInteger) index;

@end

extern NSString *const kFlowContentInfoViewInendifier;

extern CGFloat const kIssueItemWidth;
extern CGFloat const kIssueItemHeight;

// notification user info dictionary
extern NSString *const kDownloadingItemIndex;
extern NSString *const kProgressBarValue;

@interface CEFlowContentInfoView : UICollectionViewCell {
    
    UITapGestureRecognizer *_recognizer;
}

@property (nonatomic, assign) BOOL editMode;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIButton *deleteIconButton;
@property (nonatomic, strong) UIButton *btnDelete;

// show the status of item
@property (nonatomic, strong) UIImageView *downloadedIcon;
@property (nonatomic, strong) UIImageView *updateIcon;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, weak) id <IDGItemViewDelegate> delegate;

// for Carousel
@property (nonatomic, assign) CGFloat clampedOffset;
@property (nonatomic, assign) BOOL shouldBeAnimated;

@property (nonatomic, assign) CATransform3D transform3D;

// or it will be better not to ask cell, but use a property of presented model
- (BOOL) isEnabled;

@end
