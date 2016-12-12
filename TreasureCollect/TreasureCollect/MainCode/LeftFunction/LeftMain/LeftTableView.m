//
//  LeftTableView.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LeftTableView.h"

@implementation LeftTableView

- (id)initWithLeftView:(UIImage *)leftImage label:(NSString *)str
{
    if (self = [super init])
    {
        self.leftImage = leftImage;
        self.content = str;
    }
    return self;
}

@end
