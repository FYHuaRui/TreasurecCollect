//
//  BaseViewController.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//显示HUD提示
- (void)showHUD:(NSString *)title;

//隐藏HUD(成功)
- (void)hideSuccessHUD:(NSString *)title;

//隐藏HUD(失败)
- (void)hideFailHUD:(NSString *)title;

@end
