//
//  DBManager.h
//  ProjEric1
//
//  Created by hongbiao yang on 10/8/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject

-(instancetype) initWithDatabaseFilename:(NSString *)dbFilenamne;
-(void)copyDatabaseIntoDocumentsDirectory;

-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;


@end
