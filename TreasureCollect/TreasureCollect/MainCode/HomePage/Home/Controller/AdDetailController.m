//
//  AdDetailController.m
//  TreasureCollect
//
//  Created by Apple on 2017/1/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AdDetailController.h"

@interface AdDetailController ()

@end

@implementation AdDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIWebView *testWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kNavigationBarHeight)];
    testWebView.backgroundColor = [UIColor whiteColor];
    testWebView.scrollView.scrollEnabled = NO;
    [testWebView sizeToFit];
    [self.view addSubview:testWebView];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [testWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
}

@end
