//
//  PersNSObject.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PersNSObject.h"

@implementation PersNSObject

- (id)initWithLeftView:(UIImage *)leftImage label:(NSString *)str rightView:(UIView *)rightView
{
    self = [super init];
    if (self)
    {
        self.leftImage = leftImage;
        self.context = str;
        self.rightView = rightView;
    }
    return self;
}

@end
