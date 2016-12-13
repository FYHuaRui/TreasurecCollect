//
//  HomeController.m
//  TreasureCollect
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HomeController.h"


@interface HomeController ()<YYStockDataSource>

/**
 K线数据源
 */
@property (strong, nonatomic) NSMutableDictionary *stockDatadict;
@property (copy, nonatomic) NSArray *stockDataKeyArray;
@property (copy, nonatomic) NSArray *stockTopBarTitleArray;
@property (strong, nonatomic) YYFiveRecordModel *fiveRecordModel;

@property (strong, nonatomic) YYStock *stock;
@property (nonatomic, assign) NSString *stockId;
@property (weak, nonatomic) UIView *fullScreenView;
@property (strong, nonatomic) IBOutlet UIView *stockContainerView;

/**
 是否显示五档图
 */
@property (assign, nonatomic) BOOL isShowFiveRecord;

//全屏K线控件
@property (strong, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockLatestPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockIncreasePercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockLatestUpdateTimeLabel;

@end

@implementation HomeController

- (instancetype)initWithStockId:(NSString *)stockId title:(NSString *)title isShowFiveRecord:(BOOL)isShowFiveRecord {
    self = [super init];
    if(self) {
        _isShowFiveRecord = isShowFiveRecord;
        _stockId = @"88888888";
        self.navigationItem.title = @"YY股(88888888)";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //测试数据
    {
        _isShowFiveRecord = YES;
        _stockId = @"88888888";
        self.navigationItem.title = @"YY股(88888888)";
    }
    
    [self initStockView];
    [self fetchData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stock_enterFullScreen:self.stock.containerView.gestureRecognizers.firstObject];
    });
    
    [self initViews];
}

- (void)initStockView {
    
    YYStock *stock = [[YYStock alloc]initWithFrame:self.stockContainerView.frame dataSource:self];
    _stock = stock;
    [self.stockContainerView addSubview:stock.mainView];
    [stock.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.stockContainerView);
    }];
    //添加单击监听
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stock_enterFullScreen:)];
    tap.numberOfTapsRequired = 1;
    [self.stock.containerView addGestureRecognizer:tap];
    
    [self.stock.containerView.subviews setValue:@0 forKey:@"userInteractionEnabled"];
    
}

/*******************************************股票数据源获取更新*********************************************/
/**
 网络获取K线数据
 */
- (void)fetchData {
    
    [AppServer Get:@"five" params:nil success:^(NSDictionary *response) {
        if (self.isShowFiveRecord) {
            self.fiveRecordModel = [[YYFiveRecordModel alloc]initWithDict:response[@"sshq"]];
            [self.stock draw];
        }
    } fail:^(NSDictionary *info) {
        
    }];
    
    [AppServer Get:@"day" params:nil success:^(NSDictionary *response) {
        NSMutableArray *array = [NSMutableArray array];
        [response[@"dayhqs"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YYLineDataModel *model = [[YYLineDataModel alloc]initWithDict:obj];
            [model updateMA:response[@"dayhqs"]];
            if (model.MA20 > 0) {
                [array addObject: model];
            }
        }];
        [self.stockDatadict setObject:array forKey:@"dayhqs"];
    } fail:^(NSDictionary *info) {
        
    }];
    
    [AppServer Get:@"minute" params:nil success:^(NSDictionary *response) {
        NSMutableArray *array = [NSMutableArray array];
        [response[@"minutes"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YYTimeLineModel *model = [[YYTimeLineModel alloc]initWithDict:obj];
            [array addObject: model];
        }];
        [self.stockDatadict setObject:array forKey:@"minutes"];
        [self.stock draw];
        
    } fail:^(NSDictionary *info) {
    }];
}


/*******************************************股票数据源代理*********************************************/
-(NSArray <NSString *> *) titleItemsOfStock:(YYStock *)stock {
    return self.stockTopBarTitleArray;
}

-(NSArray *) YYStock:(YYStock *)stock stockDatasOfIndex:(NSInteger)index {
    return index < self.stockDataKeyArray.count ? self.stockDatadict[self.stockDataKeyArray[index]] : nil;
}

-(YYStockType)stockTypeOfIndex:(NSInteger)index {
    return index == 0 ? YYStockTypeTimeLine : YYStockTypeLine;
}

- (id<YYStockFiveRecordProtocol>)fiveRecordModelOfIndex:(NSInteger)index {
    return self.fiveRecordModel;
}

- (BOOL)isShowfiveRecordModelOfIndex:(NSInteger)index {
    return self.isShowFiveRecord;
}


/*******************************************股票全屏*********************************************/
/**
 退出全屏
 */
