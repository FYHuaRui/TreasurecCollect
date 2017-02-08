//
//  HRLivePlayer.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HRLivePlayer.h"
#import "HRLiveCell.h"

@interface HRLivePlayer ()

@end

@implementation HRLivePlayer

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self Daohang];//导航栏设置
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self Daohang];//导航栏设置
    [self initSubViews];//主要内容
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//导航栏设置
- (void)Daohang
{
    self.title = @"直播大厅";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    //左侧返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
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


//主要内容
- (void)initSubViews
{
    //直播大厅头图片展示
    UIImageView *titleImage = [[UIImageView alloc] init];
    titleImage.image = [UIImage imageNamed:@"banner_Live"];
    titleImage.userInteractionEnabled = YES;
    [self.view addSubview:titleImage];
    
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.equalTo(self.view).offset(0);
        make.height.mas_offset(@120);
    }];
    
    //图片上添加响应手势
    UITapGestureRecognizer  *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetTapClicked:)];
    [titleImage addGestureRecognizer:titleTap];
    
    //直播列表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor cyanColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleImage.mas_bottom).offset(0);
        make.left.and.bottom.right.equalTo(self.view).offset(0);
    }];
    
    //初始化数据源
    self.aryData = [NSMutableArray array];
}

/*
 @功能：头图片首饰响应方法
 @参数：当前手势
 @返回值：无
 */
- (void)forgetTapClicked:(UITapGestureRecognizer*) tapGesture
{
    NSLogTC(@"图片点击了");
}


#pragma mark - UITableViewDataSource
//tableView每行显示的内容
- (HRLiveCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"customcell";
    HRLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[HRLiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor blackColor];
    }
    //使用自定义cell
    
    return cell;
}

//tableView的行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - UITableViewDelegate
//tableViewCell每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 200;
}

//选择表格视图某一行调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
