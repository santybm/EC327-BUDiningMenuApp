//
//  NutritionViewController.m
//  BUDiningMobileMenu
//
//  Created by Ben Cootner on 4/26/14.
//  Copyright (c) 2014 DevXApp. All rights reserved.
//

#import "NutritionViewController.h"
#import "MainViewController.h"

@interface NutritionViewController ()

@end

@implementation NutritionViewController

@synthesize num;
@synthesize nutritionImg;

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
    
    NSString *urlString = [NSString stringWithString:nutritionImg[num]];
    
    NutritionImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]]];
    
    
    //Close Modal Controller
    [[NSNotificationCenter defaultCenter] addObserverForName: UIApplicationDidEnterBackgroundNotification object: nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}
- (IBAction)backButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
