//
//  CEMainViewController.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/16/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEMainViewController.h"

#import "CEFlowViewController.h"
#import "CEFlowLayout.h"
#import "CEFlowContentInfoView.h"

#import "CECarouselViewController.h"
#import "CECarouselLayout.h"


@interface CEMainViewController () {
    
    CGFloat test;
}
    
@property (nonatomic, strong) CEFlowViewController *flowController;
@property (nonatomic, strong) CECarouselViewController *carouselController;

@end

@implementation CEMainViewController

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
    
    [self addChildViewController: self.flowController];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (CEFlowViewController *) flowController {
    
    if (_flowController == nil) {
        
        _flowController = [[CEFlowViewController alloc] initWithCollectionViewLayout: [CEFlowLayout new]];
        
        [_flowController.view setFrame: self.view.bounds];
        
        [self.view addSubview: _flowController.view];
        [self.view sendSubviewToBack: _flowController.view];
    }
    
    return _flowController;
}

- (CECarouselViewController *)carouselController {
    
    if (_carouselController == nil) {
        
        _carouselController = [[CECarouselViewController alloc] initWithCollectionViewLayout: [CECarouselLayout new]];
        
        [_carouselController.view setFrame: self.view.bounds];
        
        [self.view addSubview: _carouselController.view];
        [self.view sendSubviewToBack: _carouselController.view];
    }
    
    return _carouselController;
}

#pragma mark - Public
- (IBAction)switchLayouts:(UIButton *)sender {
    
    UIView *layoutView;
    if (self.childViewControllers.firstObject == self.flowController) {
                
        [self.flowController removeFromParentViewController];
        [self.flowController.view removeFromSuperview];
        
        [self addChildViewController: self.carouselController];
        layoutView = self.carouselController.view;
    } else {
        
        [self.carouselController removeFromParentViewController];
        [self.carouselController.view removeFromSuperview];
        
        [self addChildViewController: self.flowController];
        layoutView = self.flowController.view;
    }
    
    if (layoutView.superview != self.view) {
        
        [layoutView setFrame: self.view.bounds];
        [self.view addSubview: layoutView];
        [self.view sendSubviewToBack: layoutView];
    }
}


- (IBAction)toggleEditMode:(UIButton *)sender {
    
    // perhaps, will be better not to use data source instance from here
    if (self.childViewControllers.firstObject == self.flowController) {
        
        [self.flowController.collectionViewDataSource setEditMode: !self.flowController.collectionViewDataSource.editMode];
        
        [self.flowController.collectionView reloadData];
    } else {
        
        [self.carouselController.collectionViewDataSource setEditMode: !self.carouselController.collectionViewDataSource.editMode];
        [self.carouselController.collectionView reloadData];
    }
}

- (IBAction)showProgress:(id)sender {
    
    // the value is only for demonstrations purpose
    
    if (test == 0) {
        
        test = 0.3f;
    } else {
        
        test += 0.7f;
    }

    //TODO: use model and KVO instead of notifications
    NSInteger centeredItem = self.flowController.collectionViewDelegate.currentOffset;
    NSDictionary *userInfo =  @{ kDownloadingItemIndex : @(centeredItem),
                                 kProgressBarValue : @(test)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"testNotificationProgress"
                                                        object: self
                                                      userInfo: userInfo];
    
    if (test >= 1.0f) {
        
        test = 0.0f;
    }
}




@end
