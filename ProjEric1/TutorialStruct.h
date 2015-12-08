//
//  TutorialStruct.h
//  ProjEric1
//
//  Created by Hongbiao Yang on 12/8/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TutorialStruct : NSObject

    @property (nonatomic, retain)   NSString *picture;
    @property (nonatomic, retain)   NSString *voice;
    @property (nonatomic, retain)   NSString *text;
    @property (nonatomic, retain)   NSString *gesture;
    @property (nonatomic, retain)   TutorialStruct *next;

- (instancetype)initStructWithText:(NSString *)text picture:(NSString *)picture
                           gesture:(NSString *)gesture voice:(NSString*)voice ;


@end
