//
//  DetailViewController.h
//  HTML
//
//  Created by Ben Cootner on 4/25/14.
//  Copyright (c) 2014 Ben Cootner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
