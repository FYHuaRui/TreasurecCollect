//
//  UnderStandVC.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UnderStandVC.h"

@interface UnderStandVC ()

@end

@implementation UnderStandVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self DaoHang];//设置导航栏
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self DaoHang];//设置导航栏
    [self initSubView];//主页面显示
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//导航栏
- (void)DaoHang
{
    self.title = @"了解发财";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    //左侧返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(returnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.view.backgroundColor = [UIColor whiteColor];
}

//返回按钮
- (void)returnClicked
{
    NSLogTC(@"返回按钮点击了");
    [self.navigationController popViewControllerAnimated:YES];
}


//主页面显示
- (void)initSubView
{
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kNavigationBarHeight)];
    _bgScrollView.backgroundColor = [UIColor lightGrayColor];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    
    UIImage *image = [UIImage imageNamed:@"一分钟了解微胜宝"];
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth * imageHeight / imageWidth)];
    imageView.image = image;
    [_bgScrollView addSubview:imageView];
    
    _bgScrollView.contentSize = CGSizeMake(KScreenWidth, KScreenWidth * imageHeight / imageWidth);
}

@end
