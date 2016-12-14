//
//  SettingVC.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC ()

@end

@implementation SettingVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self DaoHang];//设置导航栏
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self DaoHang];//设置导航栏
    [self initSubView];//主页面显示
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//导航栏
- (void)DaoHang
{
    self.title = @"设置";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
}

//主页面显示
- (void)initSubView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//添加一个表尾视图，用来隐藏多余的分割线
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.bottom.equalTo(self.view).offset(0);
    }];
    
    self.arrayData = [NSArray array];
    
    NSArray *ary1 = [NSArray arrayWithObjects:@"修改昵称", @"清理缓存", nil];
    NSArray *ary2 = [NSArray arrayWithObjects:@"退出登录", nil];
    self.arrayData = [NSArray arrayWithObjects:ary1, ary2, nil];
    
    //添加TableView头
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, KScreenWidth, 70)];
    hView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:hView];
    
    //点击收回更多界面
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalSetTap)];
    [hView addGestureRecognizer:singleTap];
    
    UILabel *hLab = [[UILabel alloc] initWithFrame:CGRectMake(15, hView.center.y/2-20, 60, 40)];
    hLab.text = @"头像";
    [hView addSubview:hLab];
    
    UIImageView *enterImage = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth-27, hView.center.y/2, 15, 15)];
    enterImage.image = [UIImage imageNamed:@"进入"];
    [hView addSubview:enterImage];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(enterImage.frame.origin.x-55, 12.5, 45, 45)];
    headImage.image = [UIImage imageNamed:@"头像-登录状态"];
    [hView addSubview:headImage];
    
    self.tableView.tableHeaderView = headerView;
}

//xiu ga
- (void)personalSetTap
{
    NSLogTC(@"设置图片");
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"修改头像"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
    [alertView addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertView animated:YES completion:^{
        
    }];
}


//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.myHeadPortrait.image = newPhoto;
    [self dismissViewControllerAnimated:YES completion:nil];
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
        cell.backgroundColor = [UIColor whiteColor];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(cell.center.x-40, 5, 80, 30)];
        lab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lab.font = [UIFont systemFontOfSize:18];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor redColor];
        lab.tag = 1000;
        [cell.contentView addSubview:lab];
    }
    
    if (indexPath.section < [self.arrayData count])
    {
        
        NSArray *array = [self.arrayData objectAtIndex:indexPath.section];
//        cell.textLabel.text = [array objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        //设置cell附属样式
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.section == 0)
        {
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
            if (indexPath.row == 0)
            {
                cell.detailTextLabel.text = @"大象1231241241";
            }
            if (indexPath.row == 1)
            {
                cell.detailTextLabel.text = @"3.1M";
            }
        }
        
        if (indexPath.section == 1 && indexPath.row == 0)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            UILabel *logoutLab = [cell.contentView viewWithTag:1000];
            logoutLab.text = [array objectAtIndex:indexPath.row];
        }
    }
    return cell;
}

//设置每行表格的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
    

@end
