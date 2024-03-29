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
#import "categoryTitleTableViewCell.h"

@interface MainViewController ()



@end

@implementation MainViewController {
    CLLocationManager *locationManager;
}
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
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    meal = [[NSMutableArray alloc] init];
    names = [[NSMutableArray alloc] init];
    category = [[NSMutableArray alloc] init];
    sar = [[NSMutableArray alloc] init];
    vegetar = [[NSMutableArray alloc] init];
    vegs = [[NSMutableArray alloc] init];
    facts = [[NSMutableArray alloc] init];
    gluten = [[NSMutableArray alloc] init];
    
    [self setupArrays];
    
    //Location Stuff
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.mainTableView addSubview:refreshControl];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object: nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
       
        [names removeAllObjects];
        [meal removeAllObjects];
        [category removeAllObjects];
        [sar removeAllObjects];
        [vegetar removeAllObjects];
        [vegs removeAllObjects];
        [facts removeAllObjects];
        stopGPSLoop = 0;
        initialLoad = 999;
    }];
    
    //Ensure app refreshed on DidBecomeActive
    [[NSNotificationCenter defaultCenter] addObserverForName: UIApplicationDidBecomeActiveNotification object: nil queue: [NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        if (initialLoad == 999)
        {
            [self setupArrays];
            [self Time];
            [self makeStations];
            [self.mainTableView reloadData];
        }
        //NSLog(@"%@", @"Did become active");
        
    }];
    
    
}
- (void)refresh:(UIRefreshControl *)refreshControl {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self makeStations];
    [refreshControl endRefreshing];
    [self.mainTableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError: %@", error);
    //UIAlertView *errorAlert = [[UIAlertView alloc]
    //                           initWithTitle:@"Error" message:@"Failed to Get Your Location. Default Dining Hall selected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[errorAlert show];
    
    [self Time];
    [self makeStations];
    [self.mainTableView reloadData];
    [self.locationTabBar setSelectedItem:self.warrenTab];
    [self.locationTabBar setSelectedImageTintColor:[UIColor colorWithRed:204.0/255 green:0 blue:0 alpha:1]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (stopGPSLoop == 1)
    {
        return;
    }
    stopGPSLoop = 1;
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
    
    
        //Get the closes Dining Hall
        CLLocation *bayState = [[CLLocation alloc] initWithLatitude:42.349779 longitude:-71.097733];
        CLLocation *warren = [[CLLocation alloc] initWithLatitude:42.349462 longitude:-71.103977];
        CLLocation *west = [[CLLocation alloc] initWithLatitude:42.352748 longitude:-71.120274];
        
        //Find Closest Dining Hall
            CLLocationDistance metersToBay1 = [bayState distanceFromLocation:currentLocation];
            CLLocationDistance metersToBay2 = [currentLocation distanceFromLocation:bayState];
        CLLocationDistance metersToBay = metersToBay1 / 2 + metersToBay2 / 2;
            CLLocationDistance metersToWarren1 = [warren distanceFromLocation:currentLocation];
            CLLocationDistance metersToWarren2 = [warren distanceFromLocation:currentLocation];
        CLLocationDistance metersToWarren = metersToWarren1 / 2 + metersToWarren2 / 2;
            CLLocationDistance metersToWest1 = [west distanceFromLocation:currentLocation];
            CLLocationDistance metersToWest2 = [west distanceFromLocation:currentLocation];
        CLLocationDistance metersToWest = metersToWest1 / 2 + metersToWest2 / 2;

        CLLocationDistance minLoc;
        
        minLoc = MIN(metersToBay, metersToWarren);
        minLoc = MIN(minLoc, metersToWest);
        
        if (minLoc == metersToBay) {
            currectSelection = 1;
            [self callTabChange];
        }
        else if (minLoc == metersToWarren){
            currectSelection = 0;
            [self callTabChange];
            
        }
        else if (minLoc == metersToWest){
            currectSelection = 2;
            [self callTabChange];
        }
        else{
            currectSelection = 0;
            [self callTabChange];
            
        }
        [locationManager stopUpdatingLocation];
    }
    
    [locationManager stopUpdatingLocation];
    
    
}

#pragma mark- TabBar Delegate

-(void) clearArrays
{
     [names removeAllObjects];
     [meal removeAllObjects];
     [category removeAllObjects];
     [sar removeAllObjects];
     [vegetar removeAllObjects];
     [vegs removeAllObjects];
     [gluten removeAllObjects];
     [facts removeAllObjects];
     [self setupArrays];
}


