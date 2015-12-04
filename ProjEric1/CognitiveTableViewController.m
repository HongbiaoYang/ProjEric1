//
//  CognitiveTableViewController.m
//  ProjEric1
//
//  Created by hongbiao yang on 8/15/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "CognitiveTableViewController.h"
#import "XMLListParser.h"
#import "TTSItemStruct.h"
#import "CognitiveItemTableViewCell.h"
#import "ResourceCenter.h"
#import "MoreMenuTableViewController.h"
#import "DBManager.h"
#import "EmergencyTableViewController.h"


@interface CognitiveTableViewController () {
    ResourceCenter *sharedCenter;
}

@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;


@end

@implementation CognitiveTableViewController

- (IBAction)YesClicker:(id)sender {
    [sharedCenter SpeakOut:@"Yes"];
}

- (IBAction)NoClicker:(id)sender {
    [sharedCenter SpeakOut:@"No"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   /* NSArray *paths = [[NSArray alloc] initWithObjects:[[NSBundle mainBundle] pathForResource:@"xml/gettingonoff" ofType:@"xml"],
                    [[NSBundle mainBundle] pathForResource:@"xml/ridingbus" ofType:@"xml"],
                    [[NSBundle mainBundle] pathForResource:@"xml/safety" ofType:@"xml"],
                    [[NSBundle mainBundle] pathForResource:@"xml/emergency" ofType:@"xml"], nil];

    NSArray *elements = [[NSArray alloc] initWithObjects:@"Title",@"Text",
                                                      @"Titulo",@"Texto",@"Image",@"ImageV",nil];


    XMLListParser *xmlParser = [[XMLListParser alloc]init];
    [self setItems:[xmlParser loadMultiXML:paths withElements:elements]];*/

    sharedCenter = [ResourceCenter sharedResource];

    // get database manager
    self.dbManager = [sharedCenter dbManager];

    NSString *table = [[NSString alloc] initWithFormat:@"%@Table", [self transit]];
    NSLog(@"transit in cognitive=%@ table=%@", [self transit], table);

    // cognitive list include everything except response
    NSString *query = [[NSString alloc] initWithFormat:
            @"select * from %@ where menu != 'response' order by cognitive desc", table];

    NSLog(@"query in cognitive=%@", query);
    // obtain and flatten the list
    NSMutableArray *customArray = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSMutableArray *customArrayItems = [self.dbManager convertValueToItem:customArray];
    self.items = customArrayItems;

    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:252.0 green:218.0 blue:75.0 alpha:1.0f]];
    [self.navigationController.navigationBar setTranslucent:NO];


    CGFloat width = [ResourceCenter screenSize].width / 3;
    self.YesItem.width = width;
    self.NoItem.width = width;
    self.MoreItem.width = width;


    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 100.0f;
    [self.view addGestureRecognizer:self.lpgr];


    // add right up corner icons: setting and emergency
    UIImage *imgEmergency = [UIImage imageNamed:@"emergency_ico"];
    UIButton *btnEmergency = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEmergency.bounds = CGRectMake(0, 0, imgEmergency.size.width, imgEmergency.size.height);
    [btnEmergency setImage:imgEmergency forState:UIControlStateNormal];
    UIBarButtonItem *iconEmergency = [[UIBarButtonItem alloc] initWithCustomView:btnEmergency];
    [btnEmergency addTarget:self action:@selector(emergencyPage:) forControlEvents:UIControlEventTouchUpInside];



    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: iconEmergency, [sharedCenter iconSound], nil]];
}

-(void) emergencyPage:(id)sender {
    [sharedCenter SpeakOut:@"emergency"];

    EmergencyTableViewController *eViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"emergency"];
    eViewController.from = @"cognitive";
    [self.navigationController pushViewController:eViewController animated:YES];
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:self.lpgr]) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            CGPoint lpLocation = [sender locationInView:self.tableView];
            NSIndexPath  *lpIndexPath = [self.tableView indexPathForRowAtPoint:lpLocation];
//            UITableViewCell *lpCell = [self.tableView cellForRowAtIndexPath:lpIndexPath];
            long row = [lpIndexPath row];
            TTSItemStruct *sItem = self.items[row];

            [sharedCenter SpeakOut:sItem.text];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [ResourceCenter screenSize] .height / 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    [sharedCenter SpeakOut:@"Please hold this button to make a selection"];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"CognitiveItemCell";
    CognitiveItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    long row = [indexPath row];

    TTSItemStruct *tItem = self.items[row];
    NSLog(@"row=%ld text=%@ img=%@ item=%@ count=%ld", row, tItem.text, tItem.image, tItem.title, self.items.count);

    cell.itemLabel.text = [tItem title];

    NSString *imageName = [NSString stringWithFormat:@"sym/%@", [tItem image]];
    cell.itemImage.image = [UIImage imageNamed:imageName];

    // blackground color of each cell
    //UIColor *blueBack = [UIColor colorWithRed: 64.0/255.0f green:147.0/255.0f blue:223.0/255.0f alpha:1.0];
    UIColor *bgColor = [ResourceCenter colorFromHexString:[tItem color]];

    cell.itemLabel.backgroundColor = bgColor;
    cell.itemLabel.textColor = [UIColor whiteColor];
    [cell.itemLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];

//    cell.itemImage.backgroundColor = [UIColor blueColor];

    return cell;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"cognitiveMore"]) {
        MoreMenuTableViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.from = [segue identifier];

    }

}


@end
