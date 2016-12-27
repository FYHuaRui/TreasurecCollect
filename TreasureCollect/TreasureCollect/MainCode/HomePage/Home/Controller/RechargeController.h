//
//  RechargeController.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

#import "PayButton.h"
#import "PayCountButton.h"

@interface RechargeController : BaseViewController{

    UIScrollView *_bgScrollView;
    
    UIImageView *_topImage;
    
    UILabel     *_restLabel;
    
    //充值视图
    UIView      *_rechargeView;
    UILabel     *_selectLabel;
    
    //提现试图
    UIView      *_withdrawView;
    UITextField *_countTF;
    
    
    PayCountButton *_countSelectButton;
    
    //充值按钮
    UIButton    *_rechargeButton;
    
    //充值金额
    NSInteger   _rechargeCount;
    
    //全局按钮
    UIButton    *_operationButton;
    
}

@end
