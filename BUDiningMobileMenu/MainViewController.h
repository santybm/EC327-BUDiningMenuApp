//
//  MainViewController.h
//  BUDiningMobileMenu
//
//  Created by Santiago Beltran on 4/25/14.
//  Copyright (c) 2014 DevXApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *locationTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *warrenTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *bayStateTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *WestTab;
@end
