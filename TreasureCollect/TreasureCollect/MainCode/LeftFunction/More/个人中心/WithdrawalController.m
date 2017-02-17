//
//  WithdrawalController.m
//  TreasureCollect
//
//  Created by Apple on 2017/2/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "WithdrawalController.h"

@interface WithdrawalController ()

@end

@implementation WithdrawalController

- (void)initNavbar{
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];//修改标题颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"2887ee"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = nil;
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30.f, 25.f)];
    leftButton.tag = 101;
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回2"]
                          forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(NavAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)NavAction:(UIButton *)button{
    
    if (button.tag == 101) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"提现";
    
    _titleArr = @[@"请选择银行卡",@"",@"",@"请选择开卡省份",@"请选择开卡城市",@""];
    _placeHoldArr = @[@"",@"请输入银行卡号",@"请输入持卡姓名",@"",@"",@"请输入支行名称"];
    
    [self initNavbar];
    
    [self initViews];
    
}

- (void)initViews{

    //背景滚动试图
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight -kNavigationBarHeight)];
    _bgScrollView.backgroundColor = [UIColor colorFromHexRGB:@"F7F7F7"];
    [self.view addSubview:_bgScrollView];
    
    UITapGestureRecognizer  *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logBtnClicked)];
    [_bgScrollView addGestureRecognizer:moreTap];
    
    //top图片
    _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth * 140 / 375)];
    [_topImage setImage:[UIImage imageNamed:@"recharge_top"]];
    [_bgScrollView addSubview:_topImage];
    
    //提现金额
    _countView = [[UIView alloc] initWithFrame:CGRectMake(12, _topImage.bottom + 16.f, KScreenWidth - 24.f, 44.f)];
    _countView.backgroundColor = [UIColor whiteColor];
    [_bgScrollView addSubview:_countView];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.f, 8, 64.f, 28.f)];
    _countLabel.text = @"提现金额";
    _countLabel.textColor = [UIColor blackColor];
    _countLabel.font = [UIFont systemFontOfSize:14];
    [_countView addSubview:_countLabel];
    
    _countTF = [[UITextField alloc] initWithFrame:CGRectMake(72.f, 8.f, _countView.width - 80.f, 28.f)];
    _countTF.borderStyle = UITextBorderStyleNone;
    _countTF.placeholder = @"请输入提现金额";
    _countTF.font = [UIFont systemFontOfSize:14];
    _countTF.textAlignment = NSTextAlignmentRight;
    [_countView addSubview:_countTF];
    
    //提示
    _remaindLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, _countView.bottom + 4.f, KScreenWidth - 24.f, 44.f)];
    _remaindLabel.numberOfLines = 2;
    _remaindLabel.text = @"注:1.现金交易满100方可提现\n    2.提现金额小于100，将收取2元手续费";
    _remaindLabel.font = [UIFont systemFontOfSize:11];
    _remaindLabel.textAlignment = NSTextAlignmentLeft;
    [_bgScrollView addSubview:_remaindLabel];
    
    //银行卡信息表格
    _bankCardMsgTableView = [[UITableView alloc] initWithFrame:CGRectMake(12.f, _remaindLabel.bottom + 12.f, KScreenWidth - 24.f, 44 * 6)];
    _bankCardMsgTableView.delegate = self;
    _bankCardMsgTableView.dataSource = self;
    _bankCardMsgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bankCardMsgTableView.scrollEnabled = NO;
    [_bankCardMsgTableView registerClass:[WithDrwwalCell class]
                  forCellReuseIdentifier:@"WithDrwwalCell"];
    [_bgScrollView addSubview:_bankCardMsgTableView];
    
    //验证信息
    _validateView = [[UIView alloc] initWithFrame:CGRectMake(12.f, _bankCardMsgTableView.bottom + 12.f, KScreenWidth - 24.f, 44.f)];
    _validateView.backgroundColor = [UIColor whiteColor];
    [_bgScrollView addSubview:_validateView];
    
    _validateButton = [[UIButton alloc] initWithFrame:CGRectMake(_validateView.width - 92.f, 8.f, 84.f, 28.f)];
    _validateButton.backgroundColor = [UIColor whiteColor];
    _validateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_validateButton setTitle:@"获取验证码"
                     forState:UIControlStateNormal];
    [_validateButton setTitleColor:[UIColor colorFromHexRGB:@"5BAAE6"]
                          forState:UIControlStateNormal];
    [_validateView addSubview:_validateButton];
    
    _phoneNumTf = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, _validateView.width - 100.f, 28)];
    _phoneNumTf.borderStyle = UITextBorderStyleNone;
    _phoneNumTf.font = [UIFont systemFontOfSize:14];
    _phoneNumTf.textColor = [UIColor blackColor];
    _phoneNumTf.placeholder = @"请输入手机号码";
    [_validateView addSubview:_phoneNumTf];
    
    _validateInputView = [[UIView alloc] initWithFrame:CGRectMake(12.f, _validateView.bottom + 2.f, KScreenWidth - 24.f, 44.f)];
    _validateInputView.backgroundColor = [UIColor whiteColor];
    [_bgScrollView addSubview:_validateInputView];
    
    _validateTF = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, _validateInputView.width - 16.f, 28.f)];
    _validateTF.borderStyle = UITextBorderStyleNone;
    _validateTF.font = [UIFont systemFontOfSize:14];
    _validateTF.textColor = [UIColor blackColor];
    _validateTF.placeholder = @"请输入验证码";
    [_validateInputView addSubview:_validateTF];
    
    //小提示
    _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, _validateInputView.bottom + 4.f, KScreenWidth - 24.f, 44.f)];
    _remindLabel.numberOfLines = 1;
    _remindLabel.text = @"注:请务必确认所填信息的准确性，否则会影响正常提现";
    _remindLabel.font = [UIFont systemFontOfSize:11];
    _remindLabel.textAlignment = NSTextAlignmentLeft;
    [_bgScrollView addSubview:_remindLabel];
    
    //确认按钮
    _withdrawalButton = [[UIButton alloc] initWithFrame:CGRectMake(8, _remindLabel.bottom + 12.f, KScreenWidth - 16.f, 44.f)];
    _withdrawalButton.layer.cornerRadius = 5.f;
    _withdrawalButton.layer.masksToBounds = YES;
    _withdrawalButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_withdrawalButton setTitle:@"提现" forState:UIControlStateNormal];
    [_withdrawalButton setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
    [_withdrawalButton setBackgroundColor:[UIColor colorFromHexRGB:@"5BAAE6"]
                                 forState:UIControlStateNormal];
    _withdrawalButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_bgScrollView addSubview:_withdrawalButton];
    
}


