//
//  ItemTableViewController.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 8/5/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "ItemTableViewController.h"
#import "TTSItemStruct.h"
#import "ItemTableViewCell.h"
#import "ResourceCenter.h"
#import "MoreMenuTableViewController.h"
#import "DBManager.h"

@interface ItemTableViewController () {
    ResourceCenter *sharedCenter;
}

@property (nonatomic,strong) UITapGestureRecognizer *dpGesture;
@property (nonatomic,strong) UITapGestureRecognizer *spGesture;



@end


@implementation ItemTableViewController

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

    sharedCenter = [ResourceCenter sharedResource];

    // get database manager
    self.dbManager = [sharedCenter dbManager];

    NSString *table = [[NSString alloc] initWithFormat:@"%@Table", [self transit]];

    NSString *query = [[NSString alloc] initWithFormat:
            @"select * from %@ where menu = '%@' order by %@ desc", table, [self category], [self subMenu]];

    NSLog(@"query in itemlist=%@", query);

    // obtain and flatten the list
    NSMutableArray *customArray = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSMutableArray *customArrayItems = [self.dbManager convertValueToItem:customArray];
    self.items = customArrayItems;

//    NSLog(@"item array in items:%@", customArray);

    // change background of page and navigation bar
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:252.0 green:218.0 blue:75.0 alpha:1.0f]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.title = [self fullTitle:[self subMenu] category:[self category] ];

    // width of the buttons in the bottom
    CGFloat width = [ResourceCenter screenSize].width / 3;
    self.YesItem.width = width;
    self.NoItem.width = width;
    self.MoreItem.width = width;

    // add double tap gesture
    self.dpGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.dpGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:self.dpGesture];

    // add single tap gesture
    self.spGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.spGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.spGesture];

    // single tap does not function inside double tap
    [self.spGesture requireGestureRecognizerToFail:self.dpGesture];


    // add right up corner icons: sound animation and home
    UIImage *imgHome = [UIImage imageNamed:@"home"];
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHome.bounds = CGRectMake(0, 0, imgHome.size.width, imgHome.size.height);
    [btnHome setImage:imgHome forState:UIControlStateNormal];
    UIBarButtonItem *iconHome = [[UIBarButtonItem alloc] initWithCustomView:btnHome];
    [btnHome addTarget:self action:@selector(goHomePage:) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: iconHome, [sharedCenter iconSound], nil]];
}

-(void) goHomePage:(id)sender {
    NSLog(@"goHomePage");
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // handling code

        CGPoint dpLocation = [sender locationInView:self.tableView];
        NSIndexPath  *dpIndexPath = [self.tableView indexPathForRowAtPoint:dpLocation];
        long row = [dpIndexPath row];

        // get the item clicked
        TTSItemStruct *sItem = self.items[row];

        int freq;

        if ([[self subMenu] isEqualToString:@"hearing"]) {
            sItem.hearing += 1;
            freq = sItem.hearing;
        } else if ([[self subMenu] isEqualToString:@"nonenglish"]) {
            sItem.nonenglish += 1;
            freq = sItem.nonenglish;
        } else if ([[self subMenu] isEqualToString:@"cognitive"]) {
            sItem.cognitive += 1;
            freq = sItem.cognitive;
        } else  {
            NSLog(@"something is wrong about the submenu:%@", [self subMenu]);
        }

        // database stuff: update the frequency value in database
        NSString *updateQuery = [[NSString alloc] initWithFormat:
        @"update %@Table set %@ = %d where title = '%@'", [self transit], [self subMenu], freq, sItem.title];

        NSLog(@"query in item update = %@", updateQuery);

        // Execute the query.
        [self.dbManager executeQuery:updateQuery];

        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else{
            NSLog(@"Could not execute the query.");
        }

        // speak out the item
        [sharedCenter SpeakOut:sItem.text];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // handling code
        [sharedCenter SpeakOut:@"please double tap to make a selection"];
    }
}

- (NSString *)fullTitle:(NSString *)menu category:(NSString *)category {
    NSMutableString *title = [[NSMutableString alloc] init];

    if ([[menu lowercaseString] isEqualToString:@"hearing"]) {
        [title setString:@"Hearing->"];
        NSLog(@"if menu is hearing :%@", title);

        if ([[category lowercaseString] isEqualToString:@"gettingonoff"]) {
            [title appendString:@"Getting on and off the bus"];
        } else if ([[category lowercaseString] isEqualToString:@"ridingthebus"]) {
            [title appendString:@"Riding the bus"];
        } else if ([[category lowercaseString] isEqualToString:@"safety"]) {
            [title appendString:@"Safety"];
        } else if ([[category lowercaseString] isEqualToString:@"emergency"]) {
            [title appendString:@"Emergency"];
        } else {
            [title appendString:@"Unknown"];
        }


    } else if ([[menu lowercaseString] isEqualToString:@"nonenglish"]) {
        [title setString:@"Español->"];

        if ([[category lowercaseString] isEqualToString:@"gettingonoff"]) {
            [title appendString:@"Embarque"];
        } else if ([[category lowercaseString] isEqualToString:@"ridingthebus"]) {
            [title appendString:@"Viajar"];
        } else if ([[category lowercaseString] isEqualToString:@"safety"]) {
            [title appendString:@"Bajar"];
        } else if ([[category lowercaseString] isEqualToString:@"emergency"]) {
            [title appendString:@"Emergency"];
        } else {
            [title appendString:@"Unknown"];
        }
    }

    NSLog(@"menu=%@ cat=%@ title=%@", menu, category, title);


    return title;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexpath=%ld", [indexPath row]);

    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    //    long row = [indexPath row];
    //    TTSItemStruct *sItem = self.items[row];
    //    [sharedCenter SpeakOut:sItem.text];
}


// in iOS 7 regardless of orientation width is the shorter side; in iOS8+ it is orientation dependent
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [ResourceCenter screenSize].height / 3;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"ItemTableCell";
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    long row = [indexPath row];
    
    TTSItemStruct *tItem = self.items[row];
    // NSLog(@"row=%ld text=%@ img=%@ item=%@ count=%ld", row, tItem.text, tItem.image, tItem, items.count);

    if ([[self subMenu] isEqualToString:@"hearing"]) {
        cell.itemLabel.text = [tItem title];
    } else if ([[self subMenu] isEqualToString:@"nonenglish"]) {
        cell.itemLabel.text = [[NSString alloc]
                initWithFormat:@"%@/%@", [tItem titulo], [tItem title]];
    }

    NSString *imageName = [NSString stringWithFormat:@"sym/%@", [tItem image]];
    cell.itemImage.image = [UIImage imageNamed:imageName];


    // blue background color of each cell
    UIColor *blueBack = [UIColor colorWithRed: 64.0/255.0f green:147.0/255.0f blue:223.0/255.0f alpha:1.0];
    cell.itemLabel.backgroundColor = blueBack;
    cell.itemLabel.textColor = [UIColor whiteColor];
    [cell.itemLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];

    cell.itemImage.backgroundColor = [UIColor blueColor];

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



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"displayMore"]) {
        MoreMenuTableViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.from = [[segue identifier] stringByAppendingFormat:@"-%@", [self subMenu]];
    }
}


@end
