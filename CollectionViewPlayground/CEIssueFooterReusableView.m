//
//  CEIssueFooterReusableView.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/10/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEIssueFooterReusableView.h"

NSString * const kIssueTitleIdentifier = @"IssueTitle";

@interface CEIssueFooterReusableView ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation CEIssueFooterReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                            UIViewAutoresizingFlexibleHeight;
        self.titleLabel.backgroundColor = [UIColor redColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        self.titleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        self.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
                
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
}

@end
