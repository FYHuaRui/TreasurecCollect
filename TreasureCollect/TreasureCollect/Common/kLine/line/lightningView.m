//
//  lightningView.m
//  TreasureCollect
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "lightningView.h"
#import "KlineModel.h"
#import "averagePriceLayer.h"


static const NSInteger KlineCellSpace = 2;//cell间隔
static const NSInteger KlineCellWidth = 6;//cell宽度
static const NSInteger CellOffset = 3;//偏移的单位（速度）

static const CGFloat scale_Min = 0.1;//最小缩放量
static const CGFloat scale_Max = 1;//最大缩放量


@interface lightningView()

@property (nonatomic, strong)CAShapeLayer *ShapeLayer;//父layer

@property (nonatomic, assign)NSInteger ShowArrayMaxCount;//展示的最大个数 保存这个最大值

@property (nonatomic, strong)UIPanGestureRecognizer *pan;//拖动手势
@property (nonatomic, strong)NSMutableArray *KlineShowArray;//保存k线图需要展示的数据

@property (nonatomic, assign)CGFloat ShowHeight;//保存这个view的高
@property (nonatomic, assign)CGFloat ShowWidth;//保存这个view的宽

@property (nonatomic, assign)CGFloat h;//view每个点代表的高度
@property (nonatomic, assign) NSInteger count;//view能容纳显示多少个


@property (nonatomic, assign)NSInteger OffsetIndex;//偏移量 记录数据下标开始的显示范围
@property (nonatomic, assign)CGFloat x_scale;//x坐标缩放的比例

@property (nonatomic, strong)CAShapeLayer *TrackingCrosslayer;//十字光标的layer层

@property (nonatomic, strong)UIColor *redColor;//红色 涨的蜡烛
@property (nonatomic, strong)UIColor *BlueColor;//蓝色 跌的蜡烛 偏绿色吧
@property (nonatomic, strong)UIColor *whiteColor;//白色 平的蜡烛

@property (nonatomic, strong)averagePriceLayer *APLayer;//均线的

@end

@implementation lightningView

#pragma mark- 基本设置
- (instancetype)initWithFrame:(CGRect)frame Delegate:(id<lineDataSource>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        //暂时不理会均线
        self.APLayer = [averagePriceLayer layer];
        self.APLayer.frame = self.bounds;
        self.backgroundColor = [UIColor blackColor];
        
        [self Kline_init];
    }
    return self;
}

- (void)Kline_init{
    
    self.KlineShowArray = [NSMutableArray new];
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:self.pan];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self addGestureRecognizer:pinch];
    
    self.redColor = [UIColor colorWithRed:227/255.0 green:81/255.0 blue:64/255.0 alpha:1];
    self.BlueColor = [UIColor colorWithRed:85/255.0 green:185/255.0 blue:114/255.0 alpha:1];
    self.whiteColor = [UIColor colorWithRed:208/255.0 green:120/255.0 blue:217/255.0 alpha:1];
    
    [self reload];
}

#pragma mark- 响应手势
- (void)panGesture:(UIPanGestureRecognizer *)pan{
    
    //十字光标开启 进入滑动显示对应的model数据
    if (self.isShowTrackingCross) {
        //记录初始点
        CGPoint point = [pan locationInView:pan.view];
        if (pan.state == UIGestureRecognizerStateChanged) {
            //移动十字光标
            [self TrackingCrossFromPoint:point];
        }else if(pan.state == UIGestureRecognizerStateEnded){
            //手指离开后 3秒后移除十字光标
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.ShowTrackingCross = NO;
            });
        }
    }else{
        //十字光标关闭 拉动显示图显示其它数据
        //判断左右移动
        CGPoint point = [pan translationInView:pan.view];
        //更改移动点
        [self offset_xPoint:point];
        
    }
}

