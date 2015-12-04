//
//  TTSItemStruct.h
//  ProjEric1
//
//  Created by Hongbiao Yang on 7/30/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTSItemStruct : NSObject

- (instancetype)initItemWithText:(NSString *)text;

@property (nonatomic, retain)   NSString *title;
@property (nonatomic, retain)   NSString *text;
@property (nonatomic, retain)   NSString *titulo;
@property (nonatomic, retain)   NSString *texto;
@property (nonatomic, retain)   NSString *image;
@property (nonatomic, retain)   NSString *imageV;
@property (nonatomic, retain)   NSString *color;
@property (nonatomic, retain)   NSString *customize;


@property(nonatomic) int hearing;
@property(nonatomic) int nonenglish;
@property(nonatomic) int cognitive;
@end
