//
//  LeftMore.h
//  TreasureCollect
//
//  Created by FYHR on 2016/12/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertiseView.h"

@interface LeftMore : UIView<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, retain) UITableView       *tableView;//更多功能表视图
@property (nonatomic, retain) NSArray           *arrayData;//数据源

@end
