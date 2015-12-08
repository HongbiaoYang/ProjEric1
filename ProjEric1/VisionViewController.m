//
//  VisionViewController.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 9/20/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "VisionViewController.h"
#import "TTSItemStruct.h"
#import "ResourceCenter.h"
#import "DBManager.h"

@interface VisionViewController () {
    ResourceCenter *sharedCenter;
}
@property (weak, nonatomic) IBOutlet UIImageView *VisionImage;

@property(nonatomic, strong) UITapGestureRecognizer *dpGesture;
@property(nonatomic, strong) UITapGestureRecognizer *tpGesture;
@property(nonatomic, strong) DBManager *dbManager;
@end



@implementation VisionViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationController] setToolbarHidden:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    TTSItemStruct *emergency = [[TTSItemStruct alloc] init];
    emergency.title = @"Emergency";
    emergency.text = @"Emergency";
    emergency.imageV = @"emergency_v";

    TTSItemStruct *gettingonoff = [[TTSItemStruct alloc] init];
    gettingonoff.title = @"Getting on and off the bus";
    gettingonoff.text = @"getting on and off the bus";
    gettingonoff.imageV = @"gettingonandoffthebus_v";

    TTSItemStruct *ridingbus = [[TTSItemStruct alloc] init];
    ridingbus.title = @"Riding the bus";
    ridingbus.text = @"Riding the bus";
    ridingbus.imageV = @"ridingthebus_v";

    TTSItemStruct *safety = [[TTSItemStruct alloc] init];
    safety.title = @"Safety";
    safety.text = @"Safety";
    safety.imageV = @"safety_v";

    [self setCategories:[[NSMutableArray alloc] init]];

    [[self categories] addObject:emergency];
    [[self categories] addObject:gettingonoff];
    [[self categories] addObject:ridingbus];
    [[self categories] addObject:safety];


    // get sharedCenter
    sharedCenter = [ResourceCenter sharedResource];
    
    // ge dbManager from sharedCenter
    self.dbManager = [sharedCenter dbManager];

    NSString *queryE = [[NSString alloc] initWithFormat:
            @"select * from %@Table where menu = 'emergency' order by itemID asc"
            , [sharedCenter transit]];
    NSString *queryG = [[NSString alloc] initWithFormat:
            @"select * from %@Table where menu = 'gettingonoff' order by itemID asc"
            , [sharedCenter transit]];
    NSString *queryR = [[NSString alloc] initWithFormat:
            @"select * from %@Table where menu = 'ridingthebus' order by itemID asc"
            , [sharedCenter transit]];
    NSString *queryS = [[NSString alloc] initWithFormat:
            @"select * from %@Table where menu = 'safety' order by itemID asc"
            , [sharedCenter transit]];
    NSString *queryM = [[NSString alloc] initWithFormat:
            @"select * from %@Table where menu = 'response' and customize = 'normal' order by itemID asc"
            , [sharedCenter transit]];

    [self setItemsEmergency:[self.dbManager convertValueToItem:
            [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryE]]]];
    [self setItemsGetting:[self.dbManager convertValueToItem:
            [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryG]]]];
    [self setItemsRiding:[self.dbManager convertValueToItem:
            [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryR]]]];
    [self setItemsSafety:[self.dbManager convertValueToItem:
            [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryS]]]];
    [self setItemsResponse:[self.dbManager convertValueToItem:
            [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryM]]]];

    self.view.backgroundColor = [UIColor blackColor];
    [self setLevel:0];
    [self setIndex1:0];
    [self setIndex2:0];

    [self presentCurrentImageWithLevel:[self level] withIndex1:[self index1] withIndex2:[self index2]];

    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];

    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor yellowColor]];

    [self.navigationController setToolbarHidden:YES];

    sharedCenter = [ResourceCenter sharedResource];

    UILongPressGestureRecognizer *threeHold = [[UILongPressGestureRecognizer alloc]
            initWithTarget:self action:@selector(handleTripleHold:)];
    threeHold.numberOfTouchesRequired = 3;
    [self.view addGestureRecognizer:threeHold];

    UILongPressGestureRecognizer *doubleHold = [[UILongPressGestureRecognizer alloc]
            initWithTarget:self action:@selector(handleDoubleHold:)];
    doubleHold.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleHold];

    // add double tap gesture
    self.dpGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.dpGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:self.dpGesture];

    // add triple tap gesture
    self.tpGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTripleTap:)];
    self.tpGesture.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:self.tpGesture];

    [self.dpGesture requireGestureRecognizerToFail:self.tpGesture];

}

