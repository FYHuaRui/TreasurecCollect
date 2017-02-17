//
//  tradeVC.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "tradeVC.h"

@interface tradeVC ()

@end

@implementation tradeVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self DaoHang];//设置导航栏
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubView];//主页面
}

//导航栏
- (void)DaoHang
{
    self.title = @"交易明细";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,nil]];//修改标题颜色
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
- (void)returnClicked{
    NSLogTC(@"返回按钮点击了");
    [self.navigationController popViewControllerAnimated:YES];
}

//主页面显示
- (void)initSubView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"tradeCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"trade_Cell"];
    //    tradeDetailCell
    [self.tableView registerNib:[UINib nibWithNibName:@"tradeDetailCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"tradeDetail_Cell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.bottom.right.equalTo(self.view).offset(0);
    }];
    
    //数据源
    self.arrayData = [NSMutableArray array];
    _isDownArr = [NSMutableArray array];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Exchange_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    int userId = 22;
    [params setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [HttpTool post:url params:params success:^(id json) {
        
        NSLog(@"json:%@",json);
        self.arrayData = [json objectForKey:@"PosDetail"];
        for (int i = 0; i < self.arrayData.count; i ++) {
            
            [_isDownArr addObject:@"0"];
            
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLogTC(@"失败：%@",error);
    }];
    
}

#define mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.arrayData && [self.arrayData count])
    {
        return [self.arrayData count];
    }
    return 0;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *arrStr = [_isDownArr objectAtIndex:section];
    if ([arrStr isEqualToString:@"1"]) {
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = [self.arrayData objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        
        tradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trade_Cell"];
        if (cell == nil)
        {
            //添加一个自定义的Cell
            cell = [[tradeCell alloc] init];
        }
        
        NSString *selectStr = [_isDownArr objectAtIndex:indexPath.section];
        //修改图片方向
        if ([selectStr isEqualToString:@"0"]) {
            [cell.image setImage:[UIImage imageNamed:@"交易明细向下"]];
        }else{
            [cell.image setImage:[UIImage imageNamed:@"交易明细向上"]];
        }
        
        cell.timeLabel.text = [dic objectForKey:@"trdMth"];
        cell.accountLabel.text = [dic objectForKey:@"vBuyQty"];
        NSInteger cost = [[dic objectForKey:@"vGainAmt"] integerValue];
        cell.countLabel.text = [NSString stringWithFormat:@"%ld",cost];
        if (cost >= 0) {
            cell.isRaise.text = @"涨";
            cell.isRaise.backgroundColor = [UIColor redColor];
            cell.countLabel.textColor = [UIColor redColor];
        }else{
            cell.isRaise.text = @"跌";
            cell.isRaise.backgroundColor = [UIColor greenColor];
            cell.countLabel.textColor = [UIColor greenColor];
        }
        
        return cell;
        
    }else{
        
        tradeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tradeDetail_Cell"];
        if (cell == nil)
        {
            //添加一个自定义的Cell
            cell = [[tradeDetailCell alloc] init];
            
        }
        
        cell.beginCost.text = [dic objectForKey:@"vOpenPrice"];
        cell.overCost.text = [dic objectForKey:@"vClosePrice"];
        cell.beganTime.text = [dic objectForKey:@"openTm"];
        cell.overTime.text = [dic objectForKey:@"closeTm"];
        cell.buyType.text = [dic objectForKey:@"costType"];
        cell.payLabel.text = [[dic objectForKey:@"vCost"] stringValue];
        cell.poundageLabel.text = [[dic objectForKey:@"vFee"] stringValue];
        cell.overKind.text = [dic objectForKey:@"closeWay"];
        return cell;
        
    }
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }else{
        return 230;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    if (indexPath.row == 0) {
        
        //得到当前选中组号，并转换成字符串
        NSString *selectStr = [_isDownArr objectAtIndex:indexPath.section];
        
        //更新记录状态的数组
        _isDownArr = [NSMutableArray array];
        for (int i = 0; i < self.arrayData.count; i ++) {
            
            if (i != indexPath.section) {
                [_isDownArr addObject:@"0"];
            }else{
                if ([selectStr isEqualToString:@"0"]) {
                    [_isDownArr addObject:@"1"];
                }else{
                    [_isDownArr addObject:@"0"];
                }
            }
            
        }
        
        NSMutableIndexSet *idxSet = [[NSMutableIndexSet alloc] init];
        if (_lastSection.length > 0) {
            [idxSet addIndex:[_lastSection integerValue]];
        }
        
        [idxSet addIndex:indexPath.section];
        [tableView reloadSections:idxSet withRowAnimation:UITableViewRowAnimationFade];
        
        _lastSection = [NSString stringWithFormat:@"%ld",indexPath.section];
        
    }
    
}

@end
