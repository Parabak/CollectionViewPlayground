//
//  CEMainViewController_Phone.h
//  CollectionViewPlayground
//
//  Created by Aleksandr Baranovski on 8/7/14.
//  Copyright (c) 2014 Сmok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEMainViewController_Phone : UIViewController

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction) showProgress;
- (IBAction) toggleEditMode;

@end
