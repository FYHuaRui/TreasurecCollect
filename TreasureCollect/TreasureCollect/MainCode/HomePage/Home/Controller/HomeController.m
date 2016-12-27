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
//    //测试数据
//    {
//        _isShowFiveRecord = YES;
//        _stockId = @"88888888";
//        self.navigationItem.title = @"YY股(88888888)";
//    }
//
    [self initStockView];
    [self fetchData];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self stock_enterFullScreen:self.stock.containerView.gestureRecognizers.firstObject];
//    });
//    
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
    tap.numberOfTapsRequired = 2;
    [self.stock.containerView addGestureRecognizer:tap];
    
    [self.stock.containerView.subviews setValue:@0 forKey:@"userInteractionEnabled"];
    
    UIWebView *testWebView = [[UIWebView alloc] initWithFrame:self.stockContainerView.frame];
    testWebView.backgroundColor = [UIColor whiteColor];
    testWebView.scrollView.scrollEnabled = NO;
       testWebView.delegate=self;
       [self.view addSubview:testWebView];
       
       NSString *filePath = [[NSBundle mainBundle]pathForResource:@"kline" ofType:@"html"];
       NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
       [testWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
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

    //socket
    _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                              delegateQueue:dispatch_get_main_queue()];
    
    NSError *err;
    
    //socket连接
    [_asyncSocket connectToHost:@"43.254.148.72" onPort:9103 error:&err];
    
    if (err != nil)
        
    {
        
        NSLog(@"%@",err);
        
    }
    
}

- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port{
    
    NSLog(@"socket链接成功");
    [_asyncSocket readDataWithTimeout:-1 tag:0];
    
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSLog(@"收到数据了");
    
    
    Byte *testByte = (Byte *)[data bytes];
    
    for(int i=0;i<[data length];i++)
        
        printf("testByte = %d\n",testByte[i]);
    
    [self bytesplit2byte:testByte
                   begin:24
                   count:[data length] - 24];
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError*)err{
    
    NSLog(@"socket链接失败了");
    
}


