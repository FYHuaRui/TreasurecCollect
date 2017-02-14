//
//  tradeDetailCell.h
//  TreasureCollect
//
//  Created by Apple on 2017/2/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tradeDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *beginCost;
@property (weak, nonatomic) IBOutlet UILabel *overCost;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *poundageLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyType;
@property (weak, nonatomic) IBOutlet UILabel *beganTime;
@property (weak, nonatomic) IBOutlet UILabel *overTime;
@property (weak, nonatomic) IBOutlet UILabel *overKind;


@end
