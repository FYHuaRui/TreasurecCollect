
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

    _rechargeCount = 2000;
    
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
    
    //提示label
    _selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, _restLabel.bottom, KScreenWidth - 24.f, 40.f)];
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
    _rechargeButton = [[UIButton alloc] initWithFrame:CGRectMake(12.f, KScreenHeight - kNavigationBarHeight - 56.f, KScreenWidth - 24.f, 40)];
    [_rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    _rechargeButton.layer.cornerRadius = 5.f;
    _rechargeButton.layer.masksToBounds = YES;
    _rechargeButton.backgroundColor = [UIColor colorFromHexRGB:@"479FF6"];
    [_rechargeButton addTarget:self
                        action:@selector(rechargeAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:_rechargeButton];
    
    _bgScrollView.contentSize = CGSizeMake(KScreenWidth, _selectLabel.bottom + 180.f);

}

- (void)countSelectAction:(PayCountButton *)button{

    _rechargeCount = [button.titleLabel.text integerValue];
    
    button.selected = YES;
    
    _countSelectButton.selected = NO;
    
    _countSelectButton = button;

}

- (void)rechargeAction:(UIButton *)button{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                     message:[NSString stringWithFormat:@"你确定要充值%ld元",_rechargeCount]
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [alertVC dismissViewControllerAnimated:YES
                                                                                         completion:nil];
                                                             
                                                         }];
    
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             

                                                             NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,RECHARTE_URL];
                                                             NSMutableDictionary *params = [NSMutableDictionary dictionary];
                                                             [params setObject:[NSNumber numberWithInt:22] forKey:@"userId"];
                                                             NSString *rechargeKind = @"upacp";
                                                             [params setObject:rechargeKind forKey:@"channel"];
                                                             [params setObject:[NSNumber numberWithInteger:_rechargeCount * 100] forKey:@"amount"];
                                                             [params setObject:[NSString getIPAddress:YES] forKey:@"clientIp"];
                                                             
                                                             //请求第三方支付信息
                                                             [HttpTool post:url
                                                                     params:params
                                                                    success:^(id json) {
                                                                        
                                                                        NSLogTC(@"充值订单信息%@",json);
                                                                        
                                                                        NSLog(@"");
                                                                        [Pingpp createPayment:[json objectForKey:@"Charge"]
                                                                               viewController:self
                                                                                 appURLScheme:kUrlScheme
                                                                               withCompletion:^(NSString *result, PingppError *error) {
                                                                                   
                                                                                   NSLogTC(@"%@",result);
                                                                                   if ([result isEqualToString:@"success"]) {
                                                                                       // 支付成功
                                                                                   } else {
                                                                                       // 支付失败或取消
                                                                                       NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
                                                                                   }
                                                                                   
                                                                               }];
                                                                        
                                                                    } failure:^(NSError *error) {
                                                                        
                                                                        NSLogTC(@"充值失败:%@",error);
                                                                        
                                                                    }];

                                                         }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:ensureAction];
    [self presentViewController:alertVC
                       animated:YES
                     completion:^{
                         
                     }];

}

@end