- (IBAction)stock_exitFullScreen:(id)sender {
    
    [self.stock.containerView.subviews setValue:@0 forKeyPath:@"userInteractionEnabled"];
    
    UIView *snapView = [self.fullScreenView snapshotViewAfterScreenUpdates:NO];
    [self.fullScreenView addSubview:snapView];
    [snapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.fullScreenView);
    }];
    [self.stockContainerView addSubview:self.stock.mainView];
    [self.stock.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.stockContainerView);
    }];
    [self.stock draw];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.fullScreenView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.fullScreenView removeFromSuperview];
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.stock.containerView.gestureRecognizers.firstObject setEnabled:YES];
}

/**
 点击进入全屏
 */
- (void)stock_enterFullScreen:(UITapGestureRecognizer *)tap {
    
    [self.stock.containerView.subviews setValue:@1 forKeyPath:@"userInteractionEnabled"];
    tap.enabled = NO;
    
    UIView *fullScreenView = [[NSBundle mainBundle] loadNibNamed:@"YYStockFullScreenView" owner:self options:nil].firstObject;
    self.fullScreenView = fullScreenView;
    [self  updateStockFullScreenData];
    fullScreenView.backgroundColor = [UIColor YYStock_bgLineColor];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:fullScreenView];
    
    [fullScreenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(window.mas_height);
        make.height.equalTo(window.mas_width);
        make.center.equalTo(window);
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [fullScreenView addSubview:self.stock.mainView];
    [self.stock.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(fullScreenView);
        make.top.equalTo(fullScreenView).offset(66);
    }];
    fullScreenView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.stock draw];
    
}

/**
 更新全屏顶部数据
 */
- (void)updateStockFullScreenData {
    
    self.stockNameLabel.text = @"YY股票";
    self.stockIdLabel.text = @"88888888";
    self.stockLatestPriceLabel.text = @"1234.88";
    self.stockIncreasePercentLabel.text = @"+1.33   +1.54%";
    self.stockLatestUpdateTimeLabel.text = [NSString stringWithFormat:@"更新时间：2016-10-17 22:05:05"];
    
}

/*******************************************getter*********************************************/
- (NSMutableDictionary *)stockDatadict {
    if (!_stockDatadict) {
        _stockDatadict = [NSMutableDictionary dictionary];
    }
    return _stockDatadict;
}

- (NSArray *)stockDataKeyArray {
    if (!_stockDataKeyArray) {
        _stockDataKeyArray = @[@"minutes",@"dayhqs"];
    }
    return _stockDataKeyArray;
}

- (NSArray *)stockTopBarTitleArray {
    if (!_stockTopBarTitleArray) {
        _stockTopBarTitleArray = @[@"分时",@"日K"];
        //        _stockTopBarTitleArray = @[@"分时",@"日K",@"周K",@"月K"];
    }
    return _stockTopBarTitleArray;
}

- (NSString *)getToday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (void)dealloc {
    NSLog(@"DEALLOC");
}


