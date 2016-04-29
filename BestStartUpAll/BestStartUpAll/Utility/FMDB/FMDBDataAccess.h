//
//  FMDBDataAccess.h
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDBDataAccess.h"
#import "FMResultSet.h"
#import "Utility.h"

@interface FMDBDataAccess : NSObject
{
    
}


-(NSMutableArray*) getUsers:(NSString *)userID;
-(BOOL) updateUserData:(NSMutableDictionary *)dictData;
-(NSMutableArray*)fetchAllProductDataFromLocalDB;
-(BOOL)deleteProductData:(NSString *)strID;
-(BOOL) updateproductdData:(NSString *)productId dictData:(NSMutableDictionary *)dictData;
-(BOOL)deleteAllProductData;


-(BOOL) insertproductdData:(NSMutableDictionary *)dictData;
-(BOOL)checkUserLogin:(NSString *)userName andPassword:(NSString *)password;
-(BOOL) insertclientData:(NSMutableDictionary *)dictData;
-(BOOL) updateclientData:(NSMutableDictionary *)dictData;
-(BOOL)deleteclientData:(NSString*)strID;
-(void)deleteAllclientDataByUserId:(NSString*)strID;
-(NSMutableArray *) getClient:(NSString *)userID;
-(NSMutableArray *)CheckRemainingDataForUser;
-(NSMutableArray *)CheckRemainingDataForClient;
-(bool)updateUsernUserId:(NSMutableDictionary *)dictData;
-(NSString *) getThumbImage:(NSString *)userID;
@end
