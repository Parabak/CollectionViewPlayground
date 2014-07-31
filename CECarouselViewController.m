//
//  CECarouselViewController.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECarouselViewController.h"
#import "CECarouselLayout.h"
#import "CEIssueFooterReusableView.h"


@interface CECarouselViewController ()

@end

@implementation CECarouselViewController

@synthesize collectionViewDataSource;
@synthesize collectionViewDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite: 0.25f alpha: 1.0f];
    
    [self.collectionView setDataSource: self.collectionViewDataSource];
    [self.collectionView setDelegate: self.collectionViewDelegate];
    
    [self.collectionView registerClass: [CEFlowContentInfoView class]
            forCellWithReuseIdentifier: kFlowContentInfoViewInendifier];
    
    [self.collectionView registerClass: [CEIssueFooterReusableView class]
            forSupplementaryViewOfKind: kCarouselLayoutIssueTitleKind
                   withReuseIdentifier: kIssueTitleIdentifier];
        
    self.carouselLayout = (CECarouselLayout*) self.collectionViewLayout;
    [self.carouselLayout setupForOrientation: [UIApplication sharedApplication].statusBarOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Properties

- (CECarouselCollectionViewDataSource *) collectionViewDataSource {
    
    if (collectionViewDataSource == nil) {
        
        collectionViewDataSource = [CECarouselCollectionViewDataSource new];
    }
    
    return collectionViewDataSource;
}

- (CECarouselCollectionViewDelegate *)collectionViewDelegate {
    
    if (collectionViewDelegate == nil) {
        
        collectionViewDelegate = [CECarouselCollectionViewDelegate new];
        collectionViewDelegate.scrollview = self.collectionView;
    }
    
    return collectionViewDelegate;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    
    [self.carouselLayout setupForOrientation: toInterfaceOrientation];
}


@end
