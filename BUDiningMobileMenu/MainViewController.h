//
//  MainViewController.h
//  BUDiningMobileMenu
//
//  Created by Santiago Beltran on 4/25/14.
//  Copyright (c) 2014 DevXApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface MainViewController : UIViewController <UITabBarDelegate>{
    
    DetailViewController *detailViewController;
    
    NSXMLParser *rssParser;
    NSMutableArray *articles;
    NSMutableDictionary *item;
    NSMutableArray *names;
    NSMutableArray *vegs;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
    NSData * xmlFile;

}
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

- (void)parseXMLFileAtURL:(NSString *)URL;

@property (weak, nonatomic) IBOutlet UITabBar *locationTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *warrenTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *bayStateTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *WestTab;
@end