- (IBAction)userChangedSelectedMeal:(id)sender {
    if(self.mealSelector.selectedSegmentIndex == 0){
        
        NSLog(@"%@", @"Breakfast");
        [self makeStations];
        [self.mainTableView reloadData];
    }
    if (self.mealSelector.selectedSegmentIndex == 1){
        NSLog(@"%@", @"Lunch");
        [self makeStations];
        [self.mainTableView reloadData];
    }
    if (self.mealSelector.selectedSegmentIndex == 2){
        NSLog(@"%@", @"Dinner");
        [self makeStations];
        [self.mainTableView reloadData];
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //tabBar.selectedImageTintColor = [UIColor colorWithRed:204.0/255 green:0 blue:0 alpha:1];

    
    index = [tabBar.items indexOfObject:item];
    
    
    currectSelection = index;
    
    //abcd
    
    //NSLog(@"%ld", (long)currectSelection);
    [self callTabChange];
}

-(void)callTabChange {

    HallImageTableViewCell *cell0 = [self.mainTableView dequeueReusableCellWithIdentifier:@"TableDiningImage"];
    if (currectSelection == 0)
    {
        [self clearArrays];
        [self parseXMLFileAtURL:@"http://sbeltran.com/diningXML.xml"];
        //[self Time];
        [self makeStations];

        ((HallImageTableViewCell *)cell0).DHallImage.image = [UIImage imageNamed:@"warren_inAction.jpg"];
        ((HallImageTableViewCell *)cell0).diningHallName.text = @"Warren Towers Dining Hall";
        
        [self.locationTabBar setSelectedItem:self.warrenTab];
        [self.locationTabBar setSelectedImageTintColor:[UIColor colorWithRed:204.0/255 green:0 blue:0 alpha:1]];
        [self.mainTableView reloadData];
        return;
    }
    else if (currectSelection== 1)
    {
        [self clearArrays];
        [self parseXMLFileAtURL:@"http://sbeltran.com/diningXML2.xml"];
        //[self Time];
        [self makeStations];

        ((HallImageTableViewCell *)cell0).DHallImage.image = [UIImage imageNamed:@"baystate_inAction.jpg"];
        ((HallImageTableViewCell *)cell0).diningHallName.text = @"Marciano Commons";
        [self.locationTabBar setSelectedItem:self.bayStateTab];
        [self.locationTabBar setSelectedImageTintColor:[UIColor colorWithRed:204.0/255 green:0 blue:0 alpha:1]];
        [self.mainTableView reloadData];
        return;
    }
    else
    {
        [self clearArrays];
        [self parseXMLFileAtURL:@"http://sbeltran.com/diningXML3.xml"];
        //[self Time];
        [self makeStations];
        //[self clearArrays];
        ((HallImageTableViewCell *)cell0).DHallImage.image = [UIImage imageNamed:@"west_inAction.jpg"];
        ((HallImageTableViewCell *)cell0).diningHallName.text = @"West Campus Dining Hall";
        [self.locationTabBar setSelectedItem:self.WestTab];
        [self.locationTabBar setSelectedImageTintColor:[UIColor colorWithRed:204.0/255 green:0 blue:0 alpha:1]];
        [self.mainTableView reloadData];
        return;
    }

    
    
    
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
    if ([elementName isEqualToString:@"isVegan"]) {
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
    if ([elementName isEqualToString:@"isGluten"]) {
        item = [[NSMutableDictionary alloc] init];
        [gluten addObject: ElementValue];
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
          NSLog(@"%@", [gluten objectAtIndex:i] );
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
    return names.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.item==0)
        return 85;
    if([names objectAtIndex:(indexPath.item)]==[category objectAtIndex:(indexPath.item)])
       return 24;
    return 67;
//
//    
//    switch (indexPath.item) {
//        case 0:
//            return 85;
//        case 1:
//            return 46;
//            break;
//        default:
//            break;
//    }
//    return 67;
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
            {
                ((HallImageTableViewCell *)cell0).DHallImage.image = [UIImage imageNamed:@"warren_inAction.jpg"];
                ((HallImageTableViewCell *)cell0).diningHallName.text = @"Warren Towers Dining Hall";
            }
            else if (currectSelection == 1)
            {
                ((HallImageTableViewCell *)cell0).DHallImage.image = [UIImage imageNamed:@"baystate_inAction.jpg"];
                ((HallImageTableViewCell *)cell0).diningHallName.text = @"Marciano Commons";
            }
            else if (currectSelection == 2)
            {
                ((HallImageTableViewCell *)cell0).DHallImage.image = [UIImage imageNamed:@"west_inAction.jpg"];
                ((HallImageTableViewCell *)cell0).diningHallName.text = @"West Campus Dining Hall";
            }
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
    
    cell.image1.image = nil;
    cell.image2.image = nil;
    cell.image3.image = nil;
    
      if (cell == nil) {
        cell = [[itemNameCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if([names objectAtIndex:(indexPath.row)]==[category objectAtIndex:(indexPath.row)])
    {
    cell = [tableView dequeueReusableCellWithIdentifier:categoryTableIdentifer];
    
    if (cell == nil) {
        cell = [[itemNameCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryTableIdentifer];
    }
    }
    
    
   //ADD ITEM NAME TO MENU
      if([names objectAtIndex:(indexPath.row)]==[category objectAtIndex:(indexPath.row)])
      {
          ((categoryTitleTableViewCell *)cell).catTitle.text = [names objectAtIndex:(indexPath.row)];
      }
    else
      ((itemNameCellTableViewCell *)cell).itemNameLabel.text = [names objectAtIndex:(indexPath.row)];
   
   //Vegitarian
    NSString* v1= vegetar[indexPath.item];
    NSData* v1D = [v1 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *output = [[NSString alloc]  initWithData:v1D encoding: NSASCIIStringEncoding];
    output = [output stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([output isEqualToString: @"TRUE"])
    {
        cell.image1.image = [UIImage imageNamed:@"vegitarian.png"];
        //((itemNameCellTableViewCell *)cell).image1.image = [UIImage imageNamed:@"vegitarian.png"];
    }
    
    //Vegan
    NSString* v2= vegs[indexPath.item];
    NSData* v2D = [v2 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *outputveg = [[NSString alloc]  initWithData:v2D encoding: NSASCIIStringEncoding];
    outputveg = [outputveg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([outputveg isEqualToString:@"TRUE"])
    {
            cell.image1.image = [UIImage imageNamed:@"vegan.png"];
            //((itemNameCellTableViewCell *)cell).image1.image = [UIImage imageNamed:@"vegan.png"];
    }
   
    
    //Sargent
    NSString* s= sar[indexPath.item] ;
    NSData* sd = [s dataUsingEncoding:NSUTF8StringEncoding];
    NSString *outputsar = [[NSString alloc]  initWithData:sd encoding: NSASCIIStringEncoding];
    outputsar = [outputsar stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([outputsar isEqualToString: @"TRUE"])
    {
        cell.image2.image = [UIImage imageNamed:@"sargent.png"];
        //((itemNameCellTableViewCell *)cell).image2.image = [UIImage imageNamed:@"sargent.png"];
    
    }
    
    //gluten
    NSString* g= gluten[indexPath.item] ;
    NSData* gd = [g dataUsingEncoding:NSUTF8StringEncoding];
    NSString *outputgluten = [[NSString alloc]  initWithData:gd encoding: NSASCIIStringEncoding];
    outputgluten = [outputgluten stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([outputgluten isEqualToString: @"TRUE"])
    {
        cell.image3.image = [UIImage imageNamed:@"glutenFree.png"];
        //((itemNameCellTableViewCell *)cell).image2.image = [UIImage imageNamed:@"sargent.png"];
        
    }
    return cell;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    foodIndex=(indexPath.row);
    [self performSegueWithIdentifier:@"MySegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void) setupArrays
{
    meal[0] = @"error";
    names[0] =@"error";;
    category[0] =@"error";
    sar [0] = @"error";;
    vegetar [0] = @"error";
    vegs [0] = @"error";
    gluten [0] = @"error";
    facts [0] = @"error";
}

- (void) checkMealType
{
    [self clearArrays];
    switch (index) {
        case 0:
            [self parseXMLFileAtURL:@"http://sbeltran.com/diningXML.xml"];
            [self.mainTableView reloadData];
            break;
        case 1:
            [self parseXMLFileAtURL:@"http://sbeltran.com/diningXML2.xml"];
            [self.mainTableView reloadData];
            break;
        default:
            [self parseXMLFileAtURL:@"http://sbeltran.com/diningXML3.xml"];
            [self.mainTableView reloadData];
            break;
    }
    [self.mainTableView reloadData];
    int topMealselector = self.mealSelector.selectedSegmentIndex;
    
    for(int i=1;i<names.count;i++)
    {
       
        NSString* type= meal[i] ;
        NSData* typeAsData = [type dataUsingEncoding:NSUTF8StringEncoding];
        NSString *typeOutput = [[NSString alloc]  initWithData:typeAsData encoding: NSASCIIStringEncoding];
        typeOutput = [typeOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        
        
        if(topMealselector==0 && ![typeOutput isEqualToString:@"Breakfast"])
        {
            
            [category removeObjectAtIndex:(i)];
            [names removeObjectAtIndex:(i)];
            [meal removeObjectAtIndex:(i)];
            [vegetar removeObjectAtIndex:(i)];
            [vegs removeObjectAtIndex:(i)];
            [gluten removeObjectAtIndex:(i)];
            [sar removeObjectAtIndex:(i)];
            [facts removeObjectAtIndex:(i)];
            i=0;
            [self.mainTableView reloadData];
            
            
        }
        
       
        
        if(topMealselector==1 && ![typeOutput isEqualToString:@"Lunch"])
        {
            
            [category removeObjectAtIndex:(i)];
            [names removeObjectAtIndex:(i)];
            [meal removeObjectAtIndex:(i)];
            [vegetar removeObjectAtIndex:(i)];
            [vegs removeObjectAtIndex:(i)];
            [gluten removeObjectAtIndex:(i)];
            [sar removeObjectAtIndex:(i)];
            [facts removeObjectAtIndex:(i)];
            i=0;
            [self.mainTableView reloadData];
            
            
        }
        
        if(topMealselector==2 && ![typeOutput isEqualToString:@"Dinner"])
        {
            
            [category removeObjectAtIndex:(i)];
            [names removeObjectAtIndex:(i)];
            [meal removeObjectAtIndex:(i)];
            [vegetar removeObjectAtIndex:(i)];
            [vegs removeObjectAtIndex:(i)];
            [gluten removeObjectAtIndex:(i)];
            [sar removeObjectAtIndex:(i)];
            [facts removeObjectAtIndex:(i)];
            i=0;
            [self.mainTableView reloadData];
            
            
        }
        [self.mainTableView reloadData];
        
    }
    
    if(topMealselector==0 && names.count<2)
    {
        
        [category insertObject:@"Notice:" atIndex:(1)];
        [names insertObject:@"No Breakfast Today" atIndex:(1)];
        [meal insertObject:@"error" atIndex:(1)];
        [vegetar insertObject:@"error" atIndex:(1)];
        [vegs insertObject:@"error" atIndex:(1)];
        [gluten insertObject:@"error" atIndex:(1)];
        [sar insertObject:@"error" atIndex:(1)];
        [facts insertObject:@"error" atIndex:(1)];
        [self.mainTableView reloadData];
        
    }
    
    if(topMealselector==1 && names.count<2)
    {
        
        [category insertObject:@"Notice:" atIndex:(1)];
        [names insertObject:@"No Lunch Today" atIndex:(1)];
        [meal insertObject:@"error" atIndex:(1)];
        [vegetar insertObject:@"error" atIndex:(1)];
        [vegs insertObject:@"error" atIndex:(1)];
        [gluten insertObject:@"error" atIndex:(1)];
        [sar insertObject:@"error" atIndex:(1)];
        [facts insertObject:@"error" atIndex:(1)];
        [self.mainTableView reloadData];
        
    }
    
    if(topMealselector==2 && names.count<2)
    {
        
        [category insertObject:@"Notice:" atIndex:(1)];
        [names insertObject:@"No Dinner Today" atIndex:(1)];
        [meal insertObject:@"error" atIndex:(1)];
        [vegetar insertObject:@"error" atIndex:(1)];
        [vegs insertObject:@"error" atIndex:(1)];
        [gluten insertObject:@"error" atIndex:(1)];
        [sar insertObject:@"error" atIndex:(1)];
        [facts insertObject:@"error" atIndex:(1)];
        [self.mainTableView reloadData];
        
    }

    
    
    
}


- (void) makeStations
{
    [self checkMealType];
    prev = @"asfa";
     for(int i=1;i<names.count;i++)
    {
        NSString* cat= category[i] ;
        NSData* catAsData = [cat dataUsingEncoding:NSUTF8StringEncoding];
        NSString *output = [[NSString alloc]  initWithData:catAsData encoding: NSASCIIStringEncoding];
        output = [output stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![output isEqualToString: prev])
    {
        prev=output;
        [category insertObject:output atIndex:(i)];
        [meal insertObject:@"error" atIndex:(i)];
        [names insertObject:output atIndex:(i)];
        [sar insertObject:@"error" atIndex:(i)];
        [vegetar insertObject:@"error" atIndex:(i)];
        [vegs insertObject:@"error" atIndex:(i)];
        [gluten insertObject:@"error" atIndex:(i)];
        [facts insertObject:@"error" atIndex:(i)];
    }
    
    }

    
    
}


-(void) Time{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    NSInteger currentHour = [components hour];
  //  NSInteger currentMinute = [components minute];
    //Set the default meal in SegmentedController
    if(currentHour>7 && currentHour<11)
        [self.mealSelector setSelectedSegmentIndex:0];
    if(currentHour>=11 && currentHour<17)
        [self.mealSelector setSelectedSegmentIndex:1];
    if (currentHour>=17) {
        [self.mealSelector setSelectedSegmentIndex:2];
    
    [self.mainTableView reloadData];
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
