//
//  NSString+GetNetip.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(NSString_GetNetip)

+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (BOOL)isValidatIP:(NSString *)ipAddress;
+ (NSDictionary *)getIPAddresses;

@end