//缩放
- (void)pinchAction:(UIPinchGestureRecognizer *)pinch{
    @synchronized (self) {
        //查看缩放比例
        self.x_scale *= pinch.scale;
        //调整比例
        if (_x_scale < scale_Min) {
            self.x_scale = scale_Min;
        }else if (_x_scale > scale_Max){
            self.x_scale = scale_Max;
        }
    }
    [self reload];
}

//重新绘制
- (void)reload{
    
    if ([self.delegate respondsToSelector:@selector(numberOfLineView:)]) {
        self.ShowArrayMaxCount = [self.delegate numberOfLineView:self];
    }
    self.ShowHeight = CGRectGetHeight(self.frame);
    self.ShowWidth = CGRectGetWidth(self.frame);
    
    if (!self.x_scale) {
        self.x_scale = 1;
    }
    //计算这个视图里面 能容纳多少个蜡烛图  宽度/(间隔＋单位蜡烛的宽度)*缩放的比例
    self.count = self.ShowWidth/((KlineCellSpace+KlineCellWidth)*self.x_scale);
    //计算现在是从哪一个下标开始取 总个数减去显示的个数
    NSInteger index = self.ShowArrayMaxCount - _count;
    
    if (index < 0) {
        index = 0;
    }
    self.OffsetIndex = index;//初始化偏移位置
    
    //开始绘图
    [self offsetNormal];
}

- (void)offsetNormal{
    
    [self offset_xPoint:CGPointMake(0, 0)];
    
}

//计算最高最低
- (void)CalculationHeightAndLowerFromArray:(NSArray *)array{
    
    _lowerPrice = 0;
    _heightPrice = 0;
    //遍历获取最高最低值
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KlineModel *model = obj;
        
        CGFloat HeighestFloat = MAX(model.HighestPrice, model.LastPrice);
        
        if (HeighestFloat > self.heightPrice) {
            _heightPrice = HeighestFloat;
        }
        
        if (self.lowerPrice == 0) {
            _lowerPrice = model.LowestPrice;
        }
        
        
        if (model.LowestPrice < self.lowerPrice || model.LastPrice < self.lowerPrice) {
            if (model.LastPrice > 0 && model.LowestPrice > 0) {
                _lowerPrice = MIN(model.LowestPrice, model.LastPrice);
            }
        }
    }];
    
    //调整比例
    _lowerPrice *= 1;
    _heightPrice *= 1;
    
    //
    [self CalculationH];
    
}

//计算每个点代表的值是多少
- (void)CalculationH{
    //将改变的值 放出去
    if ([self.delegate respondsToSelector:@selector(willReload)]) {
        [self.delegate willReload];
    }
    self.h = (self.heightPrice-self.lowerPrice)/self.ShowHeight;
    
    [self CalculationShowPointFromLastPrices:self.KlineShowArray];
    
    for(UIView *view in [self subviews]){
        [view removeFromSuperview];
    }
    
    //y标尺
    for (int i = 1 ; i <= 4 ; i ++) {
        
        CAShapeLayer *locationShapeLayer = [self getLocationYLine:i];
        [self.ShapeLayer addSublayer:locationShapeLayer];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 4 * i,self.frame.size.height / 12 * 11, 100.f, 16.f)];
        [self.KlineShowArray enumerateObjectsUsingBlock:^(KlineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx == self.KlineShowArray.count / 4 * i) {
                
                NSMutableString *timeStr = [model.CreateTime mutableCopy];
                timeStr = [timeStr substringWithRange:NSMakeRange(11, 5)];
                label.text = timeStr;
            }
            
        }];
        
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        
    }
    
    //x标尺
    for (int i = 0 ; i <= 5 ; i ++) {
        
        CAShapeLayer *locationShapeLayer = [self getLocationXLine:i];
        [self.ShapeLayer addSublayer:locationShapeLayer];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 12 + self.frame.size.height / 6 * i, 100.f, 16.f)];
        CGFloat avrageValue = (self.heightPrice - self.lowerPrice)/6;
        
        label.text = [NSString stringWithFormat:@"%.2f",self.lowerPrice + avrageValue * (6 - i - 0.5)];
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        
    }
    
}

