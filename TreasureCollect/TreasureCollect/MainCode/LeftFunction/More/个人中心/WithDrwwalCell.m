//
//  WithDrwwalCell.m
//  TreasureCollect
//
//  Created by Apple on 2017/2/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "WithDrwwalCell.h"

@implementation WithDrwwalCell

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 16, 8.f, 12.f, 20.f)];
        [_rightImage setImage:[UIImage imageNamed:@"进入"]];
        [self.contentView addSubview:_rightImage];
        
        _bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(4.f, self.height - 1, self.width - 8, 1)];
        _bottomLine.backgroundColor = [UIColor colorFromHexRGB:@"F8F8F8"];
        [self.contentView addSubview:_bottomLine];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.hidden = NO;
        [self.contentView addSubview:_titleLabel];
        
        _inputTF = [[UITextField alloc] init];
        _inputTF.font = [UIFont systemFontOfSize:14];
        _inputTF.borderStyle = UITextBorderStyleNone;
        _inputTF.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_inputTF];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setCellTitle:(NSString *)cellTitle{

    if (cellTitle != _cellTitle) {
        
        _cellTitle = cellTitle;
        _titleLabel.text = _cellTitle;
        if (_cellPlaceHold.length <= 0) {
            
             _titleLabel.hidden = NO;
            _inputTF.hidden = YES;
            
        }
        
    }

}

- (void)setCellPlaceHold:(NSString *)cellPlaceHold{

    if (_cellPlaceHold != cellPlaceHold) {
        
        _cellPlaceHold = cellPlaceHold;
        if (_cellPlaceHold.length > 0) {
            
            _inputTF.placeholder = _cellPlaceHold;
            _titleLabel.hidden = YES;
            _inputTF.hidden = NO;
            _rightImage.hidden = YES;
            
        }

        
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{

    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(0, 0, KScreenWidth - 24.f, 44);
    self.selectedBackgroundView.frame = CGRectMake(0, 0, KScreenWidth - 24.f, 44);
    
    _rightImage.frame = CGRectMake(self.width - 16, 8.f, 12.f, 20.f);
    _bottomLine.frame = CGRectMake(4.f, self.height - 1, self.width - 8, 1);
    _titleLabel.frame = CGRectMake(8, 8, self.width - 24.f, 28.f);
    _inputTF.frame = CGRectMake(8, 8, self.width - 24.f, 28.f);
    
}

@end
