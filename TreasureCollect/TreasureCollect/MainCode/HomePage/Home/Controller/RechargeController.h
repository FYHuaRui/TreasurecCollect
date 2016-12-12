//
//  RechargeController.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

#import "PayButton.h"
#import "PayCountButton.h"

@interface RechargeController : BaseViewController{

    UIScrollView *_bgScrollView;
    
    UIImageView *_topImage;
    
    UILabel     *_restLabel;
    
    UIImageView *_bgLine;
    
    UIImageView *_flowLine;
    
    UILabel     *_selectLabel;
    
    PayCountButton *_countSelectButton;
    
    UIButton    *_rechargeButton;
    
    UILabel     *_recommandLabel;
    
    UILabel     *_recommandDetailLabel;
    
}

@end
