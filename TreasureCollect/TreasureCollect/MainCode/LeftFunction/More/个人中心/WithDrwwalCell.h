//
//  WithDrwwalCell.h
//  TreasureCollect
//
//  Created by Apple on 2017/2/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithDrwwalCell : UITableViewCell{

    UIImageView *_rightImage;
    UIImageView *_bottomLine;

}

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UITextField *inputTF;
@property (nonatomic,strong)NSString *cellTitle;
@property (nonatomic,strong)NSString *cellPlaceHold;

@end
