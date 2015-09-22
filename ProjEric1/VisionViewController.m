//
//  VisionViewController.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 9/20/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "VisionViewController.h"
#import "XMLListParser.h"
#import "TTSItemStruct.h"
#import <AVFoundation/AVSpeechSynthesis.h>


AVSpeechSynthesizer *synthesizer;

@interface VisionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *VisionImage;

@end



@implementation VisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    elementToParse = [[NSArray alloc] initWithObjects:@"Title",@"Text",@"ImageV",nil];

    [[NSBundle mainBundle] pathForResource:@"xml/gettingonoff" ofType:@"xml"];


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

    NSLog(@"cat = %@", [self categories]);


    NSString *pathE = [[NSBundle mainBundle] pathForResource:@"xml/emergency" ofType:@"xml"];
    NSString *pathG = [[NSBundle mainBundle] pathForResource:@"xml/gettingonoff" ofType:@"xml"];
    NSString *pathR = [[NSBundle mainBundle] pathForResource:@"xml/ridingbus" ofType:@"xml"];
    NSString *pathS = [[NSBundle mainBundle] pathForResource:@"xml/safety" ofType:@"xml"];
    
    XMLListParser *xmlParser = [[XMLListParser alloc]init];
    [self setItemsEmergency:[xmlParser loadXML:pathE withElements:elementToParse]];
    [self setItemsGetting:[xmlParser loadXML:pathG withElements:elementToParse]];
    [self setItemsRiding:[xmlParser loadXML:pathR withElements:elementToParse]];
    [self setItemsSafety:[xmlParser loadXML:pathS withElements:elementToParse]];

    self.view.backgroundColor = [UIColor blackColor];
    [self setLevel:0];
    [self setIndex1:0];
    [self setIndex2:0];

    [self presentCurrentImageWithLevel:[self level] withIndex1:[self index1] withIndex2:[self index2]];

    // initialized the speech synthesizer once
    synthesizer = [[AVSpeechSynthesizer alloc] init];


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

//    if (currentArray == nil) {
//        NSLog(@"Find empty array! level=%d\n", index1);
//        return;
//    }
//
//    if (index2 < 0 || index2 >= currentArray.count) {
//        NSLog(@"Find illegal index! index=%d\n", index2);
//        return;
//    }

    NSString *imageName = [NSString stringWithFormat:@"sym/%@", [tItem imageV]];
    [self VisonImage].image = [UIImage imageNamed:imageName];
    [self VisionTitle].text = [tItem title];

    NSLog(@"cat = %@ level = %d tItem=%@ index=%d/%d image=%@", [tItem title],
            level, tItem, index1, index2, [tItem imageV]);


    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:tItem .text];
    [utterance setRate:0.3f];
    [synthesizer speakUtterance:utterance];


}

- (NSArray *)getArrayOfLevel:(NSInteger)level {

    if (level == 0) {
        return [self itemsEmergency];
    }
    else if (level == 1) {
        return [self itemsGetting];
    }
    else if (level  == 2) {
        return [self itemsRiding];
    }
    else if (level == 3) {
        return [self itemsSafety];
    }

    return nil;
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{


    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        if ([self level] == 0)
            self.level += 1;

        self.index2 = 0;
    }

    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        if ([self level]  == 1) {
            self.level -= 1;
        }
    }

    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        if ([self level] == 0 && self.index1 < 3) {
            self.index1 += 1;
        } else if ([self level] == 1 && [self index2] < [[self getArrayOfLevel:[self index1]] count])
            self.index2 += 1;
    }

    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        if ([self level] == 0 && self.index1 > 0) {
            self.index1 -= 1;
        } else if ([self level]  == 1 && [self index2] > 0)
            self.index2 -= 1;
    }
    


    NSLog(@"level=%d and index = %d/%%d", self.level, self.index1, self.index2);
    [self presentCurrentImageWithLevel:[self level] withIndex1:[self index1] withIndex2:[self index2]];

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
