//
//  CECarouselViewController.m
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 7/21/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import "CECarouselViewController.h"
#import "CECarouselLayout.h"
#import "CECarouselFooterView.h"
#import "CECarouselItemView.h"
#import "CECarouselAnimations.h"


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
    
    [self.collectionView registerClass: [CECarouselItemView class]
            forCellWithReuseIdentifier: kCarouselItemIdentifier];
    
//    [self.collectionView registerClass: [CECarouselFooterView class]
//            forSupplementaryViewOfKind: kCarouselLayoutSupplementaryKind
//                   withReuseIdentifier: kCarouselSupplementaryItemIdentifier];
    
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
        collectionViewDelegate.delegate = self;
    }
    
    return collectionViewDelegate;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    
    [self.carouselLayout setupForOrientation: toInterfaceOrientation];
}


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