- (void)presentCurrentImageWithLevel:(NSInteger) level withIndex1:(NSInteger)index1 withIndex2:(NSInteger)index2 {

    TTSItemStruct *tItem;
    NSArray *currentArray;

    if (level == 0) {
        currentArray = [self categories];
        tItem = currentArray[index1];
    } else {
        currentArray = [self getArrayOfLevel:index1];
        tItem = currentArray[index2];
    }


    NSString *imageName = [NSString stringWithFormat:@"sym/%@", [tItem imageV]];
    [self VisonImage].image = [UIImage imageNamed:imageName];
    [self VisionTitle].text = [tItem title];

    NSLog(@"cat = %@ level = %d tItem=%@ index=%d/%d image=%@", [tItem title],
            level, tItem, index1, index2, [tItem imageV]);

    [sharedCenter SpeakOut:tItem.text];
}

- (NSArray *)getArrayOfLevel:(NSInteger)index {

    if (index == 0) {
        return [self itemsEmergency];
    }
    else if (index == 1) {
        return [self itemsGetting];
    }
    else if (index == 2) {
        return [self itemsRiding];
    }
    else if (index == 3) {
        return [self itemsSafety];
    } else if (index == 4) {
        return [self itemsResponse];
    }

    return nil;
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{


    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        if ([self level] == 0) {
            self.level += 1;

            self.index2 = 0;
        } else {
            [sharedCenter SpeakOut:@"There are no more questions beyound this point, "
                    "please swipe up to access questions"];
            return;
        }
    }

    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        if ([self level]  == 1) {
            self.level -= 1;

            self.index1 = 0;
        } else {
            [sharedCenter SpeakOut:@"There are no more categories beyond this point, "
                    "please swipe down to access categories"];
            return;
        }

    }

    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        if ([self level] == 0) {
            if (self.index1 < 3) {
                self.index1 += 1;
            } else {
                [sharedCenter SpeakOut:@"There are no more categories beyond this point, "
                        "please swipe right to access the previous category"];
                return;
            }
        } else if ([self level] == 1) {
            if ([self index2] < [[self getArrayOfLevel:[self index1]] count] - 1) {
                self.index2 += 1;
            } else {
                [sharedCenter SpeakOut:@"There are no more questions beyond this point, "
                        "please swipe right to access the previous question"];
                return;
            }
        }
    }

    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        if ([self level] == 0) {
             if(self.index1 > 0) {
                 self.index1 -= 1;
             } else {
                 [sharedCenter SpeakOut:@"There are no more categories beyond this point, "
                         "please swipe left to access the next categories"];
                 return;
             }
        } else if ([self level]  == 1) {
            if ([self index2] > 0) {
                self.index2 -= 1;
            } else {
                [sharedCenter SpeakOut:@"There are no more questions beyond this point, "
                        "please swipe left to access the next question"];
                return;
            }
        }
    }

    [self presentCurrentImageWithLevel:[self level] withIndex1:[self index1] withIndex2:[self index2]];

}


- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {

        // handling code
        [sharedCenter SpeakContinue:@"Yes"];
    }
}

- (void)handleTripleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {

        // handling code
        [sharedCenter SpeakContinue:@"No"];
    }
}

- (void)handleTripleHold:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // handling code
        self.level = 1;
        self.index1 = 4;
        self.index2 = 0;

        [self presentCurrentImageWithLevel:[self level] withIndex1:[self index1] withIndex2:[self index2]];
    }
}

- (void)handleDoubleHold:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // handling code
        [sharedCenter SpeakOut:@"Good Bye!"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
                  

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
