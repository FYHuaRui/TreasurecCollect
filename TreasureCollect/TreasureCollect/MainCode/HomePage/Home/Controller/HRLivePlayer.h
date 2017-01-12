//
//  HRLivePlayer.h
//  TreasureCollect
//
//  Created by FYHR on 2016/12/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRLiveCell.h"

@interface HRLivePlayer : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, retain) NSMutableArray        *aryData;//直播数据源
@property (nonatomic, retain) UITableView           *tableView;//表视图对象



@end
