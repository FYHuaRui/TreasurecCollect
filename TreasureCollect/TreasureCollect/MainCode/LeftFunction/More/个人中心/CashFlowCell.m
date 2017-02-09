//
//  CashFlowCell.m
//  TreasureCollect
//
//  Created by 方圆华睿 on 2017/2/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CashFlowCell.h"

@implementation CashFlowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initSubViews];
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

//自定义cell
- (void)initSubViews
{
    //资金流水类型
    self.ioType = [[UILabel alloc] initWithFrame:CGRectZero];
    self.ioType.font = [UIFont systemFontOfSize:16];
    self.ioType.textColor = [UIColor blackColor];
    self.ioType.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.ioType];
    
    [self.ioType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(5);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@40);
    }];

    //时间
    self.createTime = [[UILabel alloc] initWithFrame:CGRectZero];
    self.createTime.font = [UIFont systemFontOfSize:10];
    self.createTime.textColor = [UIColor lightGrayColor];
    self.createTime.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.createTime];
    
    [self.createTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ioType).offset(10);
        make.left.mas_offset(self.ioType);
        make.width.mas_offset(@120);
        make.height.mas_offset(@25);
    }];

    //金额
    self.amount = [[UILabel alloc] initWithFrame:CGRectZero];
    self.amount.font = [UIFont systemFontOfSize:14];
    self.amount.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.amount];
    
    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-30);
        make.width.mas_offset(@200);
        make.height.mas_offset(@400);
    }];
}

@end
