//
//  SettingVC.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SettingVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "nickNameVC.h"
#import "HomeController.h"

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
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = nil;
    
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
    
    self.myHeadPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(enterImage.frame.origin.x-55, 12.5, 45, 45)];
    self.myHeadPortrait.image = [UIImage imageNamed:@"头像-登录状态"];
    //  把头像设置成圆形
    self.myHeadPortrait.layer.cornerRadius=self.myHeadPortrait.frame.size.width/2;
    self.myHeadPortrait.layer.masksToBounds=YES;
    //  给头像加一个圆形边框
    self.myHeadPortrait.layer.borderWidth = 1.5f;
    self.myHeadPortrait.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [hView addSubview:self.myHeadPortrait];
    
    self.tableView.tableHeaderView = headerView;
}

//修改头像手势响应事件
- (void)personalSetTap
{
    NSLogTC(@"设置图片");
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"修改头像"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
    [alertView addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            NSLogTC(@"当前设备不支持访问相册");
            return ;
        }
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
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSLogTC(@"当前设备不支持拍照");
            return ;
        }
        
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.mediaTypes = [NSArray arrayWithObject:(NSString*) kUTTypeImage];//设置媒体类型为静态图像
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertView animated:YES completion:^{
        
    }];
}


#pragma mark - UIImagePickerControllerDelegate
//相册或者拍照的回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        self.myHeadPortrait.image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        //判断是静态图像还是视屏
        if ([mediaType isEqualToString:(NSString*)kUTTypeImage])
        {
            UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
            self.myHeadPortrait.image = editedImage;//显示编辑后的图片
            
            
            if (picker.cameraDevice == UIImagePickerControllerCameraDeviceFront)
            {
                //前置拍的照片
//                self.myHeadPortrait.transform = CGAffineTransformIsIdentity;
                self.myHeadPortrait.transform = CGAffineTransformScale(picker.cameraViewTransform, -1, 1);
                
            }
            
            UIImageWriteToSavedPhotosAlbum(editedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }
    
    //隐藏图像选取控制器
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    //上传头像图片
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_MSG];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //隐藏图像选取控制器
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
 @功能：图像保存后的状态回调
 @参数：保存的图像 错误的信息 设备上下文
 @返回值：无
 */
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (!error)
    {
        NSLogTC(@"保存图像成功");
    }
    else
    {
        NSLogTC(@"图像保存失败：%@", [error localizedDescription]);
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
//                cell.detailTextLabel.text = @"3.1M";
                cell.detailTextLabel.text= [NSString stringWithFormat:@"%@", [self getCacheSize]];
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


#pragma mark - UITableViewDelegate
//设置每行表格的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

//选择表格视图某一行调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            nickNameVC *nickName = [[nickNameVC alloc] init];
            [self.navigationController pushViewController:nickName animated:YES];
        }
        
        if (indexPath.row == 1)
        {
            NSLogTC(@"清理缓存");
        }
    }
    
    if (indexPath.section == 1)
    {
        NSLogTC(@"退出登录");
        //子线程中保存用户数据，主线程放回首页
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //清理用户信息
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            BOOL isLogin = NO;
            [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];//同步本地数据
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //返回首页
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[HomeController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
            });
        });
        
    }
}


#pragma mark - 计算缓存大小
- (NSString *)getCacheSize
{
    //定义变量存储总的缓存大小
    long long sumSize = 0;

    //01.获取当前图片缓存路径
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];

    //02.创建文件管理对象
    NSFileManager *filemanager = [NSFileManager defaultManager];

    //获取当前缓存路径下的所有子路径
    NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    
    //遍历所有子文件
    for (NSString *subPath in subPaths) {
        //1）.拼接完整路径
        NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
        //2）.计算文件的大小
        long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
        //3）.加载到文件的大小
        sumSize += fileSize;
    }
    float size_m = sumSize/(1000*1000);
    return [NSString stringWithFormat:@"%.2fM",size_m];
}
    

@end
