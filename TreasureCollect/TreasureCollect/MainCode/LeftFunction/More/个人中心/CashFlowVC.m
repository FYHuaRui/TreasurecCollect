//
//  CashFlowVC.m
//  TreasureCollect
//
//  Created by 方圆华睿 on 2017/2/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CashFlowVC.h"
#import "CashFlowCell.h"

@interface CashFlowVC ()

@end

@implementation CashFlowVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self DaoHang];//设置导航栏
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];//主页面

    
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
- (void)returnClicked
{
    NSLogTC(@"返回按钮点击了");
    [self.navigationController popViewControllerAnimated:YES];
}

//主页面显示
- (void)initSubView
{
    int userId = 22;
    
    //添加TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    //TableView布局
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.bottom.right.equalTo(self.view).offset(0);
    }];
    
    //数据源
    self.arrayData = [NSMutableArray array];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,AmtIOSele];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [HttpTool post:url params:params success:^(id json) {
        self.arrayData = [json objectForKey:@"AmtIO"];
        NSLogTC(@"12312312312:%@",self.arrayData);
    } failure:^(NSError *error) {
        NSLogTC(@"获取验证码失败：%@",error);
    }];

}

#define mark - UITableViewDataSource
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
    
    NSDictionary *imageDic = [self.arrayData firstObject];
    NSLog(@"12312312312:%@",imageDic);
    
    if (self.arrayData && [self.arrayData count])
    {
        CashFlowCell *cashCell = [[CashFlowCell alloc] init];
        cashCell.ioType.text = [imageDic objectForKey:@"IOType"];
    }
    return cell;
}

#define mark - UITableViewDelegate
//每行cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
