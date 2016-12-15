//
//  ProportionView.m
//  TreasureCollect
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ProportionView.h"

@implementation ProportionView

- (instancetype)init{
    
    self = [super init ];
    if (self) {
        
        [self initViews];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame: frame];
    if (self) {
        
        [self initViews];
        
    }
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder: aDecoder];
    
    if (self) {
        
        [self initViews];
        
    }
    return self;
    
}

- (void)initViews{
    
    //买涨的比例视图
    _redcellCount = 15;
    _greencellCount = 15;
    
    UICollectionViewFlowLayout *redlayout = [[UICollectionViewFlowLayout alloc] init];
    redlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置单元格的间隙
    redlayout.minimumInteritemSpacing = 0;
    redlayout.minimumLineSpacing = 0;
    redlayout.itemSize = CGSizeMake(24.f  , self.height);
    _redCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width / 2, self.height)
                                            collectionViewLayout:redlayout];
    _redCollectionView.backgroundColor = [UIColor colorFromHexRGB:@"C93723"];
    [_redCollectionView registerNib:[UINib nibWithNibName:@"TrangleCell"
                                               bundle:[NSBundle mainBundle]]
     forCellWithReuseIdentifier:@"Trangle_Cell"];
    _redCollectionView.dataSource = self;
    _redCollectionView.delegate = self;
    _redCollectionView.tag = 400;
    [_redCollectionView setContentOffset:CGPointMake(_redCollectionView.contentSize.width, 0)];
    [self addSubview:_redCollectionView];

    _redLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.f, 2.f, 72.f, self.height - 4.f)];
    _redLabel.text = [NSString stringWithFormat:@"买涨：%.0f%%",_proportionNum];
    _redLabel.textColor = [UIColor whiteColor];
    _redLabel.textAlignment = NSTextAlignmentLeft;
    _redLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:_redLabel];
    
    //买跌的比例视图
    UICollectionViewFlowLayout *greenlayout = [[UICollectionViewFlowLayout alloc] init];
    greenlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置单元格的间隙
    greenlayout.minimumInteritemSpacing = 0;
    greenlayout.minimumLineSpacing = 0;
    greenlayout.itemSize = CGSizeMake(24.f , self.height);
    _greenCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.width / 2, 0, self.width / 2, self.height)
                                            collectionViewLayout:greenlayout];
    _greenCollectionView.backgroundColor = [UIColor colorFromHexRGB:@"75BA7F"];
    [_greenCollectionView registerNib:[UINib nibWithNibName:@"TrangleCell"
                                                   bundle:[NSBundle mainBundle]]
         forCellWithReuseIdentifier:@"Trangle_Cell"];
    _greenCollectionView.dataSource = self;
    _greenCollectionView.delegate = self;
    _greenCollectionView.tag = 401;
    [self addSubview:_greenCollectionView];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                    repeats:YES
                                      block:^(NSTimer * _Nonnull timer) {
                                          
                                          [UIView animateWithDuration:0.5
                                                                delay:0
                                                              options:UIViewAnimationOptionCurveLinear
                                                           animations:^{
                                                               
                                                               CGPoint greenpoint = _greenCollectionView.contentOffset;
                                                               greenpoint.x += 20;
                                                               _greenCollectionView.contentOffset = greenpoint;
                                                               
                                                               float greenOffsize = _greenCollectionView.contentSize.width -  _greenCollectionView.contentOffset.x;
                                                               if (greenOffsize < _greenCollectionView.frame.size.width) {
                                                                   
                                                                   _greencellCount += 10;
                                                                   
                                                                   [_greenCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                                                                   
                                                               }
                                                               
                                                               CGPoint redpoint = _redCollectionView.contentOffset;
                                                               redpoint.x -= 20;
                                                               _redCollectionView.contentOffset = redpoint;
                                                               
                                                               float redOffsize = _redCollectionView.contentOffset.x;
                                                               if (redOffsize < _redCollectionView.frame.size.width) {
                                                                   
                                                                   _redcellCount += 10;
                                                                   
                                                                   [_redCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                                                                   
                                                               }
                                                               
                                                           } completion:^(BOOL finished) {
                                                               
                                                           }];
                                          
                                      }];
    
    _greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 74.f, 2.f, 72.f, self.height - 4.f)];
    _greenLabel.text = [NSString stringWithFormat:@"买跌：%.0f%%",_proportionNum];
    _greenLabel.textColor = [UIColor whiteColor];
    _greenLabel.textAlignment = NSTextAlignmentRight;
    _greenLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:_greenLabel];
    

}