#pragma mark -底部控件
- (void)initViews{
    
    //点击收回更多界面
//    UITapGestureRecognizer  *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreTapClicked)];
//    [self.view addGestureRecognizer:moreTap];
    
    //更多功能按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _leftButton.frame = CGRectMake(20.f, 12.f, 44.f, 24.f);
    [_leftButton setTitle:@"更多" forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(MoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    
    //充值按钮
    _rechargeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _rechargeButton.frame = CGRectMake(100.f, 12.f, 44.f, 24.f);
    [_rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [_rechargeButton addTarget:self
                        action:@selector(rechargeAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rechargeButton];
    
    //银元券
    _ticketButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _ticketButton.frame = CGRectMake(180.f, 12.f, 60.f, 24.f);
    [_ticketButton setTitle:@"银元券" forState:UIControlStateNormal];
    [_ticketButton addTarget:self
                        action:@selector(ticketAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ticketButton];
    
    //直播室
    _liveShowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _liveShowButton.frame = CGRectMake(260.f, 12.f, 60.f, 24.f);
    [_liveShowButton setTitle:@"直播室" forState:UIControlStateNormal];
    [_liveShowButton addTarget:self
                      action:@selector(LiveShowAction:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_liveShowButton];
    
    //更多按钮展示界面
    self.leftMore = [[LeftMore alloc] initWithFrame:CGRectMake(-150, 20, 150, 300)];
    self.leftMore.hidden = YES;//先设置隐藏
    [self.view addSubview:self.leftMore];
    
    //选择弃
    _countPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - 30, KScreenHeight - kNavigationBarHeight - 140.f, 80.f, 90.f)];
    _countPicker.backgroundColor = [UIColor colorFromHexRGB:@"E9E9E9"];
    _countPicker.dataSource = self;
    _countPicker.delegate = self;
    //设置圆角
    _countPicker.layer.borderColor = [[UIColor colorFromHexRGB:@"B5B5B5"] CGColor];
    _countPicker.layer.borderWidth = 5.f;
    _countPicker.layer.cornerRadius = 5.f;
    _countPicker.layer.masksToBounds = NO;
    //设置阴影
    _countPicker.layer.shadowOffset = CGSizeMake(0, -1);
    _countPicker.layer.shadowColor = [[UIColor blackColor] CGColor];
    _countPicker.layer.shadowRadius = 1.f;
    _countPicker.layer.shadowOpacity = 0.5;
    
    [self.view addSubview:_countPicker];
    
    [_countPicker reloadAllComponents];
    _titleArr = @[@"8",@"80",@"200",@"2000",@"银元券"];
    
//
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(12.f, KScreenHeight - kNavigationBarHeight - 12.f - KScreenWidth-kNavigationBarHeight-_stockContainerView.bottom - 24.f, KScreenWidth / 2 - 24.f, KScreenWidth-kNavigationBarHeight-_stockContainerView.bottom - 24.f)];
//    [button setTitle:@"买入" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor]
//                 forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:button];
//    
//    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth / 2 + 12.f, KScreenHeight - kNavigationBarHeight - 12.f - KScreenWidth-kNavigationBarHeight-_stockContainerView.bottom - 24.f, KScreenWidth / 2 - 24.f, KScreenWidth-kNavigationBarHeight-_stockContainerView.bottom - 24.f)];
//    [button2 setTitle:@"卖出" forState:UIControlStateNormal];
//    [button2 setTitleColor:[UIColor whiteColor]
//                 forState:UIControlStateNormal];
//    button2.backgroundColor = [UIColor redColor];
//    [self.view addSubview:button2];

}

#pragma mark - 更多功能
- (void)MoreButtonClicked:(UIButton*)button
{
    if (self.leftMore.hidden == YES)
    {
        self.leftMore.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.leftMore.transform = CGAffineTransformMakeTranslation(150, 0);
        }completion:^(BOOL finished) {
            
        }];
    }
    
    NSLogTC(@"更多按钮点击了");
}

#pragma mark - 单机手势相应事件
- (void)moreTapClicked
{
    if (self.leftMore.hidden == NO)
    {
        NSLogTC(@"首页手势触发了");
        [UIView animateWithDuration:0.3 animations:^{
            self.leftMore.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            self.leftMore.hidden = YES;
            }];
    }
    
}

#pragma mark - 充值事件
- (void)rechargeAction:(UIButton *)button{


    RechargeController *RVC = [[RechargeController alloc] init];
    [self.navigationController pushViewController:RVC
                                         animated:YES];
    
}

- (void)ticketAction:(UIButton *)button{

    TicketViewController *TVC = [[TicketViewController alloc] init];
    [self.navigationController pushViewController:TVC
                                         animated:YES];

}

- (void)LiveShowAction:(UIButton *)button{

    NSLogTC(@"要进入直播室了");

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;

}

#pragma mark - UIPickerDelegate,UIPickerDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return _titleArr.count;

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{

    return 30;

}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{

    return pickerView.width;

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    if (!view) {
        view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorFromHexRGB:@"F4F4F4"];
    }
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.width, 30.f)];
    text.textAlignment = NSTextAlignmentCenter;
    text.text = [_titleArr objectAtIndex:row];
    [view addSubview:text];
    
    return view;

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return _titleArr[0];

}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{

    NSString *str = [_titleArr objectAtIndex:row];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}
                              range:NSMakeRange(0, [attributedString length])];
    return attributedString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //选中栏上一栏3d旋转
    if (row != 0) {
        
        UIView *topView = [pickerView viewForRow:row - 1 forComponent:component];
        topView.layer.transform = CATransform3DIdentity;
        topView.layer.transform = CATransform3DMakeRotation(M_PI_4 / 2, 0, 1, 0);
        
    }
    
    //当前选中栏放大
    UIView *view = [pickerView viewForRow:row forComponent:component];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = transform;
    }];
    
    //选中栏下一栏3d旋转
    if (row != _titleArr.count) {
        
        UIView *bottomView = [pickerView viewForRow:row + 1 forComponent:component];
        bottomView.layer.transform = CATransform3DIdentity;
        bottomView.layer.transform = CATransform3DMakeRotation(- M_PI_4 / 2, 0, 1, 0);
        
    }
    
    NSLogTC(@"%ld,%@",row,_titleArr[row]);
    
}


@end
