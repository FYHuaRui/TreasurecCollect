//
//  LeftMore.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LeftMore.h"
#import "LeftTableView.h"
#import "HMViewController.h"
#import "PersonalViewController.h"
#import "ShareTicketVC.h"
#import "AdviceVC.h"
#import "UnderStandVC.h"
#import "RegisterVC.h"

@implementation LeftMore


//初始化更多视图
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubViews];
    }
    return self;
}



//加载更多视图
- (void)initSubViews
{
    //添加一个底层的UIView
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 300)];
    aView.backgroundColor = [UIColor clearColor];
    aView.userInteractionEnabled = YES;
    [self addSubview:aView];
    
    //添加背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:aView.frame];
    imageView.image = [UIImage imageNamed:@"bg"];
    imageView.userInteractionEnabled = YES;
    [aView addSubview:imageView];
    
    //添加Logo背景色
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aView.bounds.size.width, 40)];
    bView.backgroundColor = [UIColor colorFromHexRGB:@"B53D2F"];
    [imageView addSubview:bView];
    
    //添加一个软件Log
//    UIImageView *imageView = [[UIImageView alloc] init];
    
    //判断用户是否登录
    BOOL Login = NO;
    if (Login)//未登录
    {
        UIImageView *LogImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        LogImage.image = [UIImage imageNamed:@"icon-logo"];
        [bView addSubview:LogImage];
        
        //设置按钮按钮
        UIView *setView = [[UIView alloc] initWithFrame:CGRectZero];
        setView.backgroundColor = [UIColor whiteColor];
        [bView addSubview:setView];
        
        //添加约束
        [setView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bView).offset(7);
            make.left.equalTo(bView).offset(70);
            make.right.equalTo(bView).offset(-7);
            make.bottom.equalTo(bView).offset(-7);
        }];
    }
    else
    {
        UIImageView *LogImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 24, 24)];
        LogImage.image = [UIImage imageNamed:@"头像"];
        [bView addSubview:LogImage];
        
        //注册登录按钮背景
        UIView *cView = [[UIView alloc] initWithFrame:CGRectZero];
        cView.backgroundColor = [UIColor whiteColor];
        [bView addSubview:cView];
        
        //添加约束
        [cView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bView).offset(7);
            make.left.equalTo(bView).offset(70);
            make.right.equalTo(bView).offset(-7);
            make.bottom.equalTo(bView).offset(-7);
        }];
        
        UIButton *zBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [zBtn setTitle:@"注册" forState:UIControlStateNormal];
        zBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        zBtn.backgroundColor = [UIColor colorFromHexRGB:@"f74236"];
        [zBtn addTarget:self action:@selector(zBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        zBtn.frame = CGRectZero;
        [cView addSubview:zBtn];
        
        UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dBtn setTitle:@"登录" forState:UIControlStateNormal];
        dBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        dBtn.backgroundColor = [UIColor colorFromHexRGB:@"f74236"];
        [dBtn addTarget:self action:@selector(dBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        dBtn.frame = CGRectZero;
        [cView addSubview:dBtn];
        
        [zBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cView.mas_centerY);
            make.left.equalTo(cView.mas_left).with.offset(1);
            make.right.equalTo(dBtn.mas_left).with.offset(-1);
            make.height.mas_equalTo(@23);
            make.width.equalTo(dBtn);
        }];
        [dBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cView.mas_centerY);
            make.left.equalTo(zBtn.mas_right).with.offset(1);
            make.right.equalTo(cView.mas_right).with.offset(-1);
            make.height.mas_equalTo(@23);
            make.width.equalTo(zBtn);
        }];
    }
    
    //添加一个TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 150, 210) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;//禁止tableView滚动
    self.tableView.userInteractionEnabled = YES;
    self.tableView.separatorStyle = NO;
    [self addSubview:self.tableView];
    
    //添加约束
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(imageView).offset(40);
//        make.left.equalTo(imageView).offset(0);
//        make.right.equalTo(imageView).offset(0);
//        make.bottom.equalTo(imageView).offset(60);
//    }];
    
    LeftTableView *table1 = [[LeftTableView alloc] initWithLeftView:[UIImage imageNamed:@"合买"] label:@"合买大厅"];
    LeftTableView *table2 = [[LeftTableView alloc] initWithLeftView:[UIImage imageNamed:@"个人中心"] label:@"个人中心"];
    LeftTableView *table3 = [[LeftTableView alloc] initWithLeftView:[UIImage imageNamed:@"券"] label:@"分享领券"];
    LeftTableView *table4 = [[LeftTableView alloc] initWithLeftView:[UIImage imageNamed:@"活动"] label:@"活动详情"];
    LeftTableView *table5 = [[LeftTableView alloc] initWithLeftView:[UIImage imageNamed:@"反馈"] label:@"建议反馈"];
    LeftTableView *table6 = [[LeftTableView alloc] initWithLeftView:[UIImage imageNamed:@"了解"] label:@"了解微胜宝"];
    
    self.arrayData = [NSArray arrayWithObjects:table1, table2, table3, table4, table5, table6, nil];
    
    //添加软件Log
    UIButton *logBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 260, 30, 30)];//120
    [logBtn addTarget:self action:@selector(logBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [logBtn setBackgroundImage:[UIImage imageNamed:@"icon-logo"] forState:UIControlStateNormal];
    [imageView addSubview:logBtn];
    
    UITapGestureRecognizer  *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logBtnClicked)];
    [aView addGestureRecognizer:moreTap];
    
}

