//
//  CEIssueFooterReusableView.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/10/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEIssueFooterReusableView : UICollectionReusableView

extern NSString * const kIssueTitleIdentifier;

@property (nonatomic, strong, readonly) UILabel *titleLabel;

@end
