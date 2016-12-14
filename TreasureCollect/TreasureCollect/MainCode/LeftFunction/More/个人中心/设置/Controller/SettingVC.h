//
//  SettingVC.h
//  TreasureCollect
//
//  Created by FYHR on 2016/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingVC : UIViewController<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) UITableView       *tableView;
@property (nonatomic, retain) NSArray           *arrayData;
@property (nonatomic, retain) UIImageView       *myHeadPortrait;

@end
