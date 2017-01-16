//
//  ProportionView.m
//  TreasureCollect
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ProportionView.h"

@implementation ProportionView

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
    
    //买涨的比例视图
    
    _redImage = [[UIImageView alloc] initWithFrame:CGRectMake( -self.width / 2, 0, self.width, self.height)];
    [self addSubview:_redImage];
    _redImage.animationImages = @[[UIImage imageNamed:@"red01"],[UIImage imageNamed:@"red02"],[UIImage imageNamed:@"red03"],[UIImage imageNamed:@"red04"],[UIImage imageNamed:@"red05"],[UIImage imageNamed:@"red06"],[UIImage imageNamed:@"red07"],[UIImage imageNamed:@"red08"]];
    _redImage.animationDuration = 0.5;
    _redImage.animationRepeatCount = 0;
    [_redImage startAnimating];
    _redImage.backgroundColor = [UIColor colorFromHexRGB:@"C93723"];

    _redLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.f, 2.f, 72.f, self.height - 4.f)];
    _redLabel.text = @"买涨：50%";
    _redLabel.textColor = [UIColor whiteColor];
    _redLabel.textAlignment = NSTextAlignmentLeft;
    _redLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:11];
    [self addSubview:_redLabel];
    
    //买跌的比例视图
    _greenImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2, 0, self.width , self.height)];
        [self addSubview:_greenImage];
    _greenImage.animationImages = @[[UIImage imageNamed:@"green01"],[UIImage imageNamed:@"green02"],[UIImage imageNamed:@"green03"],[UIImage imageNamed:@"green04"],[UIImage imageNamed:@"green05"],[UIImage imageNamed:@"green06"],[UIImage imageNamed:@"green07"],[UIImage imageNamed:@"green08"]];
    _greenImage.animationDuration = 0.5;
    _greenImage.animationRepeatCount = 0;
    [_greenImage startAnimating];
    _greenImage.backgroundColor = [UIColor colorFromHexRGB:@"75BA7F"];
    
    _greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 74.f, 2.f, 72.f, self.height - 4.f)];
    _greenLabel.text = @"买跌：50%";
    _greenLabel.textColor = [UIColor whiteColor];
    _greenLabel.textAlignment = NSTextAlignmentRight;
    _greenLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    [self addSubview:_greenLabel];
    

}


- (void)setProportionNum:(float)proportionNum{

    if(_proportionNum != proportionNum){
    
        //根据大小判断,比例改变情况（谁增谁减少）
        [UIView animateWithDuration:1
                         animations:^{
                             
                             CGRect redFrame = _redImage.frame;
                             redFrame.origin.x = self.width  * proportionNum - self.width;
                             _redImage.frame = redFrame;
                             
                             CGRect greenFrame = _greenImage.frame;
                             greenFrame.origin.x = self.width * proportionNum;
                             _greenImage.frame = greenFrame;
                             
                         } completion:^(BOOL finished) {
                             
                             
                         }];
        
        if (proportionNum > _proportionNum) {
            
        }else{
        

            
        
        }
        
        _proportionNum = proportionNum;
        _redLabel.text = [NSString stringWithFormat:@"买涨：%.0f%%",_proportionNum * 100];
        _greenLabel.text = [NSString stringWithFormat:@"买跌：%.0f%%",(1-_proportionNum) * 100];
    
    }

}

@end
