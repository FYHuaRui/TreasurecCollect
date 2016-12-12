
//
//  RechargeController.m
//  TreasureCollect
//
//  Created by Apple on 2016/12/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RechargeController.h"

@interface RechargeController ()

@end

@implementation RechargeController

- (void)initNavbar{

    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = nil;
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30.f, 25.f)];
    leftButton.tag = 101;
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回"]
                          forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(NavAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44.f, 25.f)];
    rightButton.tag = 102;
    [rightButton setTitle:@"客服"
                 forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor darkGrayColor]
                      forState:UIControlStateNormal];
    [rightButton addTarget:self
                   action:@selector(NavAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)NavAction:(UIButton *)button{

    if (button.tag == 101) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        NSLogTC(@"要联系客服了");
        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    self.navigationController.navigationBar.hidden = NO;

    [self initNavbar];
    
    [self initViews];
    
}

- (void)initViews{
    
    //背景滚动试图
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight -kNavigationBarHeight)];
    _bgScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgScrollView];

    //top图片
    _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth * 140 / 375)];
    [_topImage setImage:[UIImage imageNamed:@"recharge_top"]];
    [_bgScrollView addSubview:_topImage];

    //资金余额
    _restLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _topImage.bottom, KScreenWidth, 44.f)];
    _restLabel.backgroundColor = [UIColor whiteColor];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:@"资金余额：1230.0元"];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,attributeString.length - 6)];
    _restLabel.attributedText = attributeString;
    _restLabel.font = [UIFont systemFontOfSize:14];
    _restLabel.textAlignment = NSTextAlignmentCenter;
    [_bgScrollView addSubview:_restLabel];
    
    //按钮灰线
    _bgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _restLabel.bottom, KScreenWidth, 3.f)];
    _bgLine.backgroundColor = [UIColor colorFromHexRGB:@"FBFBFB"];
    [_bgScrollView addSubview:_bgLine];
    
    //浮动线条
    _flowLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _restLabel.bottom, KScreenWidth / 2, 2.f)];
    _flowLine.backgroundColor = [UIColor colorFromHexRGB:@"4095EB"];
    [_bgScrollView addSubview:_flowLine];
    
    //选择支付类型按钮
    NSArray *titleArr = @[@"微信支付",@"银联支付"];
    for (int i = 0; i < titleArr.count; i ++) {
        
        PayButton *button = [[PayButton alloc] initWithFrame:CGRectMake(KScreenWidth / 2 * i, _bgLine.bottom, KScreenWidth / 2, 40.f)];
        button.topicTitle = titleArr[i];
        if (i == 0) {
            button.backgroundColor = [UIColor colorFromHexRGB:@"FBFBFB"];
        }else{
            button.backgroundColor = [UIColor whiteColor];
        }
        button.tag = 100 + i;
        [button addTarget:self
                   action:@selector(PayButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [_bgScrollView addSubview:button];
        
    }
    
    //提示label
    _selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, _bgLine.bottom + 44.f, KScreenWidth - 24.f, 40.f)];
    _selectLabel.backgroundColor = [UIColor whiteColor];
    _selectLabel.text = @"请选择充值金额(元)";
    _selectLabel.textColor = [UIColor lightGrayColor];
    _selectLabel.textAlignment = NSTextAlignmentLeft;
    _selectLabel.font = [UIFont systemFontOfSize:14];
    [_bgScrollView addSubview:_selectLabel];
    
    //选择金额
    NSArray *countArr = @[@"2000",@"500",@"300",@"100"];
    for (int i = 0; i < countArr.count; i ++) {
        
        int line = i / 3;
        int cloum = i % 3;
        PayCountButton *button = [[PayCountButton alloc] initWithFrame:CGRectMake((KScreenWidth - 30) / 3 * cloum + 12.f + 3 * cloum, _selectLabel.bottom + 4 + line * 35, (KScreenWidth - 30) / 3, 32.f)];
        button.layer.cornerRadius = 3.f;
        button.layer.masksToBounds = YES;
        [button setTitle:countArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor colorFromHexRGB:@"EEEEEE"]
                          forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorFromHexRGB:@"4095EB"]
                          forState:UIControlStateSelected];
        if (i == 0) {
            
            button.selected = YES;
            _countSelectButton = button;
            
        }else{
        
            button.selected = NO;
        
        }
        
        if (i == 1) {
        
            button.isHot = 1;
            
        }else{
        
            button.isHot = 0;
        }
        
        button.tag = 200 + i;
        [button addTarget:self
                   action:@selector(countSelectAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [_bgScrollView addSubview:button];
        
    }
    
    //充值按钮
    _rechargeButton = [[UIButton alloc] initWithFrame:CGRectMake(12.f, _selectLabel.bottom + 150.f, KScreenWidth - 24.f, 40)];
    [_rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    _rechargeButton.layer.cornerRadius = 3.f;
    _rechargeButton.layer.masksToBounds = YES;
    _rechargeButton.backgroundColor = [UIColor colorFromHexRGB:@"4095EB"];
    [_bgScrollView addSubview:_rechargeButton];
 
    //温馨提示
    _recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.f, _rechargeButton.bottom + 12.f, KScreenWidth - 32.f, 24.f)];
    _recommandLabel.text = @"温馨提示:";
    _recommandLabel.textColor = [UIColor blackColor];
    _recommandLabel.textAlignment = NSTextAlignmentLeft;
    _recommandLabel.font = [UIFont systemFontOfSize:15];
    [_bgScrollView addSubview:_recommandLabel];
    
    _recommandDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.f, _recommandLabel.bottom + 4.f, KScreenWidth - 32.f, 24.f)];
    _recommandDetailLabel.text = @"-每日上限5000元";
    _recommandDetailLabel.textColor = [UIColor lightGrayColor];
    _recommandDetailLabel.textAlignment = NSTextAlignmentLeft;
    _recommandDetailLabel.font = [UIFont systemFontOfSize:15];
    [_bgScrollView addSubview:_recommandDetailLabel];
    
    _bgScrollView.contentSize = CGSizeMake(KScreenWidth, _recommandDetailLabel.bottom + 32.f);

}

#pragma mark - 按钮事件
- (void)PayButtonAction:(PayButton *)button{

    if(button.tag == 100){
    
        [UIView animateWithDuration:0.5 animations:^{
            
            _flowLine.frame = CGRectMake(0, _restLabel.bottom, KScreenWidth / 2, 2.f);
            
        }];
        PayButton *unSelectbutton = [_bgScrollView viewWithTag:101];
        unSelectbutton.backgroundColor = [UIColor whiteColor];
        button.backgroundColor = [UIColor colorFromHexRGB:@"FBFBFB"];
        
    }else{
    
        [UIView animateWithDuration:0.5 animations:^{
            
            _flowLine.frame = CGRectMake(KScreenWidth / 2, _restLabel.bottom, KScreenWidth / 2, 2.f);
            
        }];
        PayButton *unSelectbutton = [_bgScrollView viewWithTag:100];
        unSelectbutton.backgroundColor = [UIColor whiteColor];
        button.backgroundColor = [UIColor colorFromHexRGB:@"FBFBFB"];
        
    }

}

- (void)countSelectAction:(PayCountButton *)button{

    button.selected = YES;
    
    _countSelectButton.selected = NO;
    
    _countSelectButton = button;

}

@end
