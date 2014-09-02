//
//  CEMainViewController_Phone.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 8/7/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CEMainViewController_Phone.h"

#import "CECollectionViewController.h"
#import "CECollectionViewDataSource.h"
#import "CEGridLayout.h"
#import "CEGridIssueCell.h"


@interface CEMainViewController_Phone ()

@property (nonatomic, strong) CECollectionViewController *gridViewController;

@end

@implementation CEMainViewController_Phone

@synthesize gridViewController = _gridViewController;

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
    
    [self addChildViewController: self.gridViewController];
}

- (void)viewDidLayoutSubviews {
 
    [super viewDidLayoutSubviews];
    
    BOOL isLandsape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
    [self.toolbar setFrame: CGRectMake( 0.0f, 0.0f, isLandsape ? self.view.frame.size.height : self.view.frame.size.width, 54.0f)];
    [self.toolbar setAutoresizingMask: UIViewAutoresizingFlexibleWidth];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
#pragma nark - Properties

- (CECollectionViewController *) gridViewController {
    
    if (_gridViewController == nil) {
        
        _gridViewController = [[CECollectionViewController alloc] initWithCollectionViewLayout: [CEGridLayout new]];
        [_gridViewController.view setFrame: self.view.frame];
        
        [self.view addSubview: _gridViewController.view];
        [self.view sendSubviewToBack: _gridViewController.view];
    }
    
    return _gridViewController;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma nark - IBActions

- (void) showProgress {
    
    if ([self.gridViewController.collectionView indexPathsForVisibleItems].count > 0) {
        
        NSIndexPath *firstVisibleItemPath = [self.gridViewController.collectionView indexPathsForVisibleItems].lastObject;
        
        //TODO: use model and KVO instead of notifications
        NSDictionary *userInfo =  @{ kDownloadingItemIndex : @(firstVisibleItemPath.section),
                                     kProgressBarValue : @(1.0f)};
        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"testNotificationProgress"
                                                            object: self
                                                          userInfo: userInfo];
    }
}

- (void) toggleEditMode {
    
    for (CEGridIssueCell *issueCell in self.gridViewController.collectionView.visibleCells) {
        
        [issueCell setEditMode: !issueCell.editMode];
        [issueCell setNeedsLayout];
        [issueCell layoutIfNeeded];
    }
}

@end
