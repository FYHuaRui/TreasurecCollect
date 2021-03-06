//
//  HMViewController.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HMViewController.h"
#import "MyBuyViewController.h"

@interface HMViewController ()

@end

@implementation HMViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self Daohang];//导航栏设置
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self Daohang];//导航栏设置
    [self initSubViews];//主要内容
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//导航栏设置
- (void)Daohang
{
    self.title = @"合买大厅";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"2887ee"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = NO;
    
    //左侧返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回2"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(returnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //右侧联系客服
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"我的合买" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}


//主要内容
- (void)initSubViews
{
#if 0
    //显示现货产品价格
    UILabel *sLab = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth/4-25, 5, 50, 20)];
    sLab.text = @"白银";
    sLab.textAlignment = NSTextAlignmentCenter;
    sLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:sLab];
    
    UILabel *mLab = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth/4*3-25, sLab.frame.origin.y, 50, 20)];
    mLab.text = @"3.888";
    mLab.textAlignment = NSTextAlignmentCenter;
    mLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:mLab];
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, KScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    //滚动通知
    
#else
    
    //功能未开发
    UIImageView *underdevelopment = [[UIImageView alloc] init];
    underdevelopment.image = [UIImage imageNamed:@""];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:underdevelopment];
    
    //布局
    [underdevelopment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.bottom.right.equalTo(self.view).offset(0);
    }];
    
    //添加返回手势
    UITapGestureRecognizer *returnTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnClicked)];
    [underdevelopment addGestureRecognizer:returnTap];
    
#endif
    
}


//返回按钮
- (void)returnClicked
{
    NSLogTC(@"返回按钮点击了");
    [self.navigationController popViewControllerAnimated:YES];
}

//右侧栏按钮
- (void)rightBtnClicked
{
    NSLogTC(@"合买按钮点击了");
    MyBuyViewController *myBuyVC = [[MyBuyViewController alloc] init];
    [self.navigationController pushViewController:myBuyVC animated:YES];
    
}


@end
