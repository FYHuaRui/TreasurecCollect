//
//  LeftTableView.h
//  TreasureCollect
//
//  Created by FYHR on 2016/12/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LeftTableView : NSObject

@property (nonatomic, retain) UIImage       *leftImage;//左边图片
@property (nonatomic, retain) NSString      *content;//功能名

- (id)initWithLeftView:(UIImage*)leftImage label:(NSString*)str;

@end
