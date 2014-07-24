//
//  CEFlowViewController.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/10/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEFlowViewController.h"
#import "CEFlowContentInfoView.h"
#import "CEIssueFooterReusableView.h"
#import "CEFlowLayout.h"


@implementation CEFlowViewController

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
    
//    [self.collectionView registerClass: [CEIssueFooterReusableView class]
//            forSupplementaryViewOfKind: kFloatLayoutIssueTitleKind
//                   withReuseIdentifier: kIssueTitleIdentifier];

    self.floatLayout = (CEFlowLayout*) self.collectionViewLayout;
    [self.floatLayout setupForOrientation: [UIApplication sharedApplication].statusBarOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Properties

- (CEFloatCollectionViewDataSource *) collectionViewDataSource {
    
    if (collectionViewDataSource == nil) {
        
        collectionViewDataSource = [CEFloatCollectionViewDataSource new];
    }
    
    return collectionViewDataSource;
}

- (CEFloatCollectionViewDelegate *)collectionViewDelegate {
    
    if (collectionViewDelegate == nil) {
        
        collectionViewDelegate = [CEFloatCollectionViewDelegate new];
    }
    
    return collectionViewDelegate;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    
    [self.floatLayout setupForOrientation: toInterfaceOrientation];
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    
//    [self.floatLayout setupForOrientation: [UIApplication sharedApplication].statusBarOrientation];
//}


@end