//生成坐标
- (CAShapeLayer *)getLocationXLine:(int)index{
    
    //用贝塞尔描y轴路径
    UIBezierPath *linepath = [UIBezierPath bezierPath];
    [linepath moveToPoint:CGPointMake(0, self.frame.size.height / 12 + self.frame.size.height / 6 * index)];
    [linepath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height / 12 + self.frame.size.height / 6 * index)];
    
    //生成layer 用贝塞尔路径给他渲染
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = 0.5;
    lineLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.6].CGColor;
    lineLayer.path = linepath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    
    [linepath removeAllPoints];
    //返回y轴
    return lineLayer;
    
}

- (CAShapeLayer *)getLocationYLine:(int)index{
    
    //用贝塞尔描x轴路径
    UIBezierPath *linepath = [UIBezierPath bezierPath];
    [linepath moveToPoint:CGPointMake(-1 + self.frame.size.width / 4 * index, 0)];
    [linepath addLineToPoint:CGPointMake(-1 + self.frame.size.width / 4 * index, 20 + self.frame.size.height)];
    
    //生成layer 用贝塞尔路径给他渲染
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = 0.5;
    lineLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    lineLayer.path = linepath.CGPath;
    lineLayer.lineDashPattern = @[@2,@2];
    lineLayer.fillColor = nil; // 默认为blackColor
    
    [linepath removeAllPoints];
    //返回y轴
    return lineLayer;
    
}

//计算所有点位
- (void)CalculationShowPointFromLastPrices:(NSArray <KlineModel *>*)array{
    
    //重置ShapeLayer 父层
    [self initShapeLayer];
    //把这些层添加到这个view
    [self.layer addSublayer:self.ShapeLayer];
    [self.layer addSublayer:self.APLayer];
    
}

//替换以后一个点
- (void)replacementLastPoint:(KlineModel *)model{
    //如果父视图存在
    if (self.ShapeLayer) {
        //删除最后一个点
        NSArray *layerArray = self.ShapeLayer.sublayers;
        if (layerArray) {
            if (layerArray.count >0) {
                CAShapeLayer *Slayer = (CAShapeLayer *)[self.ShapeLayer.sublayers lastObject];
                [Slayer removeFromSuperlayer];
            }
        }
    }else{
        [self initShapeLayer];
    }

}

//滑动效果
- (void)offset_xPoint:(CGPoint)point{
    
    if ([self.delegate respondsToSelector:@selector(LineView:cellAtIndex:)]) {
        
        //计算偏移量
        if (point.x < 0) {
            self.OffsetIndex += CellOffset;
        }else if(point.x > 0){
            self.OffsetIndex -= CellOffset;
        }
        if (self.OffsetIndex < 0) {
            self.OffsetIndex = 0;
        }
        if (self.OffsetIndex > _ShowArrayMaxCount-_count) {
            self.OffsetIndex = _ShowArrayMaxCount-_count-1;
        }
        
        NSInteger index = self.OffsetIndex;
        
        if (index < 0) {
            index = 0;
        }
        
        //获取到对应的数据
        @synchronized (self) {
            [self.KlineShowArray removeAllObjects];
            NSInteger count = MIN(_count, _ShowArrayMaxCount);
            for (NSInteger i = 0; i<count; i++,index++) {
                KlineModel *model = [self.delegate LineView:self cellAtIndex:index];
                if (model) {
                    [self.KlineShowArray addObject:model];
                }
            }
        }
        
        //继续走流程
        [self CalculationHeightAndLowerFromArray:self.KlineShowArray];
        
        //均线的
        [self initAP];
        
    }
    
}