#pragma mark- UITableViewDataSource
//tableView共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    WithDrwwalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WithDrwwal_Cell"];
    if (!cell) {
        
        cell = [[WithDrwwalCell alloc] init];
        
    }
    
    cell.cellTitle = _titleArr[indexPath.row];
    cell.cellPlaceHold = _placeHoldArr[indexPath.row];
    if (indexPath.row == 1) {
        cell.inputTF.keyboardType = UIKeyboardTypeNumberPad;
        
    }

    return cell;
    
}

#pragma mark - UITableViewDelegate
//每行cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 44;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];

}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    _bgScrollView.contentSize = CGSizeMake(KScreenWidth, _withdrawalButton.bottom + 12.f);
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboardWasShown:(NSNotification*)aNotification{
    
    //键盘高度
    
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _bgScrollView.height = KScreenHeight - kNavigationBarHeight - keyBoardFrame.size.height;
    
}


-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
    
    _bgScrollView.height = KScreenHeight - kNavigationBarHeight;
    
}

#pragma mark - 键盘收起事件
- (void)logBtnClicked{
    
        //提现金额输入
        if ([_countTF isFirstResponder]) {
    
            [_countTF resignFirstResponder];
    
        }
    
        //单元格里面的textfield
        WithDrwwalCell *cell1 = [_bankCardMsgTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if ([cell1.inputTF isFirstResponder]) {
    
            [cell1.inputTF resignFirstResponder];
    
        }
    
        WithDrwwalCell *cell2 = [_bankCardMsgTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        if ([cell2.inputTF isFirstResponder]) {
    
            [cell2.inputTF resignFirstResponder];
    
        }
    
        WithDrwwalCell *cell3 = [_bankCardMsgTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        if ([cell3.inputTF isFirstResponder]) {
            
            [cell3.inputTF resignFirstResponder];
            
        }

}


@end
