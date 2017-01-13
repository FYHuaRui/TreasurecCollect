//
//  AdvertiseView.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AdDetailController.h"

@interface AdvertiseView : UIView<UIScrollViewDelegate>{

    UIScrollView *_advertiseView;
    
    UIPageControl   *_control;

}

@end
