//
//  HomeController.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

#import "RechargeController.h"
#import "TicketViewController.h"

#import "LeftMore.h"
#import "ProportionView.h"
#import "HRLivePlayer.h"

#import "KlineModel.h"
#import "KlineView.h"
#import "DataView.h"
#import "lightningView.h"

@interface HomeController : BaseViewController<UIPickerViewDelegate,UIPickerViewDataSource,GCDAsyncSocketDelegate,lineDataSource>{

    UIButton    *_leftButton;
    
    UIButton    *_rechargeButton;
    
    UIButton    *_ticketButton;
    
    UILabel     *_ticketCountButton;
    
    UIButton    *_liveShowButton;
    
    UILabel     *_liveShowLabel;
    
    UILabel     *_assetsLabel;
    
    DataView     *_dataView;
    
    UIView      *_lineView;
    
    KlineView   *_kline;
    lightningView *_lightingView;
    
    UIButton    *_lineKindButton;
    
    UIPickerView    *_countPicker;
    
    NSArray     *_titleArr;
    
    UIButton    *_buyButton;
    
    UIButton    *_saleButton;
    
    ProportionView *_proportionView;
    
    GCDAsyncSocket *_asyncSocket;
    
}

@property (nonatomic, retain) LeftMore  *leftMore;//更多视图
@property (nonatomic, strong)NSArray    *KlineModels;
@property (nonatomic, assign)NSInteger   index;

@end
