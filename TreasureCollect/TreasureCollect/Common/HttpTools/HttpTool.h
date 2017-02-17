//
//  HttpTool.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject

//GET--AFN+JSON
+ (void)get:(NSString *)url
     params:(NSDictionary *)params
    success:(void (^)(id json))success
    failure:(void (^)(NSError *error))failure;

//POST--AFN+JSON
+ (void)post:(NSString *)url
      params:(NSDictionary *)params
     success:(void (^)(id json))success
     failure:(void (^)(NSError *error))failure;

//GET--NETWORK
+ (BOOL)getNetwork;

//POST-UPDATE--FILE(MimeType)
+ (void)post:(NSString *)url
      params:(NSDictionary *)params
        data:(NSMutableDictionary *)datas
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure;

+ (void)saveCookies;

+ (void)loadSavedCookies;

@end
