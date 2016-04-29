//
//  FMDBDataAccess.m
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import "FMDBDataAccess.h"

@implementation FMDBDataAccess

-(BOOL) insertproductdData:(NSMutableDictionary *)dictData{
    // insert customer into database
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    //    NSArray * sortedKeys = [[dictData allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    //
    //    NSArray * objects = [dictData objectsForKeys: sortedKeys notFoundMarker: [NSNull null]];
    
    NSString *strDescription=@"";
    if([[dictData allKeys] containsObject:@"description"])
        strDescription = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"description"]];
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    strDescription= [[strDescription componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@" "];
    
    
    if(strDescription.length>100)
        strDescription = [strDescription substringWithRange:NSMakeRange(0, 100)];
    strDescription = [strDescription stringByReplacingOccurrencesOfString:@","
                                                               withString:@""];
    NSString *strBrand=@"";
    if([[dictData allKeys] containsObject:@"brand"])
        strBrand = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"brand"]];
    strBrand = [[strBrand componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@" "];
    
    
    NSString *strName=@"";
    if([[dictData allKeys] containsObject:@"name"])
        strName = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"name"]];
    strName = [[strName componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO %@ (brand,description,id,image_url,imageurl,name,price,prod_id,prod_in_cart,qty,sku,totalPrice,unit,weight) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@);",@"LocalCartProduct",
                             [NSString stringWithFormat:@"'%@'",strBrand],
                             [NSString stringWithFormat:@"'%@'",strDescription],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"id"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"image_url"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"imageurl"]],
                             [NSString stringWithFormat:@"'%@'",strName],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"price"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"prod_id"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"prod_in_cart"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"qty"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sku"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"totalPrice"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"unit"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"weight"]]];
    
    BOOL success =  [db executeUpdate:insertQuery,nil];
    
    [db close];
    
    return success;
    
    return YES;
}

-(BOOL) updateproductdData:(NSString *)productId dictData:(NSMutableDictionary *)dictData{
    // insert customer into database
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    NSString *insertQuery =[NSString stringWithFormat:
                            @"UPDATE LocalCartProduct SET prod_id = %@, qty = %@,brand = %@,description = %@,imageurl = %@,name = %@,price = %@,sku = %@,unit = %@,image_url = %@,prod_in_cart = %@,weight = %@, totalPrice = %@ WHERE id = %@ ",
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"prod_id"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"qty"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"brand"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"description"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"imageurl"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"name"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"price"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sku"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"unit"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"image_url"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"prod_in_cart"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"weight"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"totalPrice"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"id"]]
                            ];
    
    
    BOOL success =  [db executeUpdate:insertQuery,nil];
    
    [db close];
    
    return success;
    
    return YES;
}
-(NSMutableArray*)fetchAllProductDataFromLocalDB
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    NSMutableArray *client = [[NSMutableArray alloc] init];
    NSString *getUserDataStr = [NSString stringWithFormat:@"select * from LocalCartProduct"];
    
    FMResultSet *results = [db executeQuery:getUserDataStr];
    
    while([results next])
    {
        NSDictionary *d =@{
                           @"prod_id":[results stringForColumn:@"prod_id"],
                           @"qty":[results stringForColumn:@"qty"],
                           @"brand":[results stringForColumn:@"brand"],
                           @"description":[results stringForColumn:@"description"],
                           @"id":[results stringForColumn:@"id"],
                           @"imageurl":[results stringForColumn:@"imageurl"],
                           @"name":[results stringForColumn:@"name"],
                           @"price":[results stringForColumn:@"price"],
                           @"sku":[results stringForColumn:@"sku"],
                           @"unit":[results stringForColumn:@"unit"],
                           @"image_url":[results stringForColumn:@"image_url"],
                           @"prod_in_cart":[results stringForColumn:@"prod_in_cart"],
                           @"totalPrice":[results stringForColumn:@"totalPrice"],
                           @"weight":[results stringForColumn:@"weight"]
                           };
        [client addObject:d];
    }
    
    [db close];
    
    return client;
}
-(BOOL)deleteAllProductData{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *insertQuery = [NSString stringWithFormat:@"DELETE FROM LocalCartProduct"];
    BOOL success=[db executeUpdate:insertQuery,nil];
    
    return success;
}

