//
//  MainViewController.h
//  BUDiningMobileMenu
//
//  Created by Santiago Beltran on 4/25/14.
//  Copyright (c) 2014 DevXApp. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DetailViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController <UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>{
    
    //DetailViewController *detailViewController;
    
    NSXMLParser *rssParser;
    NSMutableArray *articles;
    NSMutableDictionary *item;
    
    NSMutableArray *meal;
    NSMutableArray *names;
    NSMutableArray *category;
    NSMutableArray *sar;
    NSMutableArray *vegetar;
    NSMutableArray *vegs;
    NSMutableArray *gluten;
    NSMutableArray *facts;

    
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
    NSData * xmlFile;
    
    NSString *prev;
    
    NSInteger foodIndex;
    NSInteger index;
    
    int stopGPSLoop;
    int initialLoad;
    NSInteger currectSelection;

}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mealSelector;

//@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

- (void)parseXMLFileAtURL:(NSString *)URL;

@property (weak, nonatomic) IBOutlet UITabBar *locationTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *warrenTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *bayStateTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *WestTab;

@end
