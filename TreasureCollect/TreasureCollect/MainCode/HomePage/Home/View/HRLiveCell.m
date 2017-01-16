//
//  HRLiveCell.m
//  TreasureCollect
//
//  Created by 方圆华睿 on 2017/1/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HRLiveCell.h"

@implementation HRLiveCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //自定义cell
        [self initSubView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
 @功能:自定义cell
 @参数：暂无
 @返回值：无
 */
- (void)initSubView
{
    
}

@end
