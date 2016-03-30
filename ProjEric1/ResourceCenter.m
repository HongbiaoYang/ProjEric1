//
//  ResourceCenter.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 9/23/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "ResourceCenter.h"
#import "TTSItemStruct.h"
#import "DBManager.h"
#import <AVFoundation/AVSpeechSynthesis.h>



@implementation ResourceCenter

@synthesize synthesizer;
@synthesize imgViewSound;
@synthesize iconSound;

+ (id)sharedResource {
    static ResourceCenter *sharedResource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedResource = [[self alloc] init];
    });
    return sharedResource;
}

- (BOOL)isFbLogged {
    if ([self fbLogin] == YES) {
        return YES;
    } else {
        return [self readLoginStatusFromDB:@"fbLogin"];
    }
}

- (BOOL)isGgLogged {
    if ([self ggLogin] == YES) {
        return YES;
    } else {
        return [self readLoginStatusFromDB:@"ggLogin"];
    }
}


- (instancetype)init {
    self = [super init];
    if (self) {

        // init db
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"projEric.sql"];

        // init synthesizer
        synthesizer = [[AVSpeechSynthesizer alloc] init];
        [self setTalkSpeed:[self loadSpeedFromDB]];

        // init animation resources
        UIImage *frame = [UIImage imageNamed:@"sound0.png"];
        CGRect rect = CGRectMake(0,0,frame.size.width, frame.size.height);

        imgViewSound = [[UIImageView alloc] initWithFrame:rect];
        imgViewSound.animationImages = [NSArray arrayWithObjects:
                [UIImage imageNamed:@"sound0.png"],
                [UIImage imageNamed:@"sound1.png"],
                [UIImage imageNamed:@"sound2.png"],
                [UIImage imageNamed:@"sound3.png"], nil];
        imgViewSound.image = frame;

        imgViewSound.animationDuration = 1.0f;
        imgViewSound.animationRepeatCount = 1;
//        [imgViewSound startAnimating];

        iconSound = [[UIBarButtonItem alloc] initWithCustomView:imgViewSound];

        // init some other global variable.
        [self setTransit:@"para"];

        [self setFbLogin:[self readLoginStatusFromDB:@"FBLogin"]];
        [self setGgLogin:[self readLoginStatusFromDB:@"GGLogin"]];
    }

    return self;
}


- (float)loadSpeedFromDB {

    NSString *query = @"select fieldValue from appInfo where fieldKey = 'speakSpeed';";


    NSArray *arrInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

//    // if there is no record in the database
//    if (self.arrInfo == nil) {
//        NSString *query = [NSString stringWithFormat:@"insert into appInfo values (null, 'speakSpeed', 0.3);", self.SpeedSlider.value];
//        [self.dbManager executeQuery:query];
//
//        // If the query was successfully executed then pop the view controller.
//        if (self.dbManager.affectedRows != 0) {
//            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
//        }
//        else{
//            NSLog(@"Could not execute the query.");
//        }
//
//        return 0.3f;
//    }

    NSString *speedStr = (NSString *) [[arrInfo objectAtIndex:0] objectAtIndex:0];


    return (CGFloat) [speedStr floatValue];
}

- (BOOL)readLoginStatusFromDB:(NSString *)loginType {

    NSString *query = [NSString stringWithFormat:
            @"select fieldValue from appInfo where fieldKey = '%@';", loginType];

    NSArray *loginArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];


/*    // if there is no record in the database
    if (self.arrInfo == nil) {
        NSString *query = [NSString stringWithFormat:@"insert into appInfo values (null, 'speakSpeed', 0.3);", self.SpeedSlider.value];
        [self.dbManager executeQuery:query];

        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else{
            NSLog(@"Could not execute the query.");
        }

        return 0.3f;
    }*/

    // empty array, no login for sure, insert a record with NO
    if (loginArray == nil || loginArray.count == 0) {
        [self insertDefaultValue:[NSString stringWithFormat:
                @"insert into appInfo values (null, '%@', 'NO');", loginType]];

        return NO;
    }

    NSString *loginValue = (NSString *) [[loginArray objectAtIndex:0] objectAtIndex:0];


    return [loginValue boolValue];
}

- (void)insertDefaultValue:(NSString *)insertQuery {

    [self.dbManager executeQuery:insertQuery];

    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }

}

// speak that interrupts the previous speaking
- (void)SpeakOut:(NSString *)text {
    if ([[self synthesizer] isSpeaking]) {
        [[self synthesizer] stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }

    [self SpeakContinue:text];
}

// speak that does not interrupt previous speaking
- (void)SpeakContinue:(NSString *)text {

    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [utterance setRate:[self talkSpeed]];
    [[self synthesizer] speakUtterance:utterance];

    [[self imgViewSound] startAnimating];
}

+ (CGSize)screenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    return screenSize;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


- (void)dealloc {

}


- (NSString *)decyperToReadable:(NSString *)category {
    if ([category isEqualToString:@"gettingonoff"]) {
        return @"getting on and off the bus";
    } else if ([category isEqualToString:@"ridingthebus"]) {
        return @"riding the bus";
    } else {
        return category;
    }

}

// update facebook login status and db
- (void)updateFBLoginStatus:(BOOL)status {

    NSString *query = [[NSString alloc] initWithFormat:
            @"update appInfo set fieldValue='%@' "
                    "where fieldKey='FBLogin';", status ? @"YES":@"NO"];

    [self setFbLogin:status];
    [self updateDbWithSQL:query];

}

// update google login status and db
- (void)updateGGLoginStatus:(BOOL)status {
    NSString *query = [[NSString alloc] initWithFormat:
            @"update appInfo set fieldValue='%@' "
                    "where fieldKey='GGLogin';", status ? @"YES":@"NO"];

    [self setGgLogin:status];
    [self updateDbWithSQL:query];
}


- (void)updateDbWithSQL:(NSString *)query {

    // Execute the query.
    [self.dbManager executeQuery:query];

    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }

}



@end
