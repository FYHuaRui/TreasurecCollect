//
//  PersNSObject.h
//  TreasureCollect
//
//  Created by FYHR on 2016/12/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PersNSObject : NSObject

@property (nonatomic, retain) UIImage       *leftImage;//左边图片
@property (nonatomic, retain) NSString      *context;//功能名
@property (nonatomic, retain) UIView        *rightView;//右边功能

- (id)initWithLeftView:(UIImage*)leftImage label:(NSString*)str rightView:(UIView*)rightView;


@end