-(void)bytesplit2byte:(Byte[])src begin:(NSInteger)begin count:(NSInteger)count{
    
    unsigned c = (int)count;
    uint8_t *bytes = malloc(sizeof(*bytes) * c);
    for (NSInteger i = begin; i < begin+count; i++){
        
        bytes[i-begin] = src[i];
        
    }
    
    NSData *newdata = [NSData dataWithBytes:bytes
                                     length:count];
    NSString *str = [[NSMutableString alloc] initWithData:newdata encoding:NSUTF8StringEncoding];
    
    NSData *stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:stringData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&jsonError];
    if (jsonError == nil) {
        
        NSLog(@"字典%@",dictionary);
        
        [AppServer Get:@"minute" params:nil success:^(NSDictionary *response) {
            NSMutableArray *array = [NSMutableArray array];
            
            if ([dictionary allKeys].count == 5) {
                
                //修改array；
                NSMutableArray *dataArr = [response[@"minutes"] mutableCopy];
                
                //构建新的数据
                NSMutableDictionary *dataDic = [[dataArr lastObject] mutableCopy];
                [dataArr removeObjectAtIndex:0];
                
                //id
                NSMutableString *idString = [dataDic objectForKey:@"id"];
                NSString *substring = [idString substringWithRange:NSMakeRange(7, idString.length - 7)];
                NSInteger subId = [substring integerValue];
                [idString stringByReplacingOccurrencesOfString:substring withString:[NSString stringWithFormat:@"%ld",subId + 1]];
                [dataDic setObject:idString forKey:@"id"];
                
                //minute
                NSInteger minute = [[dataDic objectForKey:@"minute"] integerValue];
                minute ++;
                [dataDic setObject:[NSNumber numberWithInteger:minute] forKey:@"price"];
                
                //随机上下浮动的数
                double nextValue = sin(CFAbsoluteTimeGetCurrent()) + ((double)rand()/(double)RAND_MAX);
                NSLogTC(@"看这里%f",nextValue);
                NSInteger isdouble = [[NSNumber numberWithDouble:nextValue] integerValue] % 2;
                
                //price
                float priceFloat = [[dictionary objectForKey:@"lastprice"] floatValue];
                [dataDic setObject:[NSNumber numberWithFloat:priceFloat * (287  + 0.5 *(isdouble - 1))] forKey:@"price"];
                
                //avgPrice
                float acgRiceFloat = [[dictionary objectForKey:@"result"] floatValue];
                [dataDic setObject:[NSNumber numberWithFloat:acgRiceFloat * (287  + 0.5 *(isdouble - 1))] forKey:@"avgPrice"];
                
                [dataArr addObject:dataDic];
                
                [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    YYTimeLineModel *model = [[YYTimeLineModel alloc]initWithDict:obj];
                    [array addObject: model];
                }];
                
                [self.stockDatadict setObject:array forKey:@"minutes"];
                [self.stock draw];
                
                NSMutableDictionary *responseDic = [response mutableCopy];
                [responseDic setObject:dataArr forKey:@"minutes"];
                
                [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"minuteData" ofType:@"plist"]];
                [responseDic writeToFile:[[NSBundle mainBundle] pathForResource:@"minuteData" ofType:@"plist"] atomically:YES];
                
            }
            
            _proportionView.proportionNum = 0.3;
            
        } fail:^(NSDictionary *info) {
            
        }];
        
        [_asyncSocket readDataWithTimeout:-1 tag:0];
        
    }else{
        
        NSLog(@"数据异常：%@ ",jsonError);
        [_asyncSocket readDataWithTimeout:-1 tag:0];
        
    }
    
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
    UITapGestureRecognizer  *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreTapClicked:)];
    [self.stock.containerView addGestureRecognizer:moreTap];
    
    //更多功能按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _leftButton.frame = CGRectMake(12.f, 28.f, 36.f, 36.f);
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"more"]
                           forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(MoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    
    //银元券
    _ticketButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _ticketButton.frame = CGRectMake(KScreenWidth - 140.f, 32.f, 28.f, 28.f);
    [_ticketButton setBackgroundImage: [UIImage imageNamed:@"ticket"]
                             forState:UIControlStateNormal];
    [_ticketButton addTarget:self
                        action:@selector(ticketAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ticketButton];
    
    _ticketCountButton =  [[UILabel alloc] initWithFrame:CGRectMake(_ticketButton.width * 7 / 10, 0, _ticketButton.width * 2 / 5, _ticketButton.height * 2 / 5)];
    _ticketCountButton.text = @"8";
    _ticketCountButton.backgroundColor = [UIColor colorFromHexRGB:@"E15747"];
    _ticketCountButton.textColor = [UIColor whiteColor];
    _ticketCountButton.font = [UIFont systemFontOfSize:8];
    _ticketCountButton.textAlignment = NSTextAlignmentCenter;
    _ticketCountButton.layer.cornerRadius = _ticketButton.height / 5;
    _ticketCountButton.layer.masksToBounds = YES;
    [_ticketButton addSubview:_ticketCountButton];
    
    //直播室
    _liveShowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _liveShowButton.frame = CGRectMake(KScreenWidth - 100.f, 32.f, 28.f, 28.f);
    [_liveShowButton setBackgroundImage:[UIImage imageNamed:@"liveShow"]
                               forState:UIControlStateNormal];
    [_liveShowButton addTarget:self
                      action:@selector(LiveShowAction:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_liveShowButton];
    
    _liveShowLabel =  [[UILabel alloc] initWithFrame:CGRectMake(_liveShowButton.width * 3 / 5, 0, _liveShowButton.width * 3 / 5, _liveShowButton.height * 2 / 5)];
    _liveShowLabel.text = @"直播";
    _liveShowLabel.backgroundColor = [UIColor colorFromHexRGB:@"E15747"];
    _liveShowLabel.textColor = [UIColor whiteColor];
    _liveShowLabel.font = [UIFont systemFontOfSize:7];
    _liveShowLabel.textAlignment = NSTextAlignmentCenter;
    _liveShowLabel.layer.cornerRadius = _liveShowButton.height / 5;
    _liveShowLabel.layer.masksToBounds = YES;
    [_liveShowButton addSubview:_liveShowLabel];
    
    //充值按钮
    _rechargeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _rechargeButton.frame = CGRectMake(KScreenWidth - 60.f, 32.f, 48.f, 28.f);
    _rechargeButton.layer.cornerRadius = 2;
    _rechargeButton.layer.masksToBounds = YES;
    [_rechargeButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
    _rechargeButton.backgroundColor = [UIColor colorFromHexRGB:@"E15747"];
    [_rechargeButton setTitle:@"充值"
                     forState:UIControlStateNormal];
    [_rechargeButton addTarget:self
                        action:@selector(rechargeAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rechargeButton];
    
    _assetsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftButton.right + 12.f, 28.f, _ticketButton.left - _leftButton.right - 24.f , 36.f)];
    _assetsLabel.numberOfLines = 2;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:@"80.00\n个人资产(元)"];
    //设置第二行字体颜色
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]
                            range:NSMakeRange(attributeString.length - 7,7)];
    //设置字体大小
    [attributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@ "Arial Rounded MT Bold"
                                                                            size:(14.0)]
                            range:NSMakeRange(0, attributeString.length - 7)];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]
                            range:NSMakeRange(attributeString.length - 7, 7)];
    _assetsLabel.attributedText = attributeString;
    _assetsLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_assetsLabel];
    
    //更多按钮展示界面
    self.leftMore = [[LeftMore alloc] initWithFrame:CGRectMake(-150, 20, 150, 300)];
    self.leftMore.hidden = YES;//先设置隐藏
    [self.view addSubview:self.leftMore];
    
    //选择器
    _countPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - 40, KScreenHeight - kNavigationBarHeight - 120.f, 80.f, 90.f)];
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
    
    _proportionView = [[ProportionView alloc] initWithFrame:CGRectMake(0, _stockContainerView.bottom + 10, KScreenWidth, 16.f)];
    _proportionView.backgroundColor = [UIColor yellowColor];
    _proportionView.userInteractionEnabled = NO;
    [self.view addSubview:_proportionView];
    
    //买入卖出按钮
    _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(12.f, _countPicker.top, _countPicker.left - 24.f, _countPicker.height)];
    _buyButton.tag = 300;
    _buyButton.layer.cornerRadius = 5.f;
    _buyButton.layer.masksToBounds = YES;
    [_buyButton setTitle:@"买涨" forState:UIControlStateNormal];
    _buyButton.backgroundColor = [UIColor colorFromHexRGB:@"E45141"];
    [_buyButton addTarget:self
                   action:@selector(BuyAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buyButton];
    
    UIImageView *redImage = [[UIImageView alloc] initWithFrame:CGRectMake(_buyButton.width / 2 - 8, 16.f, 16.f, 16.f)];
    [redImage setImage:[UIImage imageNamed:@"toptrangle"]];
    [_buyButton addSubview:redImage];
    
    _saleButton = [[UIButton alloc] initWithFrame:CGRectMake(_countPicker.right + 12.f, _countPicker.top, _countPicker.left - 24.f, _countPicker.height)];
    _saleButton.tag = 301;
    _saleButton.layer.cornerRadius = 5.f;
    _saleButton.layer.masksToBounds = YES;
    [_saleButton setTitle:@"买跌" forState:UIControlStateNormal];
    _saleButton.backgroundColor = [UIColor colorFromHexRGB:@"55BB72"];
    [_saleButton addTarget:self
                    action:@selector(BuyAction:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saleButton];
    
    UIImageView *greenImage = [[UIImageView alloc] initWithFrame:CGRectMake(_buyButton.width / 2 - 8, 16.f, 16.f, 16.f)];
    [greenImage setImage:[UIImage imageNamed:@"downtrangle"]];
    [_saleButton addSubview:greenImage];
    
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
- (void)moreTapClicked:(UITapGestureRecognizer*)gesture
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

#pragma mark - 按钮点击事件
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
    HRLivePlayer *livePlay = [[HRLivePlayer alloc] init];
    [self.navigationController pushViewController:livePlay animated:YES];

}

- (void)BuyAction:(UIButton *)button{
    
    if (button.tag == 300) {
    
        NSLogTC(@"买涨啦");
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,GETREGISTIMAGE_URL];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[NSNumber numberWithInt:0] forKey:@"regId"];
        [HttpTool post:url
                params:params
               success:^(id json) {
                   
                   NSArray *dataArr = [json objectForKey:@"strImgYzm"];
                   NSDictionary *imageDic = [dataArr firstObject];
                   NSString *imageString = [imageDic objectForKey:@"ImageYzm"];
                   NSData *imageData = [GTMBase64 decodeString:imageString];
                   UIImage *image = [UIImage imageWithData:imageData];
                   
               } failure:^(NSError *error) {
                   
               }];
        
    }else{
    
        NSLogTC(@"买跌啦");
        
    }
    
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
    
}

@end
