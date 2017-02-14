//
//  PersonalViewController.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PersonalViewController.h"
#import "SettingVC.h"
#import "tradeVC.h"
#import "TicketViewController.h"
#import "ImportantVC.h"
#import "MyBuyViewController.h"
#import "CashFlowVC.h"
#import "LoginVC.h"//登录
#import "RechargeController.h"//充值
#import "RegisterVC.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController


//视图即将出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self Daohang];//导航栏设置
//    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"2887ee"];
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
    self.title = @"我";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];//修改标题颜色
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
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setTitle:@"客服" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    rightBtn.frame = CGRectMake(0, 0, 60, 30);
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
}


//主要内容
- (void)initSubViews
{
    //数据源
    PersNSObject *table1 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"交易明细"] label:@"交易明细" rightView:nil];
    PersNSObject *table2 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"资金流水"] label:@"资金流水" rightView:nil];
    
    //显示银元券有多少张
//    UILabel *sLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    int a = 1;
//    sLab.textAlignment = NSTextAlignmentRight;
//    sLab.text = [NSString stringWithFormat:@"%d张",a];
    PersNSObject *table3 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"银元券"] label:@"银元券" rightView:nil];
    
    PersNSObject *table4 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"重要提醒"] label:@"重要提醒" rightView:nil];
    PersNSObject *table5 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"建议反馈"] label:@"建议反馈" rightView:nil];
    PersNSObject *table6 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"我的合买"] label:@"我的合买" rightView:nil];
    
    //添加建仓确认开关
    UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    aSwitch.onTintColor = [UIColor greenColor];
    aSwitch.tintColor = [UIColor lightGrayColor];
    aSwitch.thumbTintColor = [UIColor whiteColor];
    aSwitch.on = YES;//开关打开
    PersNSObject *table7 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"建仓确认"] label:@"建仓确认" rightView:aSwitch];
    PersNSObject *table8 = [[PersNSObject alloc] initWithLeftView:[UIImage imageNamed:@"了解"] label:@"了解微胜宝" rightView:nil];
    
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
    headerView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    
    //个人登录信息
    UIView *pView = [[UIView alloc] initWithFrame:CGRectZero];
    pView.backgroundColor = [UIColor colorFromHexRGB:@"2887ee"];
    [headerView addSubview:pView];
    [pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.equalTo(headerView).offset(0);
        make.bottom.equalTo(headerView).offset(-70);
    }];
    
    //登录／提现
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(15, 110, KScreenWidth/2 - 20, 40);
//    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor colorFromHexRGB:@"00a6ff"];
    loginBtn.layer.cornerRadius = 3.0;
    [loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:loginBtn];
    
    //注册／充值
    UIButton *CzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CzBtn.frame = CGRectMake(self.view.center.x+10, loginBtn.frame.origin.y, loginBtn.frame.size.width, loginBtn.frame.size.height);
//    [CzBtn setTitle:@"注册" forState:UIControlStateNormal];
    [CzBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CzBtn.backgroundColor = [UIColor colorFromHexRGB:@"ffba00"];
    CzBtn.layer.cornerRadius = 3.0;
    [CzBtn addTarget:self action:@selector(CzBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:CzBtn];
    
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (isLogin)
    {
        UIView *personView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, 70)];
        personView.backgroundColor = [UIColor clearColor];
        [pView addSubview:personView];
        
        //点击收回更多界面
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalSetTap)];
        [personView addGestureRecognizer:singleTap];
        
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 70, 70)];
        headView.image = [UIImage imageNamed:@"头像-登录状态"];
        [personView addSubview:headView];
        
        //显示用户名Lab
        UILabel *userLab = [[UILabel alloc] initWithFrame:CGRectMake(headView.frame.origin.x+headView.frame.size.width+10, 10, KScreenWidth/2, 20)];
        userLab.text = @"大象adfadfadfa";
        userLab.textColor = [UIColor whiteColor];
        [personView addSubview:userLab];
        
        //显示用户手机号Lab
        UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(userLab.frame.origin.x, userLab.frame.origin.y+userLab.frame.size.height+10, userLab.frame.size.width, userLab.frame.size.height)];
        phoneLab.text = [NSString stringWithFormat:@"手机：%ld", 123123123123];
        phoneLab.font = [UIFont systemFontOfSize:12];
        phoneLab.textColor = [UIColor whiteColor];
        [personView addSubview:phoneLab];
        
        //显示箭头
        UIImageView *pointImage = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth-40, personView.frame.size.height/2-15, 20, 20)];
        pointImage.image = [UIImage imageNamed:@"返回3"];
        [personView addSubview:pointImage];
        
        [loginBtn setTitle:@"提现" forState:UIControlStateNormal];
        [CzBtn setTitle:@"充值" forState:UIControlStateNormal];
        
    }
    else
    {
        //添加未登录的图片
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-30, 20, 60, 60)];
        headImage.image = [UIImage imageNamed:@"未登录状态"];
        [pView addSubview:headImage];
        
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [CzBtn setTitle:@"注册" forState:UIControlStateNormal];
    }

    //个人资产
    UILabel *aLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 150, 10)];
    aLab.font = [UIFont systemFontOfSize:12];
    aLab.text = @"个人资产（元）";
    [headerView addSubview:aLab];
    
    //用户持仓／资金状态
    UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(aLab.frame.origin.x, aLab.frame.origin.y+aLab.frame.size.height+5, KScreenWidth, 50)];
    moneyLab.text = @"8888888";
    moneyLab.textColor = [UIColor redColor];
    moneyLab.font = [UIFont systemFontOfSize:35];
    [headerView addSubview:moneyLab];
    
    //持仓／资金查看切换按钮
    UIButton *ChangeBtn = [[UIButton alloc] init];
    [ChangeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView reloadData];
}