//log图片点击事件
- (void)logBtnClicked
{
    NSLogTC(@"log点击了");
    if (self.hidden == NO)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

/*
 功能：响应注册按钮点击事件
 参数：无
 返回值：无
 */
- (void)zBtnClicked
{
    NSLogTC(@"注册按钮点击了");
    RegisterVC *registerVC = [[RegisterVC alloc] init];
    [[self viewController].navigationController pushViewController:registerVC animated:YES];
}

/*
 功能：响应登录按钮点击事件
 参数：无
 返回值：无
 */
- (void)dBtnClicked
{
    NSLogTC(@"登录按钮点击了");
}

#pragma mark - UITableViewDataSource
//tableView共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrayData && [self.arrayData count])
    {
        return [self.arrayData count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"customcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        //添加一个自定义的Cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor whiteColor];
    
    }
    
    if (self.arrayData && [self.arrayData count])
    {
        LeftTableView *tableView = [self.arrayData objectAtIndex:indexPath.row];
        cell.textLabel.text = tableView.content;
        cell.imageView.image = tableView.leftImage;
        
        //设置cell.imageview的宽高
        CGSize itemSize = CGSizeMake(20, 20);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return cell;
}

#pragma mark - UITableViewDelegate
//每行cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

//选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        HMViewController *hmVC = [[HMViewController alloc] init];
        [[self viewController].navigationController pushViewController:hmVC animated:YES];
    }
    
    if (indexPath.row == 1)
    {
        PersonalViewController *pVC = [[PersonalViewController alloc] init];
        [[self viewController].navigationController pushViewController:pVC animated:YES];
    }
    
    if (indexPath.row == 2)
    {
        ShareTicketVC *shareVC = [[ShareTicketVC alloc] init];
        [[self viewController].navigationController pushViewController:shareVC animated:YES];
    }
    
    if (indexPath.row == 3)
    {
        
    }
    
    if (indexPath.row == 4)
    {
        AdviceVC *adviceVC = [[AdviceVC alloc] init];
        [[self viewController].navigationController pushViewController:adviceVC animated:YES];
    }
    
    if (indexPath.row == 5)
    {
        UnderStandVC *underVC = [[UnderStandVC alloc] init];
        [[self viewController].navigationController pushViewController:underVC animated:YES];

    }
    
    //右侧View收回
    [self moreTapClicked];
}


#pragma mark - 单机手势相应事件
- (void)moreTapClicked
{
    if (self.hidden == NO)
    {
        NSLogTC(@"首页手势触发了");
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
    
}


//获取父视图的Controller
- (UIViewController *)viewController
{
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