-(BOOL)deleteProductData:(NSString *)strID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *insertQuery = [NSString stringWithFormat:@"DELETE FROM LocalCartProduct WHERE id = %@",strID];
    BOOL success=[db executeUpdate:insertQuery,nil];
    
    return success;
}

-(bool)updateUsernUserId:(NSMutableDictionary *)dictData
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    
    NSString *insertQuery =[NSString stringWithFormat:@"UPDATE userdata SET nUserId = %@ WHERE sEmail = %@", [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nUserId"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sEmail"]]];
    BOOL success =  [db executeUpdate:insertQuery,nil];
    
    [db close];
    
    return success;
    
    return YES;
    
}
-(BOOL) updateUserData:(NSMutableDictionary *)dictData{
    // insert customer into database
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    NSString *insertQuery =[NSString stringWithFormat:@"UPDATE userdata SET IsAdded = %@,nCompanyId = %@,password = %@,sEmail = %@,sFirstName = %@,sLastName = %@,sNewVehicalSales = %@,sUsedVehicalSales = %@ WHERE nUserId = %@",
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"IsAdded"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nCompanyId"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"password"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sEmail"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstName"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sLastName"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sUsedVehicalSales"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sNewVehicalSales"]],
                            
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nUserId"]]
                            ];
    BOOL success =  [db executeUpdate:insertQuery,nil];
    
    [db close];
    
    return success;
    
    return YES;
}


