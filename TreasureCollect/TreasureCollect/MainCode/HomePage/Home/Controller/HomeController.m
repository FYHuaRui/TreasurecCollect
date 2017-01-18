//
//  HomeController.m
//  TreasureCollect
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HomeController.h"


@interface HomeController ()

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self fetchData];
    [self initViews];
}

/*******************************************股票数据源获取更新*********************************************/
/**
 网络获取K线数据
 */
- (void)fetchData {

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
        _dataView.dataDic = dictionary;
        
//        [AppServer Get:@"minute" params:nil success:^(NSDictionary *response) {
//            NSMutableArray *array = [NSMutableArray array];
//            
//            if ([dictionary allKeys].count == 5) {
//                
//                //修改array；
//                NSMutableArray *dataArr = [response[@"minutes"] mutableCopy];
//                
//                //构建新的数据
//                NSMutableDictionary *dataDic = [[dataArr lastObject] mutableCopy];
//                [dataArr removeObjectAtIndex:0];
//                
//                //id
//                NSMutableString *idString = [dataDic objectForKey:@"id"];
//                NSString *substring = [idString substringWithRange:NSMakeRange(7, idString.length - 7)];
//                NSInteger subId = [substring integerValue];
//                [idString stringByReplacingOccurrencesOfString:substring withString:[NSString stringWithFormat:@"%ld",subId + 1]];
//                [dataDic setObject:idString forKey:@"id"];
//                
//                //minute
//                NSInteger minute = [[dataDic objectForKey:@"minute"] integerValue];
//                minute ++;
//                [dataDic setObject:[NSNumber numberWithInteger:minute] forKey:@"price"];
//                
//                //随机上下浮动的数
//                double nextValue = sin(CFAbsoluteTimeGetCurrent()) + ((double)rand()/(double)RAND_MAX);
//                NSLogTC(@"看这里%f",nextValue);
//                NSInteger isdouble = [[NSNumber numberWithDouble:nextValue] integerValue] % 2;
//                
//                //price
//                float priceFloat = [[dictionary objectForKey:@"lastprice"] floatValue];
//                [dataDic setObject:[NSNumber numberWithFloat:priceFloat * (287  + 0.5 *(isdouble - 1))] forKey:@"price"];
//                
//                //avgPrice
//                float acgRiceFloat = [[dictionary objectForKey:@"result"] floatValue];
//                [dataDic setObject:[NSNumber numberWithFloat:acgRiceFloat * (287  + 0.5 *(isdouble - 1))] forKey:@"avgPrice"];
//                
//                [dataArr addObject:dataDic];
//                
//                [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    YYTimeLineModel *model = [[YYTimeLineModel alloc]initWithDict:obj];
//                    [array addObject: model];
//                }];
//                
//                [self.stockDatadict setObject:array forKey:@"minutes"];
//                [self.stock draw];
//                
//                NSMutableDictionary *responseDic = [response mutableCopy];
//                [responseDic setObject:dataArr forKey:@"minutes"];
//                
//                [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"minuteData" ofType:@"plist"]];
//                [responseDic writeToFile:[[NSBundle mainBundle] pathForResource:@"minuteData" ofType:@"plist"] atomically:YES];
//                
//            }
        

            
//        } fail:^(NSDictionary *info) {
//            
//        }];
        _proportionView.proportionNum = 0.3;
        [_asyncSocket readDataWithTimeout:-1 tag:0];
        
    }else{
        
        NSLog(@"数据异常：%@ ",jsonError);
        [_asyncSocket readDataWithTimeout:-1 tag:0];
        
    }
    
}


#pragma mark -底部控件
- (void)initViews{
    
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
    
    //选择器
    _titleArr = @[@"8",@"80",@"200",@"2000",@"银元券"];
    _countPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - 40, KScreenHeight - 124.f, 80.f, 90.f)];
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
    
    KlineModel *model = [KlineModel new];
    __weak HomeController *selfWeak = self;
    [model GetModelArray:^(NSArray *dataArray) {
        __strong HomeController *strongSelf = selfWeak;
        strongSelf.KlineModels = dataArray;
    }];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _leftButton.bottom + 66.f, KScreenWidth, _buyButton.top - 40.f - _leftButton.bottom - 72.f)];
    _lineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_lineView];
    
    _kline = [[KlineView alloc] initWithFrame:CGRectMake(0, 0, _lineView.width, _lineView.height) Delegate:self];
    _kline.ShowTrackingCross = YES;
    [_lineView addSubview:_kline];
    
    _lightingView = [[lightningView alloc] initWithFrame:CGRectMake(0, 0, _lineView.width, _lineView.height) Delegate:self];
    _lightingView.hidden = YES;
    [_lineView addSubview:_lightingView];
    
    _lineKindButton = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 64.f, _leftButton.bottom + 84.f,44.f, 24.f)];
    _lineKindButton.layer.cornerRadius = 3.f;
    _lineKindButton.layer.masksToBounds = YES;
    [_lineKindButton setTitle:@"五分图" forState:UIControlStateNormal];
    [_lineKindButton setTitle:@"闪电图" forState:UIControlStateSelected];
    _lineKindButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_lineKindButton setBackgroundColor:[UIColor redColor]
                               forState:UIControlStateNormal];
    [_lineKindButton setBackgroundColor:[UIColor redColor]
                               forState:UIControlStateSelected];
    [_lineKindButton addTarget:self
                        action:@selector(lineButtonAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lineKindButton];
    
    _dataView = [[DataView alloc] initWithFrame:CGRectMake(0, _leftButton.bottom + 2, KScreenWidth, 64.f)];
    _dataView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_dataView];
    
    //进度条
    UIImage *gifimage = [UIImage imageNamed:@"red01"];
    _proportionView = [[ProportionView alloc] initWithFrame:CGRectMake(0, _lineView.bottom , KScreenWidth, KScreenWidth * gifimage.size.height / gifimage.size.width)];
    _proportionView.backgroundColor = [UIColor yellowColor];
    _proportionView.userInteractionEnabled = NO;
    [self.view addSubview:_proportionView];
    
}

#pragma mark - k线视图切换
- (void)lineButtonAction:(UIButton *)button{

    if (button.selected == YES) {
        
        button.selected = NO;
        _kline.hidden = NO;
        _lightingView.hidden = YES;
        
    }else{
    
        button.selected = YES;
        _kline.hidden = YES;
        _lightingView.hidden = NO;
    
    }

}


#pragma mark - 更多功能
- (void)MoreButtonClicked:(UIButton*)button{
    
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
- (void)moreTapClicked:(UITapGestureRecognizer*)gesture{
    
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
        
    }else{
    
        NSLogTC(@"买跌啦");
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    
    //更多按钮展示界面
    self.leftMore = [[LeftMore alloc] initWithFrame:CGRectMake(-150, 20, 150, 300)];
    self.leftMore.hidden = YES;//先设置隐藏
    [self.view addSubview:self.leftMore];
    
    BOOL islogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];

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

#pragma mark - KlineDelegate
- (KlineModel *)LineView:(UIView *)view cellAtIndex:(NSInteger)index;{
    
    return [self.KlineModels objectAtIndex:index];
    
}


- (NSInteger)numberOfLineView:(UIView *)view{
    return self.KlineModels.count;
}

@end
