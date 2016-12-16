//
//  ProportionView.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProportionView : UIView{
    
    UIImageView *_redImage;
    UIImageView *_greenImage;
    
    UILabel *_redLabel;
    UILabel *_greenLabel;
    
    NSTimer *_timer;
    
}

@property (nonatomic ,assign)float proportionNum;

@end
