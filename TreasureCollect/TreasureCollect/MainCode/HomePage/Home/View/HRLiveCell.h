//
//  HRLiveCell.h
//  TreasureCollect
//
//  Created by 方圆华睿 on 2017/1/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRLiveCell : UITableViewCell

@property (nonatomic, retain) UIImage       *liverImage;//直播人头像
@property (nonatomic, retain) UILabel       *nameLab;//直播人姓名
@property (nonatomic, retain) UIImage       *liveImage;//直播简略图
@property (nonatomic, retain) UILabel       *messageLab;//直播内容简介
@property (nonatomic) int                   userNum;//观看的用户总人数

@end
