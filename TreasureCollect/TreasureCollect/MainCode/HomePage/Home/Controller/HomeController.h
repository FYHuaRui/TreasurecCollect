//
//  HomeController.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

#import "UIColor+YYStockTheme.h"
#import "YYFiveRecordModel.h"
#import "YYLineDataModel.h"
#import "YYTimeLineModel.h"
#import "AppServer.h"
#import "YYStock.h"

#import "RechargeController.h"
#import "TicketViewController.h"
#import "LeftMore.h"
#import "ProportionView.h"
#import "HRLivePlayer.h"

@interface HomeController : BaseViewController<UIPickerViewDelegate,UIPickerViewDataSource,GCDAsyncSocketDelegate>{

    UIButton *_leftButton;
    
    UIButton *_rechargeButton;
    
    UIButton *_ticketButton;
    
    UIButton *_liveShowButton;
    
    UIPickerView    *_countPicker;
    
    NSArray  *_titleArr;
    
    UIButton    *_buyButton;
    
    UIButton    *_saleButton;
    
    ProportionView *_proportionView;
    
    GCDAsyncSocket *_asyncSocket;
    
}

@property (nonatomic, retain) LeftMore      *leftMore;//更多视图

@end
