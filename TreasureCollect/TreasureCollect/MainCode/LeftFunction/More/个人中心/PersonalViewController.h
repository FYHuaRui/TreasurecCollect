//
//  PersonalViewController.h
//  TreasureCollect
//
//  Created by FYHR on 2016/12/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersNSObject.h"

@interface PersonalViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, retain) UITableView       *tableView;//表视图
@property (nonatomic, retain) NSArray           *arrayData;//数据源

@end
