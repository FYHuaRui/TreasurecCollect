//
//  ProportionView.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrangleCell.h"

@interface ProportionView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>{

    UICollectionView *_redCollectionView;
    UICollectionView *_greenCollectionView;
    
    UILabel *_redLabel;
    UILabel *_greenLabel;
    
    NSTimer *_timer;
    
    NSInteger _redcellCount;
    NSInteger _greencellCount;
}

@property (nonatomic ,assign)float proportionNum;

@end
