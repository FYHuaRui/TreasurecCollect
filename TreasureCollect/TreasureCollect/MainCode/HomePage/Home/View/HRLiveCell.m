//
//  HRLiveCell.m
//  TreasureCollect
//
//  Created by 方圆华睿 on 2017/1/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HRLiveCell.h"

@implementation HRLiveCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initSubView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
 @功能:自定义cell
 @参数：暂无
 @返回值：无
 */
- (void)initSubView
{
    //直播简略图
    self.liveImage = [UIImage imageNamed:@""];
    UIImageView *liveImgView = [[UIImageView alloc] init];
    liveImgView.image = self.liveImage;
    [self.contentView addSubview:liveImgView];
    
    [liveImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(0);
    }];
    
    
    //直播人头像
    self.liverImage = [UIImage imageNamed:@""];
    UIImageView *liverImgView = [[UIImageView alloc] init];
    liverImgView.image = self.liverImage;
    [self.contentView addSubview:liverImgView];
    
    [liverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(liverImgView).offset(5);
    }];
    
    
    //直播人姓名
    self.nameLab = [[UILabel alloc] init];
    self.nameLab.textColor = [UIColor whiteColor];
    self.nameLab.text = @"齐天大圣";
    self.nameLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.nameLab];
    
    //直播内容简介
    self.messageLab = [[UILabel alloc] init];
    self.messageLab.text = @"打闹天空";
    self.messageLab.textColor = [UIColor whiteColor];
    self.messageLab.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.messageLab];
    
    //观看人数
    self.usersLab = [[UILabel alloc] init];
    self.usersLab.textColor = [UIColor whiteColor];
    self.usersLab.text = @"1001";
    self.usersLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.usersLab];
}

@end