- (void)initAP{
    
    NSInteger APIndex = self.OffsetIndex-20;
    if (APIndex < 0) {
        APIndex = 0;
    }
    NSMutableArray *APArray = [NSMutableArray new];
    for (NSInteger i = APIndex; i<self.OffsetIndex;i++) {
        [APArray addObject:[self.delegate LineView:self cellAtIndex:i]];
    }
    [APArray addObjectsFromArray:self.KlineShowArray];
    
    self.APLayer.x_scale = self.x_scale;
    self.APLayer.lowerPrice = self.lowerPrice;
    self.APLayer.h = self.h;
    [self.APLayer loadLayerPreMigration:APArray.count-self.KlineShowArray.count KmodelArray:APArray];
    
}


#pragma mark- 十字光标
//十字光标
- (void)TrackingCrossFromPoint:(CGPoint)point{
    
    if (self.KlineShowArray.count == 0) {
        return;
    }
    //通过point逆推得出index 现在的下标/(单元大小)*缩放量
    NSInteger index = point.x/(KlineCellSpace+KlineCellWidth)*self.x_scale;
    //防止数组越界
    if (index > self.KlineShowArray.count-1) {
        index = self.KlineShowArray.count-1;
    }
    if (index < 0) {
        return;
    }
    //获得对应的model
    KlineModel *model = self.KlineShowArray[index];
    
    //获取x坐标 和这个model的最新价或者其它价格对应的y  这里展示最新价
    CGPoint point_X = CGPointMake(0, (model.LastPrice-self.lowerPrice)/self.h);
    CGPoint point_endX = CGPointMake(self.ShowWidth, (model.LastPrice-self.lowerPrice)/self.h);
    
    //绘图
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point_X];
    [path addLineToPoint:point_endX];
    
    
    CGPoint point_Y = CGPointMake(point.x, 0);
    CGPoint point_endY = CGPointMake(point.x, self.ShowHeight);
    
    [path moveToPoint:point_Y];
    [path addLineToPoint:point_endY];
    
    path.lineWidth = 0.75;
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    
    //展示十字光标
    self.TrackingCrosslayer.path = nil;
    
    if (!self.TrackingCrosslayer) {
        
        self.TrackingCrosslayer = [CAShapeLayer layer];
        self.TrackingCrosslayer.frame = CGRectMake(0, 0, self.ShowWidth, self.ShowHeight);
        self.TrackingCrosslayer.strokeColor = [UIColor colorWithRed:40/255.0 green:135/255.0 blue:255/255.0 alpha:1].CGColor;
        self.TrackingCrosslayer.fillColor = [UIColor clearColor].CGColor;
        
    }
    
    self.TrackingCrosslayer.path = path.CGPath;
    
    [self.layer addSublayer:self.TrackingCrosslayer];
    //把值传递给外界
    if ([self.delegate respondsToSelector:@selector(TrackingCrossIndexModel:IndexPoint:)]) {
        [self.delegate TrackingCrossIndexModel:model IndexPoint:CGPointMake(point_X.y, point_Y.x)];
    }
    
}

- (void)initShapeLayer{
    
    if (self.ShapeLayer) {
        
        [self.ShapeLayer removeFromSuperlayer];
        self.ShapeLayer = nil;
        
    }
    
    if (self.ShapeLayer == nil) {
        
        self.ShapeLayer = [CAShapeLayer layer];
        self.ShapeLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.ShapeLayer.strokeColor = [UIColor colorWithRed:40/255.0 green:135/255.0 blue:255/255.0 alpha:1].CGColor;
        self.ShapeLayer.fillColor = [UIColor clearColor].CGColor;
        
    }
    
}

//隐藏十字光标
- (void)setShowTrackingCross:(BOOL)ShowTrackingCross{
    
    _ShowTrackingCross = ShowTrackingCross;
    if (ShowTrackingCross) {
        CGPoint centerPoint = self.center;
        [self TrackingCrossFromPoint:centerPoint];
    }else{
        if (self.TrackingCrosslayer) {
            [self.TrackingCrosslayer removeFromSuperlayer];
        }
    }
    
}


@end

