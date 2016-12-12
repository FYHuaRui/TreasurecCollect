//
//  PayButton.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayButton : UIButton{

    UIImageView *_topicImage;
    UILabel *_topicLabel;

}

@property (nonatomic ,copy)NSString *topicTitle;

@end
