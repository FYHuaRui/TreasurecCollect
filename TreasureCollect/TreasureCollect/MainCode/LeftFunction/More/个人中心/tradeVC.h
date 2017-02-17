//
//  tradeVC.h
//  TreasureCollect
//
//  Created by FYHR on 2016/12/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tradeCell.h"
#import "tradeDetailCell.h"

@interface tradeVC : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *_isDownArr;
    NSString   *_lastSection;
    
}

@property (nonatomic, retain) UITableView       *tableView;
@property (nonatomic, retain) NSMutableArray    *arrayData;


@end
