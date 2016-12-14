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
    _redScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width / 2, self.height)];
    _redScrollView.backgroundColor = [UIColor clearColor];
    _redScrollView.showsVerticalScrollIndicator = NO;
    _redScrollView.showsHorizontalScrollIndicator = NO;
    _redScrollView.tag = 100;
    [self addSubview:_redScrollView];
    
    UIImage *redimage = [UIImage imageNamed:@"rightTrangle"];
    [self addImage:redimage
         ToSubview:_redScrollView];

    _redLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.f, 2.f, 72.f, self.height - 4.f)];
    _redLabel.text = [NSString stringWithFormat:@"买涨：%.0f%%",_proportionNum];
    _redLabel.textColor = [UIColor whiteColor];
    _redLabel.textAlignment = NSTextAlignmentLeft;
    _redLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:_redLabel];
    
    //买跌的比例视图
    _greenScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.width / 2, 0, self.width / 2, self.height)];
    _greenScrollView.backgroundColor = [UIColor clearColor];
    _greenScrollView.showsVerticalScrollIndicator = NO;
    _greenScrollView.showsHorizontalScrollIndicator = NO;
    _greenScrollView.tag = 101;
    [self addSubview:_greenScrollView];
    
    UIImage *greenimage = [UIImage imageNamed:@"leftTrangle"];
    [self addImage:greenimage
         ToSubview:_greenScrollView];
    
    _greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 74.f, 2.f, 72.f, self.height - 4.f)];
    _greenLabel.text = [NSString stringWithFormat:@"买跌：%.0f%%",_proportionNum];
    _greenLabel.textColor = [UIColor whiteColor];
    _greenLabel.textAlignment = NSTextAlignmentRight;
    _greenLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:_greenLabel];
    
//    if (!_timer) {
//        
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1
//                                                 repeats:YES
//                                                   block:^(NSTimer * _Nonnull timer) {
//                                                       
//                                                       CABasicAnimation *animation = [CABasicAnimation animation];
//                                                       animation.keyPath = @"position.x";
//                                                       //                                                       animation.fromValue = @0;
//                                                       //                                                       animation.toValue = @(_redScrollView.contentSize.width);
//                                                       animation.byValue = @20;
//                                                       animation.duration = 1;
//                                                       [_redScrollView.layer addAnimation:animation forKey:@"basic"];
//                                                       
//                                                       CGPoint redPoint = _redScrollView.contentOffset;
//                                                       redPoint.x -= 20.f;
//                                                       _redScrollView.contentOffset = redPoint;
//                                                       
//                                                       //                                                       [UIView animateKeyframesWithDuration:1
//                                                       //                                                                                      delay:0
//                                                       //                                                                                    options:UIViewKeyframeAnimationOptionCalculationModeLinear
//                                                       //                                                                                 animations:^{
//                                                       //
//                                                       //
//                                                       //                                                                                     CGPoint redPoint = _redScrollView.contentOffset;
//                                                       //                                                                                     redPoint.x -= 20.f;
//                                                       //                                                                                     _redScrollView.contentOffset = redPoint;
//                                                       //
//                                                       //                                                                                     CGPoint greenPoint = _greenScrollView.contentOffset;
//                                                       //                                                                                     greenPoint.x += 20.f;
//                                                       //                                                                                     _greenScrollView.contentOffset = greenPoint;
//                                                       //                                                                                     
//                                                       //                                                                                 } completion:^(BOOL finished) {
//                                                       //                                                                                     
//                                                       //                                                                                 }];
//                                                       
//                                                   }];
//        
//    }


}


//计算子视图的数量
- (void)addImage:(UIImage *)image ToSubview:(UIScrollView *)scrollView{

    for (UIImageView *imageView in scrollView.subviews) {
        [imageView removeFromSuperview];
    }
    CGSize imageSize = image.size;
    CGFloat imageProportion = imageSize.width / imageSize.height;
    CGFloat imageViewWidth = imageProportion * scrollView.height;
    NSInteger subViewCount = scrollView.width / imageViewWidth + 1;
    for (int i = 0 ; i < subViewCount; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * imageViewWidth, 0, imageViewWidth, self.height)];
        imageView.image = image;
        [scrollView addSubview:imageView];
        
    }
    scrollView.contentSize = CGSizeMake(imageViewWidth * subViewCount, self.height);

    if (scrollView.tag == 100) {
        
        scrollView.contentOffset = CGPointMake(imageViewWidth * subViewCount - scrollView.width, 0);
    
    }else{
    
        scrollView.contentOffset = CGPointMake(0, 0);
    
    }
    
}

- (void)setProportionNum:(float)proportionNum{

    if(_proportionNum != proportionNum){
    
        //根据大小判断,比例改变情况（谁增谁减少）
        if (proportionNum > _proportionNum) {
            
            [UIView animateWithDuration:1
                             animations:^{
                                 
                                 CGRect redFrame = _redScrollView.frame;
                                 redFrame.size.width = self.width  * proportionNum;
                                 _redScrollView.frame = redFrame;
                                 UIImage *redimage = [UIImage imageNamed:@"rightTrangle"];
                                 [self addImage:redimage
                                      ToSubview:_redScrollView];
                                 
                                 CGRect greenFrame = _greenScrollView.frame;
                                 greenFrame.origin.x =  greenFrame.origin.x + greenFrame.size.width - self.width * (1 - proportionNum);
                                 greenFrame.size.width = self.width * (1 - proportionNum);
                                 _greenScrollView.frame = greenFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 UIImage *greenimage = [UIImage imageNamed:@"leftTrangle"];
                                 [self addImage:greenimage
                                      ToSubview:_greenScrollView];
                                 
                             }];
            
            
        }else{
        
            [UIView animateWithDuration:1
                             animations:^{
                                 
                                 CGRect redFrame = _redScrollView.frame;
                                 redFrame.size.width = self.width  * proportionNum;
                                 _redScrollView.frame = redFrame;
                                 
                                 CGRect greenFrame = _greenScrollView.frame;
                                 greenFrame.origin.x =  greenFrame.origin.x + greenFrame.size.width - self.width * (1 - proportionNum);
                                 greenFrame.size.width = self.width * (1 - proportionNum);
                                 _greenScrollView.frame = greenFrame;
                                 UIImage *greenimage = [UIImage imageNamed:@"leftTrangle"];
                                 [self addImage:greenimage
                                      ToSubview:_greenScrollView];
                                 
                             } completion:^(BOOL finished) {
                                 
                                 UIImage *redimage = [UIImage imageNamed:@"rightTrangle"];
                                 [self addImage:redimage
                                      ToSubview:_redScrollView];
                                 
                             }];
            
        
        }
        
        _proportionNum = proportionNum;
        _redLabel.text = [NSString stringWithFormat:@"买涨：%.0f%%",_proportionNum * 100];
        _greenLabel.text = [NSString stringWithFormat:@"买跌：%.0f%%",(1-_proportionNum) * 100];
    
    }

}

@end
