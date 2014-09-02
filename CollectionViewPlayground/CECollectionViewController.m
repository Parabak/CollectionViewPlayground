//
//  CEViewController.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/9/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECollectionViewController.h"
#import "CECollectionViewDataSource.h"
#import "CEGridViewDelegate.h"
#import "CECarouselAnimations.h"


@interface CECollectionViewController ()

@end

@implementation CECollectionViewController

@synthesize collectionViewDataSource;
@synthesize collectionViewDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.collectionView.backgroundColor = [UIColor colorWithWhite: 0.25f alpha: 1.0f];
    
    [self.collectionView setDataSource: self.collectionViewDataSource];
    [self.collectionView setDelegate: self.collectionViewDelegate];
    
    [self.collectionView registerClass: [CEGridIssueCell class]
            forCellWithReuseIdentifier: kIssueGridCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Properties

- (CEGridViewDelegate *) collectionViewDelegate {
    
    if (collectionViewDelegate == nil) {
        
        collectionViewDelegate = [CEGridViewDelegate new];
        [collectionViewDelegate setDelegate: self];
    }
    
    return collectionViewDelegate;
}

- (CECollectionViewDataSource *) collectionViewDataSource {
    
    if (collectionViewDataSource == nil) {
        
        collectionViewDataSource = [CECollectionViewDataSource new];
    }
    
    return collectionViewDataSource;
}

#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {

        self.gridLayout.numberOfColumns = 3;
        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
        45.0f : 25.0f;
        
        self.gridLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
    } else {
        self.gridLayout.numberOfColumns = 2;
        self.gridLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}

- (CEGridLayout *)gridLayout {
    
    return (CEGridLayout*) self.collectionView.collectionViewLayout;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - CECollectionViewSelectionDelegate

- (void)itemSelectedAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat timing = kBounceAnimationDuration - 0.15f; // we will not waiting the completion of animation
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timing * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIViewController *issuePresentationController = [[UIViewController alloc] init];
        [issuePresentationController.view setFrame: self.view.frame];
        [issuePresentationController.view setBackgroundColor: [UIColor whiteColor]];
        
        [issuePresentationController setModalPresentationStyle: UIModalPresentationCurrentContext];
        [issuePresentationController setModalTransitionStyle: UIModalTransitionStyleCrossDissolve];
        
        [self presentViewController: issuePresentationController animated: YES completion:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated: YES completion: nil];
            });
        }];
    });
}


@end