#pragma mark - UICollectionViewDelegate，UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView.tag == 400) {
        return _redcellCount;
    }else{
        return _greencellCount;
    }

    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TrangleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Trangle_Cell" forIndexPath:indexPath];
    if (collectionView.tag == 400) {
        [cell.cellImg setImage:[UIImage imageNamed:@"rightTrangle"]];
    }else{
        [cell.cellImg setImage:[UIImage imageNamed:@"leftTrangle"]];
    }

    return cell;
    
}


//计算子视图的数量
- (void)addImage:(UIImage *)image ToSubview:(UIScrollView *)scrollView{

    for (UIImageView *imageView in scrollView.subviews) {
        [imageView removeFromSuperview];
    }
    CGSize imageSize = image.size;
    CGFloat imageProportion = imageSize.width / imageSize.height;
    CGFloat imageViewWidth = imageProportion * scrollView.height;
    NSInteger subViewCount = scrollView.width / imageViewWidth + 1;
    for (int i = 0 ; i < subViewCount; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * imageViewWidth, 0, imageViewWidth, self.height)];
        imageView.image = image;
        [scrollView addSubview:imageView];
        
    }
    scrollView.contentSize = CGSizeMake(imageViewWidth * subViewCount, self.height);

    if (scrollView.tag == 100) {
        
        scrollView.contentOffset = CGPointMake(imageViewWidth * subViewCount - scrollView.width, 0);
    
    }else{
    
        scrollView.contentOffset = CGPointMake(0, 0);
    
    }
    
}

- (void)setProportionNum:(float)proportionNum{

    if(_proportionNum != proportionNum){
    
        //根据大小判断,比例改变情况（谁增谁减少）
        if (proportionNum > _proportionNum) {
            
//            _redcellCount = 15;
//            _greencellCount = 15;
//            [_redCollectionView reloadData];
//            [_greenCollectionView reloadData];
            [UIView animateWithDuration:1
                             animations:^{
                                 
                                 CGRect redFrame = _redCollectionView.frame;
                                 redFrame.size.width = self.width  * proportionNum;
                                 _redCollectionView.frame = redFrame;
                                 UIImage *redimage = [UIImage imageNamed:@"rightTrangle"];
                                 [self addImage:redimage
                                      ToSubview:_redCollectionView];
                                 
                                 CGRect greenFrame = _greenCollectionView.frame;
                                 greenFrame.origin.x =  greenFrame.origin.x + greenFrame.size.width - self.width * (1 - proportionNum);
                                 greenFrame.size.width = self.width * (1 - proportionNum);
                                 _greenCollectionView.frame = greenFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 UIImage *greenimage = [UIImage imageNamed:@"leftTrangle"];
                                 [self addImage:greenimage
                                      ToSubview:_greenCollectionView];
                                 
                             }];
            
            
        }else{
        
            [UIView animateWithDuration:1
                             animations:^{
                                 
                                 CGRect redFrame = _redCollectionView.frame;
                                 redFrame.size.width = self.width  * proportionNum;
                                 _redCollectionView.frame = redFrame;
                                 
                                 CGRect greenFrame = _greenCollectionView.frame;
                                 greenFrame.origin.x =  greenFrame.origin.x + greenFrame.size.width - self.width * (1 - proportionNum);
                                 greenFrame.size.width = self.width * (1 - proportionNum);
                                 _greenCollectionView.frame = greenFrame;

                                 
                             } completion:^(BOOL finished) {
                                 

                             }];
            
        
        }
        
        _proportionNum = proportionNum;
        _redLabel.text = [NSString stringWithFormat:@"买涨：%.0f%%",_proportionNum * 100];
        _greenLabel.text = [NSString stringWithFormat:@"买跌：%.0f%%",(1-_proportionNum) * 100];
    
    }

}

@end
