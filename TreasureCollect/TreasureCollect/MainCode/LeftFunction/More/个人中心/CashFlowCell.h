//
//  CashFlowCell.h
//  TreasureCollect
//
//  Created by 方圆华睿 on 2017/2/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashFlowCell : UITableViewCell

@property (nonatomic, retain) UILabel      *ioType;//提现／充值类型
@property (nonatomic, retain) UILabel      *amount;//额度
@property (nonatomic, retain) UILabel      *createTime;//创建时间

@end