//左侧返回按钮响应事件
- (void)returnClicked
{
    NSLogTC(@"左侧返回按钮点击了");
    [self.navigationController popViewControllerAnimated:YES];
}


//客服按钮响应事件
- (void)rightBtnClicked
{
    NSLogTC(@"联系客服");
}

//单机头像的手势点击了
- (void)personalSetTap
{
    NSLogTC(@"添加头像按钮点击了");
    SettingVC *setVC = [[SettingVC alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
    
}

/**
 @功能：登录／提现按钮响应事件
 @参数：按钮本身
 @返回值：无
 */
- (void)loginBtnClicked:(UIButton*)button
{
    if ([button.titleLabel.text isEqualToString:@"登录"])
    {
        LoginVC *loginVC = [[LoginVC alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else
    {
        NSLogTC(@"提现，发钱啦，啦啦啦啦啦");
    }
}

/**
 @功能：注册／充值按钮响应事件
 @参数:按钮本身
 @返回值：无
 */
- (void)CzBtnClicked:(UIButton*)button
{
    if ([button.titleLabel.text isEqualToString:@"注册"])
    {
        RegisterVC *registerVC = [[RegisterVC alloc] init];
        [self.navigationController pushViewController:registerVC  animated:YES];
    }
    else
    {
        RechargeController *rechargeVC = [[RechargeController alloc] init];
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
//        cell = [[UITableViewCell alloc] init];
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
        CGSize itemSize = CGSizeMake(25, 25);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (indexPath.section == 0 && indexPath.row == 2)
        {
            cell.detailTextLabel.text = @"0张";
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        }
        
        if (indexPath.section == 3 && indexPath.row == 0)
        {
            cell.accessoryView = tableCell.rightView;
        }
    }
    return cell;
}


#pragma mark - UITableViewDelegate
//设置每行表格的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

//选择表格视图某一行调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.arrayData objectAtIndex:indexPath.section];
//    PersNSObject *tableCell = [array objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            tradeVC *tVC = [[tradeVC alloc] init];
            [self.navigationController pushViewController:tVC animated:YES];
        }
        
        if (indexPath.row == 1)
        {
            CashFlowVC *tVC = [[CashFlowVC alloc] init];
            [self.navigationController pushViewController:tVC animated:YES];
        }
        
        if (indexPath.row == 2)
        {
            TicketViewController *ticketVC = [[TicketViewController alloc] init];
            [self.navigationController pushViewController:ticketVC animated:YES];
        }
    }
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            ImportantVC *impVC = [[ImportantVC alloc] init];
            [self.navigationController pushViewController:impVC animated:YES];
        }
        
        if (indexPath.row == 1)
        {
            NSLogTC(@"建议反馈");
        }
    }
    
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        MyBuyViewController *myBuyVC = [[MyBuyViewController alloc] init];
        [self.navigationController pushViewController:myBuyVC animated:YES];
    }
}



@end
