//
//  AdvertiseView.m
//  TreasureCollect
//
//  Created by Apple on 2016/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AdvertiseView.h"

@implementation AdvertiseView

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

    self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    
    _advertiseView = [[UIScrollView alloc] initWithFrame:CGRectMake(36.f, 100.f, KScreenWidth - 72.f, 220.f)];
    _advertiseView.backgroundColor = [UIColor blackColor];
    _advertiseView.pagingEnabled = YES;
    _advertiseView.delegate = self;
    _advertiseView.contentSize = CGSizeMake((KScreenWidth - 72.f) * 5, 200.f);
    _advertiseView.showsHorizontalScrollIndicator = NO;
    _advertiseView.showsVerticalScrollIndicator = NO;
    [self addSubview:_advertiseView];
    
    for (int i = 0; i < 5; i ++) {
        
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 72.f) * i, 0, (KScreenWidth - 72.f),  200.f)];
        [imageButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"AD%d",i]]
                                                   forState:UIControlStateNormal];
        imageButton.tag = 10 + i;
        [imageButton addTarget:self
                        action:@selector(imageClick:)
              forControlEvents:UIControlEventTouchUpInside];
        [_advertiseView addSubview:imageButton];
        
    }
    
    _control = [[UIPageControl alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - 50.f, 300 , 100.f, 12.f)];
    _control.numberOfPages = 5;
    _control.currentPage = 0;
    _control.pageIndicatorTintColor = [UIColor colorFromHexRGB:@"AAAAAA"];
    _control.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_control];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTagAction:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    
}

- (void)imageClick:(UIButton *)button{

    NSLogTC(@"buttonTag:%ld",button.tag);

}

- (void)singleTagAction:(UITapGestureRecognizer *)singletap{

    [self removeFromSuperview];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.width;
    
    if(page != _control.currentPage)
    {
        _control.currentPage = page;
    };
}

@end
