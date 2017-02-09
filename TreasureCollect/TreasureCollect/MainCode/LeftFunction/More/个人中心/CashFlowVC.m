//
//  CashFlowVC.m
//  TreasureCollect
//
//  Created by 方圆华睿 on 2017/2/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CashFlowVC.h"

@interface CashFlowVC ()

@end

@implementation CashFlowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//导航栏
- (void)DaoHang
{
    self.title = @"资金流水";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    //左侧返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回-灰"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(returnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
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
    //添加TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    //TableView布局
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.bottom.right.equalTo(self.view).offset(0);
    }];
    
    //数据源
    self.arrayData = [NSMutableArray array];
    

}

#define mark - UITableViewDataSource
//tableView的行数

#define mark - UITableViewDelegate

@end
