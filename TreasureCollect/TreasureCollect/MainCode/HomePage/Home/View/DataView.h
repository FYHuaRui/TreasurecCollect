//
//  DataView.h
//  TreasureCollect
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataView : UIView {

    UILabel *_titleLabel;
    UILabel *_currentCount;
    UIImageView *_animationImage;
    UILabel *_heightCount;
    UILabel *_tomorrowCount;
    UILabel *_lowCount;
    UILabel *_beginCount;
    NSDictionary *_oldDic;
    
    NSArray *_upArr;
    NSArray *_downArr;

}

@property (nonatomic ,strong)NSDictionary *dataDic;

@end
