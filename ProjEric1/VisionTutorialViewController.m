//
//  VisionTutorialViewController.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 12/7/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "VisionTutorialViewController.h"
#import "ResourceCenter.h"
#import "TutorialStruct.h"


@interface VisionTutorialViewController () {
    ResourceCenter *sharedCenter;
    NSMutableArray *tutorialArray;

}

@property(nonatomic, strong) UITapGestureRecognizer *tpGesture;
@property(nonatomic, strong) UITapGestureRecognizer *dpGesture;
@end

@implementation VisionTutorialViewController {
    TutorialStruct *currentStruct;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    // swipe gesture
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


    // tutorial items
    TutorialStruct *tutorialObject1 = [[TutorialStruct alloc]
            initStructWithText:@"Emergency" picture:@"sym/emergency_v"
                       gesture:@"down" voice:@"please swipe down to enter next level"];

    TutorialStruct *tutorialObject2 = [[TutorialStruct alloc]
            initStructWithText:@"I need help" picture:@"sym/picture48_v"
                       gesture:@"left" voice:@"please swipe left to access next item"];

    TutorialStruct *tutorialObject3 = [[TutorialStruct alloc]
            initStructWithText:@"Another passenger in the bus needs help" picture:@"sym/picture52_v"
                       gesture:@"right" voice:@"please swipe right to access previous item"];

    TutorialStruct *tutorialObject4 = [[TutorialStruct alloc]
            initStructWithText:@"I need help" picture:@"sym/picture48_v"
                       gesture:@"up" voice:@"please swipe up to go back to previous level"];

    TutorialStruct *tutorialObject5 = [[TutorialStruct alloc]
            initStructWithText:@"Emergency" picture:@"sym/emergency_v"
                       gesture:@"double" voice:@"please double tap to say yes"];

    TutorialStruct *tutorialObject6 = [[TutorialStruct alloc]
            initStructWithText:@"Emergency" picture:@"sym/emergency_v"
                       gesture:@"triple" voice:@"please triple tap to say no"];

    TutorialStruct *tutorialObject7 = [[TutorialStruct alloc]
            initStructWithText:@"Emergency" picture:@"sym/emergency_v"
                       gesture:@"threeHold" voice:@"please put three fingers and hold for a while go to to response page"];

    TutorialStruct *tutorialObject8 = [[TutorialStruct alloc]
            initStructWithText:@"Thank you very much" picture:@"sym/picture109_v"
                       gesture:@"doubleHold" voice:@"please put two fingers and hold for a while to go back home"];


    tutorialObject1.next = tutorialObject2;
    tutorialObject2.next = tutorialObject3;
    tutorialObject3.next = tutorialObject4;
    tutorialObject4.next = tutorialObject5;
    tutorialObject5.next = tutorialObject6;
    tutorialObject6.next = tutorialObject7;
    tutorialObject7.next = tutorialObject8;
    tutorialObject8.next = nil;

    currentStruct = tutorialObject1;
    [self performStruct:currentStruct initial:YES];
}

- (void)performStruct:(TutorialStruct *)aStruct initial:(BOOL)initial {

    self.tutImage.image = [UIImage imageNamed:aStruct.picture];
    self.tutText.text = aStruct.text;

    // only speak when it's not the first sentence
    if (initial == NO) {
        [sharedCenter SpeakContinue:@"Good job, you made it"];
    }

    [sharedCenter SpeakContinue:aStruct.voice];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)performStruct:(TutorialStruct *)aStruct {
    [self performStruct:aStruct initial:NO];
}




- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {

        // handling code
        [sharedCenter SpeakContinue:@"Yes"];

        if ([currentStruct.gesture isEqualToString:@"double"]) {
            currentStruct = currentStruct.next;


            [self performStruct:currentStruct];
        } else {
            [sharedCenter SpeakOut:currentStruct.voice];
        }

    }
}

- (void)handleTripleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {

        // handling code
        [sharedCenter SpeakContinue:@"No"];

        if ([currentStruct.gesture isEqualToString:@"triple"]) {
            currentStruct = currentStruct.next;
            [self performStruct:currentStruct];

        } else {
            [sharedCenter SpeakOut:currentStruct.voice];
        }

    }
}

- (void)handleTripleHold:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // handling code
        if ([currentStruct.gesture isEqualToString:@"threeHold"]) {
            currentStruct = currentStruct.next;
            [sharedCenter SpeakOut:currentStruct.text];
            [self performStruct:currentStruct];

        } else {
            [sharedCenter SpeakOut:currentStruct.voice];
        }

    }
}

- (void)handleDoubleHold:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // handling code
        if ([currentStruct.gesture isEqualToString:@"doubleHold"]) {

            // last one, finish and get out of here
            [sharedCenter SpeakContinue:@"Tutorial complete!"];
            [self.navigationController popViewControllerAnimated:YES];

        } else {
            [sharedCenter SpeakOut:currentStruct.voice];
        }

    }
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{

    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        if ([currentStruct.gesture isEqualToString:@"down"]) {
            currentStruct = currentStruct.next;
            [sharedCenter SpeakOut:currentStruct.text];
            [self performStruct:currentStruct];

        } else {
            [sharedCenter SpeakOut:currentStruct.voice];
        }

    }

    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        if ([currentStruct.gesture isEqualToString:@"up"]) {
            currentStruct = currentStruct.next;
            [sharedCenter SpeakOut:currentStruct.text];
            [self performStruct:currentStruct];

        } else {
            [sharedCenter SpeakOut:currentStruct.voice];
        }

    }

    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        if ([currentStruct.gesture isEqualToString:@"left"]) {
            currentStruct = currentStruct.next;
            [sharedCenter SpeakOut:currentStruct.text];
            [self performStruct:currentStruct];

        } else {
            [sharedCenter SpeakOut:currentStruct.voice];
        }

    }

    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        if ([currentStruct.gesture isEqualToString:@"right"]) {
            currentStruct = currentStruct.next;
            [sharedCenter SpeakOut:currentStruct.text];
            [self performStruct:currentStruct];

        } else {
            [sharedCenter SpeakOut:currentStruct.voice];
        }

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
