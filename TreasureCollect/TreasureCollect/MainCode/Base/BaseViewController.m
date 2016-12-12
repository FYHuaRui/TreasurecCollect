//
//  BaseViewController.m
//  TreasureCollect
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController{
    
    UIWindow *_tipWindow;
    UIView *_tipView;
    MBProgressHUD *_hud;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
}

//设置导航控制器的属性
-(void)setNavigationBar{
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName : [UIColor blackColor]}];
    [self _addBackItem];
}

//设置返回按钮
- (void)_addBackItem{
    
}

#pragma mark - 设置HUD
- (void)showHUD:(NSString *)title {
    
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    _hud.label.text = title;
    
    [_hud showAnimated:YES];
}

- (void)hideSuccessHUD:(NSString *)title {
    
    if (title.length == 0) {
        [_hud hideAnimated:YES afterDelay:1.f];
    } else {
        
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        //显示模式设置为：自定义视图模式
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.label.text = title;
        
        //延迟隐藏
        [_hud hideAnimated:YES afterDelay:1.f];
        [self performSelector:@selector(changgeModel)
                   withObject:nil
                   afterDelay:2.f];
    }
    
}

- (void)hideFailHUD:(NSString *)title {
    
    if (title.length == 0) {
        [_hud hideAnimated:YES afterDelay:1.5];
    } else {
        
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        //显示模式设置为：自定义视图模式
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.label.text = title;
        
        //延迟隐藏
        [_hud hideAnimated:YES afterDelay:1.5];
        [self performSelector:@selector(changgeModel)
                   withObject:nil
                   afterDelay:2.f];
    }
    
}

- (void)changgeModel{
    
    _hud.mode = MBProgressHUDModeIndeterminate;
    
}

@end
