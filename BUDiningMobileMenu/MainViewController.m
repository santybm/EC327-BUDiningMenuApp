//
//  MainViewController.m
//  BUDiningMobileMenu
//
//  Created by Santiago Beltran on 4/25/14.
//  Copyright (c) 2014 DevXApp. All rights reserved.
//

#import "MainViewController.h"
#import "itemNameCellTableViewCell.h"
#import "NutritionViewController.h"
#import "HallImageTableViewCell.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize locationTabBar;

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

    meal = [[NSMutableArray alloc] init];
    names = [[NSMutableArray alloc] init];
    category = [[NSMutableArray alloc] init];
    sar = [[NSMutableArray alloc] init];
    vegetar = [[NSMutableArray alloc] init];
    vegs = [[NSMutableArray alloc] init];
    facts = [[NSMutableArray alloc] init];
    
    [self parseXMLFileAtURL:@"http://sbeltran.com/diningXML.xml"];

    // Do any additional setup after loading the view.
    NSLog(@"%@", locationTabBar);
    
    
    //Set the default TabBar item
    [self.locationTabBar setSelectedItem:self.warrenTab];
    [self.locationTabBar setSelectedImageTintColor:[UIColor colorWithRed:204.0/255 green:0 blue:0 alpha:1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- TabBar Delegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    tabBar.selectedImageTintColor = [UIColor colorWithRed:204.0/255 green:0 blue:0 alpha:1];
    NSInteger index = [tabBar.items indexOfObject:item];
    
    currectSelection = index;
    NSLog(@"%d", index);
}



//start parsing
- (void) parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"File found and [arsgin started");
}

- (void)parseXMLFileAtURL:(NSString *)URL
{
    NSString *agentString = @ "Mozilla/5.0 (Macintosh); U; Intel Mac OS X 10_5_6;en-us) AppleWebkit/525.27.1 (KHTML, like Gecko) Version/3.2.1 Safari/525.27.1";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    
                                    [NSURL URLWithString:URL]];
    
    [request setValue:agentString forHTTPHeaderField:@"User-Agent"];
    xmlFile = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
    
    
    articles = [[NSMutableArray alloc] init];
    errorParsing=NO;
    
    rssParser = [[NSXMLParser alloc] initWithData:xmlFile];
    [rssParser setDelegate:self];
    
    //Following may need changing
    
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
    
    [rssParser parse];
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    
    NSString *errorString = [NSString stringWithFormat:@"Error Code %i", [parseError code]];
    NSLog(@"Error parsing XML: %@", errorString);
    
    
    errorParsing=YES;
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    currentElement = [elementName copy];
    ElementValue = [[NSMutableString alloc] init];
    if ([elementName isEqualToString:@"name"]) {
        item = [[NSMutableDictionary alloc] init];
        [names addObject: ElementValue];
        
    }
    if ([elementName isEqualToString:@"isVegetarian"]) {
        item = [[NSMutableDictionary alloc] init];
        [vegs addObject: ElementValue];
        
    }
    if ([elementName isEqualToString:@"meal"]) {
        item = [[NSMutableDictionary alloc] init];
        [meal addObject: ElementValue];
        
    }

    if ([elementName isEqualToString:@"category"]) {
        item = [[NSMutableDictionary alloc] init];
        [category addObject: ElementValue];
        
    }

    if ([elementName isEqualToString:@"isSargent"]) {
        item = [[NSMutableDictionary alloc] init];
        [sar addObject: ElementValue];
        
    }

    if ([elementName isEqualToString:@"isVegetarian"]) {
        item = [[NSMutableDictionary alloc] init];
        [vegetar addObject: ElementValue];
        
    }

    if ([elementName isEqualToString:@"factsURL"]) {
        item = [[NSMutableDictionary alloc] init];
        [facts addObject: ElementValue];
        
    }

    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [ElementValue appendString:string];
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"item"]) {
        [articles addObject:[item copy]];
    } else {
        [item setObject:ElementValue forKey:elementName];
    }
    
}
- (void)goThroughArray{
    //  NSLog(@"2");
    for(int i=0; i<names.count;i++)
    {
        NSLog(@"%@", [meal objectAtIndex:i] );
        NSLog(@"%@", [names objectAtIndex:i] );
        NSLog(@"%@", [category objectAtIndex:i] );
        NSLog(@"%@", [sar objectAtIndex:i] );
        NSLog(@"%@", [vegetar objectAtIndex:i] );
        NSLog(@"%@", [vegs objectAtIndex:i] );
        NSLog(@"%@", [facts objectAtIndex:i] );
     
        
    }
}



- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self goThroughArray];
    if (errorParsing == NO)
    {
        NSLog(@"XML processing done!");
        // NSLog(@"%@",articles);
    } else {
        NSLog(@"Error occurred during XML processing");
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [names count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item) {
        case 0:
            return 85;
        case 1:
            return 46;
            break;
        default:
            break;
    }
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *hallImageTableIdentifer = @"TableDiningImage";
    static NSString *simpleTableIdentifier = @"itemNameCell";
    static NSString *categoryTableIdentifer = @"categoryMenu";
    
    NSString *identityString = @"";
    
    switch (indexPath.item) {
        case 0: {
            identityString = hallImageTableIdentifer;
            HallImageTableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:hallImageTableIdentifer];
            if (cell0 == nil) {
                cell0 = [[HallImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hallImageTableIdentifer];
            }
            if (currectSelection == 0)
                ((HallImageTableViewCell *)cell0).DHallImage.image = [UIImage imageNamed:@"warren_inAction.jpg"];
            else if (currectSelection == 1)
                ((HallImageTableViewCell *)cell0).DHallImage.image = [UIImage imageNamed:@"west_inAction.jpg"];
            else if (currectSelection == 2)
                ((HallImageTableViewCell *)cell0).DHallImage.image = [UIImage imageNamed:@"baystate_inAction.jpg"];
            return cell0;
            break;
        }
        case 1: {
            identityString = categoryTableIdentifer;
            //break;
        }
        case 2: {
            identityString = simpleTableIdentifier;
            //break;
        }
            
        default:
            break;
    }
    //adsfdsfas
    
    itemNameCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[itemNameCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    ((itemNameCellTableViewCell *)cell).itemNameLabel.text = [names objectAtIndex:indexPath.row];
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    foodIndex=indexPath.row;
    [self performSegueWithIdentifier:@"MySegue" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MySegue"])
    {
        NutritionViewController *c = [segue destinationViewController];
        c.num=(int)foodIndex;
        c.nutritionImg=facts;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  //  return 68;
//}



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
