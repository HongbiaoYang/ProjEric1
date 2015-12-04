//
//  SlideTutorialViewController.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 12/3/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "SlideTutorialViewController.h"
#import "ResourceCenter.h"
#import "DBManager.h"

@interface SlideTutorialViewController ()

@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic, strong) NSMutableArray *tutorialArray;
@property(nonatomic) int indexPage;
@property(nonatomic) int maxPage;
@end

@implementation SlideTutorialViewController {
    ResourceCenter *sharedCenter;
}


- (IBAction)PreviousClicker:(id)sender {
    [self slideBack];
}

- (IBAction)NextClicker:(id)sender {

    [self slideNext];

}

- (IBAction)SkipClicker:(id)sender {
    [sharedCenter SpeakOut:@"Tutorial skipped"];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationController setToolbarHidden:YES];

    // change background and bar color
    self.view.backgroundColor = [UIColor blackColor];   // view bg color
    self.title = [[self from] isEqualToString:@"hearing"] ? @"Hearing Tutorial" : @"Non-English Tutorial";

    // prepare the image arrays
    sharedCenter = [ResourceCenter sharedResource];

    // get database manager
    self.dbManager = [sharedCenter dbManager];

    // cognitive list include everything except response
    NSString *query = [[NSString alloc] initWithFormat:
            @"select * from tutorial where type  = '%@' order by id asc", [self from]];

    NSLog(@"query in cognitive=%@", query);
    // obtain and flatten the list
    self.tutorialArray = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

    self.maxPage = self.tutorialArray.count;
    self.indexPage = 0;

    // set first page
    [self displayPage:[self indexPage]];

    // swipe recognizer define
    UISwipeGestureRecognizer *recognizer;

    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];

    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];



    // add single tap gesture
    UITapGestureRecognizer *spGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    spGesture.numberOfTapsRequired = 1;
    [self.ScreenImg addGestureRecognizer:spGesture];

}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // handling code
        [sharedCenter SpeakOut:@"The pictures are only for display and do not have touch functionality"];
    }
}



-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {

    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe up");
        [self slideNext];
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self slideBack];
    }

}

- (void)slideBack {
    if ([self indexPage] > 0) {
        self.indexPage -= 1;
        [self displayPage:[self indexPage]];
    }
}

- (void)slideNext {
    NSLog(@"in next: %ld/%ld", [self indexPage], [self maxPage]);

    if ([self indexPage] < [self maxPage] - 1) {
        self.indexPage += 1;
        [self displayPage:[self indexPage]];
    } else {
        [sharedCenter SpeakOut:@"Tutorial Complete"];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)displayPage:(int)page {
    NSArray *currentPage = [self.tutorialArray objectAtIndex:page];

    NSInteger indexOfDesc       = [self.dbManager.arrColumnNames indexOfObject:@"desc"];
    NSInteger indexOfVoice      = [self.dbManager.arrColumnNames indexOfObject:@"voice"];
    NSInteger indexOfImage      = [self.dbManager.arrColumnNames indexOfObject:@"image"];
    NSInteger indexOfProgress   = [self.dbManager.arrColumnNames indexOfObject:@"progress"];

    // display the screen shot and the progress. FUCK file name case matters, *.PNG is not recognized!!
    NSString *descImgName = [[NSString alloc] initWithFormat:@"sym/%@", [currentPage objectAtIndex:indexOfImage]];
    NSString *progImgName = [[NSString alloc] initWithFormat:@"sym/%@", [currentPage objectAtIndex:indexOfProgress]];

    self.DescText.text = [currentPage objectAtIndex:indexOfDesc];
    self.ScreenImg.image = [UIImage imageNamed:descImgName];
    self.ProgressImg.image = [UIImage imageNamed:progImgName];

//    [sharedCenter SpeakOut:[currentPage objectAtIndex:indexOfVoice]];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"will disappearin tutorial");
    [[self navigationController] setToolbarHidden:NO animated:animated];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
