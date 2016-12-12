//
//  PayCountButton.m
//  TreasureCollect
//
//  Created by Apple on 2016/12/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PayCountButton.h"

@implementation PayCountButton

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

    _hotImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 24.f, 4.f, 20.f, 16.f)];
    [_hotImage setImage:[UIImage imageNamed:@"hot"]];
    _hotImage.hidden = YES;
    [self addSubview:_hotImage];

}

- (void)setIsHot:(NSInteger)isHot{

    if(_isHot != isHot){
    
        _isHot = isHot;
        if (isHot == 1) {
            _hotImage.hidden = NO;
        }else{
            _hotImage.hidden = YES;
        }
        
    }

}

@end
