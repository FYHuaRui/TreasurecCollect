//
//  DataView.m
//  TreasureCollect
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "DataView.h"

@implementation DataView

- (instancetype)init{
    
    self = [super init ];
    if (self) {
        
        [self initViews];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame: frame];
    if (self) {
        
        [self initViews];
        
    }
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder: aDecoder];
    
    if (self) {
        
        [self initViews];
        
    }
    return self;
    
}

- (void)initViews{

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.f, 4.f, 60.f, 12.f)];
    _titleLabel.text = @"白银(元/克)";
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    _titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    
    _currentCount = [[UILabel alloc] initWithFrame:CGRectMake(8.f, _titleLabel.bottom , 88.f, 48.f)];
    _currentCount.font = [UIFont systemFontOfSize:32];
    _currentCount.text = @"- -";
    _currentCount.textColor = [UIColor whiteColor];
    [self addSubview:_currentCount];

    _upArr = @[[UIImage imageNamed:@"arrow_up_01"],
               [UIImage imageNamed:@"arrow_up_02"],
               [UIImage imageNamed:@"arrow_up_03"],
               [UIImage imageNamed:@"arrow_up_04"],
               [UIImage imageNamed:@"arrow_up_05"],
               [UIImage imageNamed:@"arrow_up_06"]];
    _downArr = @[[UIImage imageNamed:@"arrow_down_01"],
                 [UIImage imageNamed:@"arrow_down_02"],
                 [UIImage imageNamed:@"arrow_down_03"],
                 [UIImage imageNamed:@"arrow_down_04"],
                 [UIImage imageNamed:@"arrow_down_05"],
                 [UIImage imageNamed:@"arrow_down_06"]];
    
    _animationImage = [[UIImageView alloc] initWithFrame:CGRectMake(_currentCount.right, _titleLabel.bottom + 12, 20.f, 24.f)];
    _animationImage.backgroundColor = [UIColor clearColor];
    _animationImage.animationImages = _upArr;
    _animationImage.animationDuration = 1;
    [_animationImage startAnimating];
    [self addSubview:_animationImage];
    
    _tomorrowCount  = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 68.f,_titleLabel.bottom , 60.f, 24.f)];
    _tomorrowCount.font = [UIFont systemFontOfSize:11];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:@"昨收 3.456"];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3,attributeString.length - 4)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,3)];
    _tomorrowCount.attributedText = attributeString;
    [self addSubview:_tomorrowCount];
    
    _heightCount  = [[UILabel alloc] initWithFrame:CGRectMake(_tomorrowCount.left - 68.f,_titleLabel.bottom , 60.f, 24.f)];
//    _heightCount.textAlignment = NSTextAlignmentRight;
    _heightCount.font = [UIFont systemFontOfSize:11];
    NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc]initWithString:@"最高 3.236"];
    [attributeString2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,attributeString.length - 4)];
    [attributeString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,3)];
    _heightCount.attributedText = attributeString2;
    [self addSubview:_heightCount];
    
    _beginCount  = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 68.f,_tomorrowCount.bottom , 60.f, 24.f)];
//    _beginCount.textAlignment = NSTextAlignmentRight;
    _beginCount.font = [UIFont systemFontOfSize:11];
    NSMutableAttributedString *attributeString3 = [[NSMutableAttributedString alloc]initWithString:@"开盘 3.236"];
    [attributeString3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexRGB:@"53B972"] range:NSMakeRange(3,attributeString.length - 4)];
    [attributeString3 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,3)];
    _beginCount.attributedText = attributeString3;
    [self addSubview:_beginCount];
    
    _lowCount  = [[UILabel alloc] initWithFrame:CGRectMake(_tomorrowCount.left - 68.f,_tomorrowCount.bottom , 60.f, 24.f)];
//    _lowCount.textAlignment = NSTextAlignmentRight;
    _lowCount.font = [UIFont systemFontOfSize:11];
    NSMutableAttributedString *attributeString4 = [[NSMutableAttributedString alloc]initWithString:@"最低 3.236"];
    [attributeString4 addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexRGB:@"53B972"] range:NSMakeRange(3,attributeString.length - 4)];
    [attributeString4 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,3)];
    _lowCount.attributedText = attributeString4;
    [self addSubview:_lowCount];
    
}


#pragma mark - 重写方法
- (void)setDataDic:(NSDictionary *)dataDic{

    if (_dataDic != dataDic) {
        
        _dataDic = dataDic;
        if (![[dataDic objectForKey:@"lastprice"] isKindOfClass:[NSNull class]]) {
            
            _currentCount.text = [dataDic objectForKey:@"lastprice"];
            if (_oldDic != nil) {
                
                float oldValue = [[_oldDic objectForKey:@"lastprice"] floatValue];
                float newValue = [[_dataDic objectForKey:@"lastprice"] floatValue];
                if (oldValue > newValue) {
                    
                    //                _currentCount.textColor = [UIColor colorFromHexRGB:@"53B972"];
                    [_animationImage stopAnimating];
                    _animationImage.animationImages = _downArr;
                    [_animationImage startAnimating];
                    
                }else{
                    //
                    //                _currentCount.textColor = [UIColor colorFromHexRGB:@"E35040"];
                    [_animationImage stopAnimating];
                    _animationImage.animationImages = _upArr;
                    [_animationImage startAnimating];
                    
                }
                
            }else{
                
                _currentCount.textColor = [UIColor colorFromHexRGB:@"E35040"];
            }
            
        }
        
        _oldDic = dataDic;
        
        
    }

}

@end