-(NSMutableArray *) getClient:(NSString *)userID
{
    NSMutableArray *client=[[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    NSString *getUserDataStr = [NSString stringWithFormat:@"select * from clientdatabase where nUserId='%@'",userID];
    
    FMResultSet *results = [db executeQuery:getUserDataStr];
    
    while([results next])
    {
        NSDictionary *d=@{
                          @"dDate":[results stringForColumn:@"dDate"],
                          @"IsAdded":[results stringForColumn:@"IsAdded"],
                          @"nBackGrossAmount":[results stringForColumn:@"nBackGrossAmount"],
                          @"nClientId":[results stringForColumn:@"nClientId"],
                          @"nFrontGrossAmount":[results stringForColumn:@"nFrontGrossAmount"],
                          @"nMobile":[results stringForColumn:@"nMobile"],
                          @"nTotalGrossAmount":[results stringForColumn:@"nTotalGrossAmount"],
                          @"nUserId":[results stringForColumn:@"nUserId"],
                          @"sAddress":[results stringForColumn:@"sAddress"],
                          @"sCity":[results stringForColumn:@"sCity"],
                          @"sContactType":[results stringForColumn:@"sContactType"],
                          @"sCurrentlyFinance":[results stringForColumn:@"sCurrentlyFinance"],
                          @"sCurrentMonthly":[results stringForColumn:@"sCurrentMonthly"],
                          @"sCustomerType":[results stringForColumn:@"sCustomerType"],
                          @"sDescisionMaker":[results stringForColumn:@"sDescisionMaker"],
                          @"sCustomerStatus":[results stringForColumn:@"sCustomerStatus"],
                          @"sDesireMonthly":[results stringForColumn:@"sDesireMonthly"],
                          @"sEmail":[results stringForColumn:@"sEmail"],
                          @"sEndTime":[results stringForColumn:@"sEndTime"],
                          @"sFirstMake":[results stringForColumn:@"sFirstMake"],
                          @"sFirstModel":[results stringForColumn:@"sFirstModel"],
                          @"sFirstName":[results stringForColumn:@"sFirstName"],
                          @"sFirstStockNumber":[results stringForColumn:@"sFirstStockNumber"],
                          @"sFirstVehType":[results stringForColumn:@"sFirstVehType"],
                          @"sFirstYear":[results stringForColumn:@"sFirstYear"],
                          @"sHearAbout":[results stringForColumn:@"sHearAbout"],
                          @"sHome":[results stringForColumn:@"sHome"],
                          @"sImage":[results stringForColumn:@"sImage"],
                          @"sLastName":[results stringForColumn:@"sLastName"],
                          @"sMake":[results stringForColumn:@"sMake"],
                          @"sMiles":[results stringForColumn:@"sMiles"],
                          @"sNextPayment":[results stringForColumn:@"sNextPayment"],
                          @"sSecondMake":[results stringForColumn:@"sSecondMake"],
                          @"sSecondModel":[results stringForColumn:@"sSecondModel"],
                          @"sSecondStockNumber":[results stringForColumn:@"sSecondStockNumber"],
                          @"sSecondVehType":[results stringForColumn:@"sSecondVehType"],
                          @"sSecondYear":[results stringForColumn:@"sSecondYear"],
                          @"sStartTime":[results stringForColumn:@"sStartTime"],
                          @"sState":[results stringForColumn:@"sState"],
                          @"sVinModel":[results stringForColumn:@"sVinModel"],
                          @"sVinYear":[results stringForColumn:@"sVinYear"],
                          @"sWork":[results stringForColumn:@"sWork"],
                          @"sZip":[results stringForColumn:@"sZip"]
                          };
        [client addObject:d];
    }
    
    [db close];
    
    return client;
}
-(NSMutableArray *)CheckRemainingDataForUser
{
    NSMutableArray *client=[[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    
    NSString *getUserDataStr = [NSString stringWithFormat:@"select * from userdata where IsAdded='%@' OR IsAdded='%@'",@"1",@"2"];
    
    FMResultSet *results = [db executeQuery:getUserDataStr];
    
    while([results next])
    {
        NSDictionary *d=@{
                          @"sLastName":[results stringForColumn:@"sLastName"],
                          @"sFirstName":[results stringForColumn:@"sFirstName"],
                          @"sEmail":[results stringForColumn:@"sEmail"],
                          @"password":[results stringForColumn:@"password"],
                          @"nCompanyId":[results stringForColumn:@"nCompanyId"],
                          @"nUserId":[results stringForColumn:@"nUserId"],
                          @"IsAdded":[results stringForColumn:@"IsAdded"],
                          @"sUsedVehicalSales":[results stringForColumn:@"sUsedVehicalSales"],
                          @"sNewVehicalSales":[results stringForColumn:@"sNewVehicalSales"]
                          
                          
                          };
        [client addObject:d];
    }
    
    [db close];
    
    return client;
}



-(NSMutableArray *)CheckRemainingDataForClient
{
    NSMutableArray *client=[[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    
    NSString *getClientDataStr = [NSString stringWithFormat:@"select * from clientdatabase where IsAdded='%@' OR IsAdded='%@'",@"1",@"2"];
    
    FMResultSet *results = [db executeQuery:getClientDataStr];
    
    while([results next] && results.columnCount>0)
    {
        NSDictionary *d=@{
                          @"dDate":[results stringForColumn:@"dDate"],
                          @"IsAdded":[results stringForColumn:@"IsAdded"],
                          @"nBackGrossAmount":[results stringForColumn:@"nBackGrossAmount"],
                          @"nClientId":[results stringForColumn:@"nClientId"],
                          @"nFrontGrossAmount":[results stringForColumn:@"nFrontGrossAmount"],
                          @"nMobile":[results stringForColumn:@"nMobile"],
                          @"nTotalGrossAmount":[results stringForColumn:@"nTotalGrossAmount"],
                          @"nUserId":[results stringForColumn:@"nUserId"],
                          @"sAddress":[results stringForColumn:@"sAddress"],
                          @"sCity":[results stringForColumn:@"sCity"],
                          @"sContactType":[results stringForColumn:@"sContactType"],
                          @"sCurrentlyFinance":[results stringForColumn:@"sCurrentlyFinance"],
                          @"sCurrentMonthly":[results stringForColumn:@"sCurrentMonthly"],
                          @"sCustomerType":[results stringForColumn:@"sCustomerType"],
                          @"sDescisionMaker":[results stringForColumn:@"sDescisionMaker"],
                          @"sCustomerStatus":[results stringForColumn:@"sCustomerStatus"],
                          @"sDesireMonthly":[results stringForColumn:@"sDesireMonthly"],
                          @"sEmail":[results stringForColumn:@"sEmail"],
                          @"sEndTime":[results stringForColumn:@"sEndTime"],
                          @"sFirstMake":[results stringForColumn:@"sFirstMake"],
                          @"sFirstModel":[results stringForColumn:@"sFirstModel"],
                          @"sFirstName":[results stringForColumn:@"sFirstName"],
                          @"sFirstStockNumber":[results stringForColumn:@"sFirstStockNumber"],
                          @"sFirstVehType":[results stringForColumn:@"sFirstVehType"],
                          @"sFirstYear":[results stringForColumn:@"sFirstYear"],
                          @"sHearAbout":[results stringForColumn:@"sHearAbout"],
                          @"sHome":[results stringForColumn:@"sHome"],
                          @"sImage":[results stringForColumn:@"sImage"],
                          @"sLastName":[results stringForColumn:@"sLastName"],
                          @"sMake":[results stringForColumn:@"sMake"],
                          @"sMiles":[results stringForColumn:@"sMiles"],
                          @"sNextPayment":[results stringForColumn:@"sNextPayment"],
                          @"sSecondMake":[results stringForColumn:@"sSecondMake"],
                          @"sSecondModel":[results stringForColumn:@"sSecondModel"],
                          @"sSecondStockNumber":[results stringForColumn:@"sSecondStockNumber"],
                          @"sSecondVehType":[results stringForColumn:@"sSecondVehType"],
                          @"sSecondYear":[results stringForColumn:@"sSecondYear"],
                          @"sStartTime":[results stringForColumn:@"sStartTime"],
                          @"sState":[results stringForColumn:@"sState"],
                          @"sVinModel":[results stringForColumn:@"sVinModel"],
                          @"sVinYear":[results stringForColumn:@"sVinYear"],
                          @"sWork":[results stringForColumn:@"sWork"],
                          @"sZip":[results stringForColumn:@"sZip"]
                          };
        [client addObject:d];
    }
    
    [db close];
    
    return client;
}
-(NSMutableArray *) getUsers:(NSString *)userID
{
    NSMutableArray *client=[[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    NSString *getUserDataStr = [NSString stringWithFormat:@"select * from userdata where nUserId='%@'",userID];
    
    FMResultSet *results = [db executeQuery:getUserDataStr];
    
    while([results next])
    {
        NSDictionary *d=@{
                          @"sLastName":[results stringForColumn:@"sLastName"],
                          @"sFirstName":[results stringForColumn:@"sFirstName"],
                          @"sEmail":[results stringForColumn:@"sEmail"],
                          @"password":[results stringForColumn:@"password"],
                          @"nCompanyId":[results stringForColumn:@"nCompanyId"],
                          @"nUserId":[results stringForColumn:@"nUserId"],
                          @"sUsedVehicalSales":[results stringForColumn:@"sUsedVehicalSales"],
                          @"sNewVehicalSales":[results stringForColumn:@"sNewVehicalSales"],
                          @"nCompanyId":[results stringForColumn:@"nCompanyId"]
                          };
        [client addObject:d];
    }
    
    [db close];
    
    return client;
}
-(NSString *) getThumbImage:(NSString *)userID
{
    NSMutableArray *client=[[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    NSString *getUserDataStr = [NSString stringWithFormat:@"select thumb_CompanyImage from userdata where nUserId='%@'",userID];
    
    FMResultSet *results = [db executeQuery:getUserDataStr];
    
    //
    while([results next])
    {
        NSDictionary *d=@{
                          @"thumb_CompanyImage":[results stringForColumn:@"thumb_CompanyImage"],
                          
                          };
        [client addObject:d];
    }
    NSString *CompanyThumbImage=[client[0] valueForKey:@"thumb_CompanyImage"];
    
    return CompanyThumbImage;
}

-(BOOL)checkUserLogin:(NSString *)userName andPassword:(NSString *)password {
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"select * from userdata where sEmail='%@' and password='%@'",userName,password]];
    
    
    while([results next])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[results stringForColumn:@"nUserid"] forKey:@"nUserId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return TRUE;
    }
    
    [db close];
    return FALSE;
}

-(void)deleteAllclientDataByUserId:(NSString *)strID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM clientdatabase"];
    BOOL success=[db executeUpdate:deleteQuery,nil];
    if(success){
        
    }
    [db close];
    
}
-(BOOL)deleteclientData:(NSString *)strID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *insertQuery = [NSString stringWithFormat:@"DELETE FROM clientdatabase WHERE ClientID = %@",strID];
    BOOL success=[db executeUpdate:insertQuery,nil];
    
    return success;
}

-(BOOL) updateclientData:(NSMutableDictionary *)dictData
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    NSString *insertQuery = [NSString stringWithFormat:@"UPDATE clientdatabase SET dDate = %@,nBackGrossAmount = %@,nFrontGrossAmount = %@, nMobile = %@,nTotalGrossAmount = %@, sAddress = %@, sCity = %@, sContactType = %@, sCurrentlyFinance = %@, sCurrentMonthly = %@,sCustomerStatus = %@, sCustomerType = %@, sDescisionMaker = %@, sDesireMonthly = %@, sEmail = %@, sEndTime = %@,sFirstMake = %@, sFirstModel = %@, sFirstName = %@, sFirstStockNumber = %@, sFirstVehType = %@, sFirstYear = %@, sHearAbout = %@, sHome = %@, sImage = %@, sLastName = %@, sMake = %@, sMiles = %@, sNextPayment = %@,sNote = %@, sSecondMake = %@, sSecondModel = %@, sSecondStockNumber = %@, sSecondVehType = %@, sSecondYear = %@,sStartTime = %@, sVinModel = %@, sVinYear = %@, sWork = %@, sZip = %@ WHERE nClientId = %@",
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"dDate"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nBackGrossAmount"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nFrontGrossAmount"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nMobile"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nTotalGrossAmount"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sAddress"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sCity"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sContactType"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sCurrentlyFinance"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sCurrentMonthly"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sCustomerStatus"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sCustomerType"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sDescisionMaker"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sDesireMonthly"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sEmail"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sEndTime"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstMake"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstModel"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstName"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstStockNumber"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstVehType"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstYear"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sHearAbout"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sHome"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sImage"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sLastName"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sMake"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sMiles"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sNextPayment"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sNote"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sSecondMake"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sSecondModel"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sSecondStockNumber"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sSecondVehType"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sSecondYear"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sStartTime"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sVinModel"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sVinYear"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sWork"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sZip"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nClientId"]]];
    BOOL success = [db executeUpdate:insertQuery,nil];
    
    [db close];
    //return true;
    return success;
}


-(BOOL) insertclientData:(NSMutableDictionary *)dictData{
    // insert customer into database
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO %@ (dDate,IsAdded,nBackGrossAmount,nClientId,nFrontGrossAmount,nMobile,nTotalGrossAmount,nUserId,sAddress,sCity,sContactType,sCurrentlyFinance,sCurrentMonthly,sCustomerType,sDescisionMaker,sDesireMonthly,sEmail,sEndTime,sFirstMake,sFirstModel,sFirstName,sFirstStockNumber,sFirstVehType,sFirstYear,sHearAbout,sHome,sImage,sLastName,sMake,sMiles,sNextPayment,sNote,sSecondMake,sSecondModel,sSecondStockNumber,sSecondVehType,sSecondYear,sStartTime,sState,sVinModel,sVinYear,sWork,sZip) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@);",@"clientdatabase",
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"dDate"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"IsClientOnline"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nBackGrossAmount"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nClientId"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nFrontGrossAmount"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nMobile"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nTotalGrossAmount"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"nUserId"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sAddress"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sCity"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sContactType"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sCurrentlyFinance"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sCurrentMonthly"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sCustomerType"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sDescisionMaker"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sDesireMonthly"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sEmail"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sEndTime"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstMake"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstModel"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstName"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstStockNumber"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstVehType"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sFirstYear"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sHearAbout"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sHome"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sImage"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sLastName"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sMake"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sMiles"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sNextPayment"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sNote"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sSecondMake"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sSecondModel"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sSecondStockNumber"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sSecondVehType"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sSecondYear"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sStartTime"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sState"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sVinModel"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sVinYear"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sWork"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"sZip"]]
                             ];
    
    BOOL success = [db executeUpdate:insertQuery, nil];
    
    [db close];
    
    return success;
    
    return YES;
}



@end
