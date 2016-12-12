//
//  PayButton.m
//  TreasureCollect
//
//  Created by Apple on 2016/12/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PayButton.h"

@implementation PayButton

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
    
    _topicImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 36.f, 8, 28.f, 24.f)];
    [self addSubview:_topicImage];
    
    _topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(_topicImage.right, 8, self.width / 2, 24.f)];
    _topicLabel.textColor = [UIColor colorFromHexRGB:@"000B2E"];
    [self addSubview:_topicLabel];

}

- (void)setTopicTitle:(NSString *)topicTitle{

    if (_topicTitle != topicTitle) {
        
        _topicTitle = topicTitle;
        [_topicImage setImage:[UIImage imageNamed:_topicTitle]];
        _topicLabel.text = _topicTitle;
        
    }
    
}

@end
