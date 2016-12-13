//
//  PersonalViewController.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self Daohang];//导航栏设置
    [self initSubViews];//主要内容
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//导航栏设置
- (void)Daohang
{
    self.title = @"我";
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"2887ee"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = nil;
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"2887ee"];
    
    //左侧返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回2"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(returnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //右侧联系客服
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"客服" forState:UIControlStateNormal];
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
    //数据源
    PersNSObject *table1 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"001"] label:@"交易明细" rightView:nil];
    PersNSObject *table2 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"002"] label:@"资金流水" rightView:nil];
    
    //显示银元券有多少张
    UILabel *sLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    int a = 1;
    sLab.textAlignment = NSTextAlignmentRight;
    sLab.text = [NSString stringWithFormat:@"%d张",a];
    PersNSObject *table3 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"003"] label:@"银元券" rightView:sLab];
    
    PersNSObject *table4 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"004"] label:@"重要提醒" rightView:nil];
    PersNSObject *table5 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"005"] label:@"建议反馈" rightView:nil];
    PersNSObject *table6 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"006"] label:@"我的合买" rightView:nil];
    
    //添加建仓确认开关
    UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    aSwitch.onTintColor = [UIColor greenColor];
    aSwitch.tintColor = [UIColor lightGrayColor];
    aSwitch.thumbTintColor = [UIColor whiteColor];
    aSwitch.on = YES;//开关打开
    PersNSObject *table7 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"007"] label:@"建仓确认" rightView:aSwitch];
    PersNSObject *table8 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"008"] label:@"一分钟了解" rightView:nil];
    
    NSArray *ary1 = [NSArray arrayWithObjects:table1, table2, table3, nil];
    NSArray *ary2 = [NSArray arrayWithObjects:table4, table5, nil];
    NSArray *ary3 = [NSArray arrayWithObjects:table6, nil];
    NSArray *ary4 = [NSArray arrayWithObjects:table7, nil];
    NSArray *ary5 = [NSArray arrayWithObjects:table8, nil];
    
    self.arrayData = [NSArray arrayWithObjects:ary1, ary2, ary3, ary4, ary5, nil];
    
    
    //添加一个TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];

    
    
    //添加TabView头
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 240)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    //个人登录信息
    UIView *pView = [[UIView alloc] initWithFrame:CGRectZero];
    pView.backgroundColor = [UIColor colorFromHexRGB:@"2887ee"];
    [headerView addSubview:pView];
    [pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.equalTo(headerView).offset(0);
        make.bottom.equalTo(headerView).offset(-70);
    }];

    //个人资产
    UILabel *aLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 150, 10)];
    aLab.font = [UIFont systemFontOfSize:12];
    aLab.text = @"个人资产（元）";
    [headerView addSubview:aLab];
    
    UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(aLab.frame.origin.x, aLab.frame.origin.y+aLab.frame.size.height+5, 100, 50)];
    moneyLab.text = @"55.55";
    moneyLab.textColor = [UIColor redColor];
    moneyLab.font = [UIFont systemFontOfSize:35];
    [headerView addSubview:moneyLab];
    
    self.tableView.tableHeaderView = headerView;
}

//左侧返回按钮响应事件
- (void)returnClicked
{
    NSLogTC(@"左侧返回按钮点击了");
//    [self.navigationController popViewControllerAnimated:YES];
}


//客服按钮响应事件
- (void)rightBtnClicked
{
    NSLogTC(@"联系客服");
}


//表格视图数据源委托
#pragma mark - UITableViewDataSource
//设置每一组的组视图
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    aView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    return aView;
}

//设置组视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

//表视图有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrayData count];
}

//设置表视图每一组由多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrayData && [self.arrayData count])
    {
        NSArray *ary = [self.arrayData objectAtIndex:section];
        if (ary && [ary count])
        {
            return [ary count];
        }
    }
    return 0;
}

//设置表视图每一行显示的内容
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    if (indexPath.section < [self.arrayData count])
    {
        NSArray *array = [self.arrayData objectAtIndex:indexPath.section];
        PersNSObject *tableCell = [array objectAtIndex:indexPath.row];
        cell.textLabel.text = tableCell.context;
        cell.imageView.image = tableCell.leftImage;
        
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //设置cell附属样式
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //设置cell.imageview的宽高
        CGSize itemSize = CGSizeMake(30, 30);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (indexPath.section == 0 && indexPath.row == 2)
        {
            //设置cell的附属图片
//            NSArray *array = [self.arrayData objectAtIndex:indexPath.section];
//            PPersNSObject *tableCell = [array objectAtIndex:indexPath.row];
            cell.accessoryView = tableCell.rightView;

        }
        
        if (indexPath.section == 3 && indexPath.row == 0)
        {
            cell.accessoryView = tableCell.rightView;
        }
        
    }
    return cell;
}

//设置每行表格的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



@end
