//
//  CashFlowTableViewCell.h
//  TreasureCollect
//
//  Created by Apple on 2017/2/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashFlowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *operationKindLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@end
