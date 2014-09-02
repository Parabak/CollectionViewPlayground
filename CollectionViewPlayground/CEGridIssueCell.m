//
//  CEGridIssueCell.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/9/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEGridIssueCell.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const kPhoneIssueCellWidth = 133.0f;
CGFloat const kPhoneIssueCellHeight = 200.0f;

CGFloat const kPhoneImagePreviewWidth = 130.0f;
CGFloat const kPhoneImagePreviewHeight = 173.0f;
CGFloat const kPhoneIssueSupplementHeight = 20.0f;
CGFloat const kPhoneIssueTitleImagePadding = 4.0f;

NSString * const kIssueGridCellIdentifier = @"IssueGridCell";


@implementation UIProgressView (customView)

- (CGSize)sizeThatFits:(CGSize)size {
    
    CGSize newSize = CGSizeMake(kPhoneImagePreviewWidth, kPhoneIssueSupplementHeight);
    
    return newSize;
}

@end


@implementation CEGridIssueCell

@synthesize lblTitle = _lblTitle;

#pragma mark - Properties

- (CGSize) imageViewSize {

    return CGSizeMake(kPhoneImagePreviewWidth, kPhoneImagePreviewHeight);
}

- (CGFloat) supplementHeight {
    
    return kPhoneIssueSupplementHeight;
}

- (CGFloat) titleImagePadding {
    
    return kPhoneIssueTitleImagePadding;
}

- (UILabel *) lblTitle {
    
    if (_lblTitle == nil) {
        
        _lblTitle = [super lblTitle];
        [_lblTitle setFont: [UIFont systemFontOfSize: 10.0f]];
    }

    return _lblTitle;
}

@end
