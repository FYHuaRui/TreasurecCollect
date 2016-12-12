//
//  LeftMore.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LeftMore.h"

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
    aView.backgroundColor = [UIColor redColor];
    [self addSubview:aView];
    
    //添加Logo背景色
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aView.bounds.size.width, 40)];
    bView.backgroundColor = [UIColor colorFromHexRGB:@"B53D2F"];
    [self addSubview:bView];
    
    //添加一个软件Log
//    UIImageView *imageView = [[UIImageView alloc] init];
    
    //注册登录按钮
    UIView *cView = [[UIView alloc] initWithFrame:CGRectZero];
    cView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cView];
    
    //添加约束
    [cView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bView).offset(10);
        make.left.equalTo(bView).offset(100);
        make.right.equalTo(bView).offset(10);
        make.bottom.equalTo(bView).offset(10);
    }];
    
    //添加一个TableView
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self addSubview:self.tableView];
//    
//    //添加约束
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bView).offset(0);
//        make.left.equalTo(aView).offset(0);
//        make.right.equalTo(aView).offset(0);
//        make.bottom.equalTo(aView).offset(0);
//    }];
    
}

//#pragma mark - UITableViewDataSource
////tableView共有多少行
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 5;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"customcell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell)
//    {
//        //添加一个自定义的Cell
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor clearColor];
//    }
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate
////每行cell的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}
//
////选择
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    switch (indexPath.row)
//    {
//        case 0:
//            //
//            break;
//            
//        case 1:
//            //
//            break;
//            
//        case 2:
//            //
//            break;
//            
//        case 3:
//            //
//            break;
//            
//        case 4:
//            //
//            break;
//            
//        default:
//            break;
//    }
//}




@end
