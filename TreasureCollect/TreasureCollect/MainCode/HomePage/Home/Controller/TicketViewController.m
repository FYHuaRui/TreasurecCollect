//
//  TicketViewController.m
//  TreasureCollect
//
//  Created by Apple on 2016/12/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TicketViewController.h"

@interface TicketViewController ()

@end

@implementation TicketViewController

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
    
}

- (void)NavAction:(UIButton *)button{
    
    if (button.tag == 101) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"银元券";
    self.navigationController.navigationBar.hidden = NO;
    
    [self initNavbar];
    
    [self initViews];
    
}

- (void)initViews{

    //top背景试图
    _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60.f)];
    _topBgView.backgroundColor = [UIColor colorFromHexRGB:@"EAEAEA"];
    [self.view addSubview:_topBgView];
    
    //选择栏
    NSArray *itemArr = @[@"8元(0)",@"80元(0)",@"200元(0)"];
    _segmentView = [[UISegmentedControl alloc] initWithItems:itemArr];
    _segmentView.frame = CGRectMake(12.f, 12.f, KScreenWidth - 24.f, 36.f);
    _segmentView.selectedSegmentIndex = 0;
    _segmentView.backgroundColor = [UIColor whiteColor];
    [_segmentView addTarget:self
                     action:@selector(segmentAction:)
           forControlEvents:UIControlEventValueChanged];
    [_topBgView addSubview:_segmentView];
    
    //没有银元券现实的东西
    _blackImage = [[UIImageView alloc] initWithFrame:CGRectMake(12.f, _topBgView.bottom + 12.f, KScreenWidth - 24.f, 80.f)];
    [_blackImage setImage:[UIImage imageNamed:@"ticktBlank"]];
    [self.view addSubview:_blackImage];
    
    _blackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _blackImage.bottom + 8.f, KScreenWidth, 24.f)];
    _blackLabel.text = @"您的银元券用光咯，赶紧去挣吧";
    _blackLabel.font = [UIFont systemFontOfSize:12];
    _blackLabel.textAlignment = NSTextAlignmentCenter;
    _blackLabel.textColor = [UIColor colorFromHexRGB:@"4E545D"];
    [self.view addSubview:_blackLabel];
                                                        
    
}

- (void)segmentAction:(UISegmentedControl *)control{

    NSLogTC(@"点击了第%ld个",control.selectedSegmentIndex);
    
    
}

@end
