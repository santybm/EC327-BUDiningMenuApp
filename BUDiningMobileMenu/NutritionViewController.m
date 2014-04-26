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
    NSLog(@"%d",num);
    NutritionImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.wallpaperfunda.com/wp-content/uploads/2014/03/images-2-660x330.jpg"]]];
    [super viewDidLoad];
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
