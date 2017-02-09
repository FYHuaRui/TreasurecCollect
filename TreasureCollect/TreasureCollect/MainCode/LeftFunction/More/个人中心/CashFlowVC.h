//
//  CashFlowVC.h
//  TreasureCollect
//
//  Created by 方圆华睿 on 2017/2/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashFlowVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView       *tableView;
@property (nonatomic, retain) NSMutableArray    *arrayData;

@end
