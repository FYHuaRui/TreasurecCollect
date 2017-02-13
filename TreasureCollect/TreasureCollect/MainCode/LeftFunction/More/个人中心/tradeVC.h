//
//  tradeVC.h
//  TreasureCollect
//
//  Created by FYHR on 2016/12/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tradeVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView       *tableView;
@property (nonatomic, retain) NSMutableArray    *arrayData;

@end
