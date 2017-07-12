//
//  XZSeatSelectionView.m
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "XZSeatSelectionView.h"
#import "XZSeatsView.h"
#import "XZAppLogoView.h"
#import "XZRowIndexView.h"
#import "XZCenterLineView.h"
#import "XZHallLogoView.h"
#import "XZIndicatorView.h"

@interface XZSeatSelectionView ()<UIScrollViewDelegate>
/**seatScrollView*/
@property (nonatomic, weak) UIScrollView *seatScrollView;
/**已经选择的按钮数组*/
@property (nonatomic, strong) NSMutableArray *selecetedSeats;
/**按钮父控件*/
@property (nonatomic, weak) XZSeatsView *seatView;
/**影院logo*/
@property (nonatomic, weak) UIView *hallLogo;
/**中线*/
@property (nonatomic, weak) UIView *centerLine;
/**索引条*/
@property (nonatomic, weak) UIView * rowindexView;
/**maoyanLogo*/
@property (nonatomic, weak) XZAppLogoView *maoyanLogo;
/**指示框*/
@property (nonatomic, weak) XZIndicatorView *indicatorView;
/*  取消了的座位*/
//选座按钮的宽度
@property (nonatomic, assign) NSInteger SeatsBntWidth;
//选座按钮的宽度 一行中最多座位的个数
@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic,strong)NSMutableArray * cancelAry;
@property (nonatomic,copy) void (^actionBlock)(NSMutableArray *, NSMutableDictionary *,NSMutableArray* ,NSString *);

@end
@implementation XZSeatSelectionView
-(instancetype)initWithFrame:(CGRect)frame SeatsArray:(NSMutableArray *)seatsArray HallName:(NSString *)hallName  seatBtnActionBlock:(void (^)(NSMutableArray *, NSMutableDictionary *, NSMutableArray *, NSString *))actionBlock{
    
    if (self = [super initWithFrame:frame]) {//初始化操作
        self.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
        self.actionBlock = actionBlock;
        [self initScrollView];
        [self initappLogo];
        [self initSeatsView:seatsArray];
        [self initindicator:seatsArray];
        [self initRowIndexView:seatsArray];
        [self inithallLogo:hallName];
        [self  startAnimation];//开场动画
        NSInteger maxCount = 0;
        for (XZSeatsModel *seatsModel in seatsArray) {
            if (seatsModel.columns.count>maxCount ) {
                maxCount = seatsModel.columns.count;
                self.maxCount = maxCount;
            }
        }
        [self initcenterLine:seatsArray withMaxcount:(NSInteger)maxCount];
    }
    return self;
}

-(NSMutableArray *)selecetedSeats{
    if (!_selecetedSeats) {
        
        _selecetedSeats = [NSMutableArray array];
    }
    return _selecetedSeats;
}
- (NSMutableArray*)cancelAry{
    if (!_cancelAry) {
        _cancelAry = [NSMutableArray array];
    }
    return _cancelAry;
}
-(void)startAnimation{
    
    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect zoomRect = [self _zoomRectInView:self.seatScrollView forScale:XZseastNomarW_H / self.seatView.seatBtnHeight withCenter:CGPointMake(self.seatView.seatViewWidth / 2, 0)]; [self.seatScrollView zoomToRect:zoomRect animated:NO];
    } completion:nil];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.seatView;
}
-(void)initScrollView{
    UIScrollView *seatScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.seatScrollView = seatScrollView;
    self.seatScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.seatScrollView.delegate = self;
    self.seatScrollView.showsHorizontalScrollIndicator = NO;
    self.seatScrollView.showsVerticalScrollIndicator = NO;
    self.seatScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.seatScrollView];
}
-(void)initappLogo{
    XZAppLogoView * maoyanLogo = [[XZAppLogoView alloc]init];
    maoyanLogo.backgroundColor = [UIColor groupTableViewBackgroundColor];
    maoyanLogo.y = self.height - XZseastsRowMargin*2;
    maoyanLogo.width = XZAppLogoW;
    maoyanLogo.height = XZseastsRowMargin*2;
    maoyanLogo.centerX = self.width * 0.5;
    self.maoyanLogo = maoyanLogo;
    [self.seatScrollView insertSubview:maoyanLogo atIndex:0];
}
-(void)initRowIndexView:(NSMutableArray *)seatsArray{
    XZRowIndexView * rowindexView = [[XZRowIndexView alloc]init];
    rowindexView.indexsArray = seatsArray;
    rowindexView.width = 13;
    rowindexView.height = self.seatView.height + 2 * XZseastMinW_H+4*seatsArray.count ;
    rowindexView.y =  - XZSmallMargin;
    rowindexView.x = self.seatScrollView.contentOffset.x + XZseastMinW_H;
    self.rowindexView = rowindexView;
    [self.seatScrollView addSubview:rowindexView];
}
-(void)initcenterLine:(NSMutableArray *)seatsArray withMaxcount:(NSInteger)Maxcount{
    XZCenterLineView *centerLine = [[XZCenterLineView alloc]init];
    centerLine.backgroundColor = [UIColor clearColor];
    centerLine.width = 1;
    centerLine.height = seatsArray.count * XZseastNomarW_H + 2 * XZSmallMargin ;
    self.centerLine = centerLine;
    
    self.centerLine.centerX = self.seatView.centerX ;
    self.centerLine.y = self.seatScrollView.contentOffset.y + XZCenterLineY;
    [self.seatScrollView addSubview:self.centerLine];
}
-(void)inithallLogo:(NSString *)HallName{
    XZHallLogoView *logoView = [[XZHallLogoView alloc]init];
    self.hallLogo = logoView;
    logoView.hallName = HallName;
    logoView.width = XZHallLogoW;
    logoView.height = 20;
    self.hallLogo.centerX = self.seatView.centerX;
    self.hallLogo.y = self.seatScrollView.contentOffset.y;
    [self.seatScrollView addSubview:self.hallLogo];

}

-(void)initSeatsView:(NSMutableArray *)seatsArray{
    __weak typeof(self) weakSelf = self;
    XZSeatsView *seatView = [[XZSeatsView alloc]initWithSeatsArray:seatsArray  maxNomarWidth:self.width maxCount:self.maxCount seatBtnActionBlock:^(XZSeatButton *seatBtn, NSMutableDictionary *allAvailableSeats) {
       
        
        NSString *errorStr = nil;
        
        if (seatBtn.selected) {
            
            [weakSelf.selecetedSeats addObject:seatBtn];

            
            if (weakSelf.selecetedSeats.count > ZFMaxSelectedSeatsCount) {
                
                seatBtn.selected = !seatBtn.selected;
                
                [weakSelf.selecetedSeats removeObject:seatBtn];
                
                errorStr = ZFExceededMaximumError;
                
            }
            
        }else{
            
            if ([weakSelf.selecetedSeats containsObject:seatBtn]) {
                
                [weakSelf.selecetedSeats removeObject:seatBtn];

              
                [weakSelf.cancelAry addObject:seatBtn];
                if (weakSelf.actionBlock) weakSelf.actionBlock(weakSelf.selecetedSeats,allAvailableSeats,weakSelf.cancelAry,errorStr);
                
                return ;
                
            }
            
        }
        
        if (weakSelf.actionBlock) weakSelf.actionBlock(weakSelf.selecetedSeats,allAvailableSeats,weakSelf.cancelAry,errorStr);
        
        if (weakSelf.seatScrollView.maximumZoomScale - weakSelf.seatScrollView.zoomScale < 0.1) return;//设置座位放大
        
        CGFloat maximumZoomScale = weakSelf.seatScrollView.maximumZoomScale;
        
        CGRect zoomRect = [weakSelf _zoomRectInView:weakSelf.seatScrollView forScale:maximumZoomScale withCenter:CGPointMake(seatBtn.centerX, seatBtn.centerY)];
        
        [weakSelf.seatScrollView zoomToRect:zoomRect animated:YES];
    }];
    //获取按钮的宽度
    self.SeatsBntWidth = [seatView  getSeatBtnHeight];
    self.seatView = seatView;
    seatView.frame = CGRectMake(0, 0,seatView.seatViewWidth, seatView.seatViewHeight);
    [self.seatScrollView insertSubview:seatView atIndex:0];
    self.seatScrollView.maximumZoomScale = XZseastMaxW_H / seatView.seatBtnWidth;
    self.seatScrollView.contentInset = UIEdgeInsetsMake(XZseastsColMargin,
        (self.width - self.seatView.seatViewWidth)/2,XZseastsColMargin,(self.width - seatView.seatViewWidth)/2);
}
-(void)initindicator:(NSMutableArray *)seatsArray{
    
    CGFloat Ratio = 2;
    XZSeatsModel *seatsModel = seatsArray.firstObject;
    NSUInteger cloCount = [seatsModel.columns count];
    if (cloCount % 2) cloCount += 1;
    CGFloat ZFMiniMeIndicatorMaxHeight = self.height / 6;//设置最大高度
    CGFloat MaxWidth = (self.width - 2 * XZseastsRowMargin) * 0.5;
    CGFloat currentMiniBtnW_H = MaxWidth / cloCount;
    CGFloat MaxHeight = currentMiniBtnW_H * seatsArray.count;
    
    if (MaxHeight >= ZFMiniMeIndicatorMaxHeight ) {
        currentMiniBtnW_H = ZFMiniMeIndicatorMaxHeight / seatsArray.count;
        MaxWidth = currentMiniBtnW_H * cloCount;
        MaxHeight = ZFMiniMeIndicatorMaxHeight;
        Ratio = (self.width - 2 * XZseastsRowMargin) / MaxWidth;
    }
    
    XZIndicatorView *indicatorV = [[XZIndicatorView alloc]initWithView:self.seatView  withRatio:Ratio  withScrollView:self.seatScrollView];
    indicatorV.x = 3;
    indicatorV.y = 3 * 3;
    indicatorV.width = MaxWidth;
    indicatorV.height = MaxHeight+(seatsArray.count*4);
    self.indicatorView = indicatorV;
    [self addSubview:indicatorV];
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 更新applogo
    if (scrollView.contentOffset.y <= scrollView.contentSize.height - self.height +XZseastsColMargin + 15) {
        self.maoyanLogo.y = CGRectGetMaxY(self.seatView.frame) + 35;
        self.maoyanLogo.centerX = self.seatView.centerX;
    }else{
        self.maoyanLogo.centerX = self.seatView.centerX;
        self.maoyanLogo.y = scrollView.contentOffset.y + self.height - self.maoyanLogo.height;
    }
    //更新hallLogo
    self.hallLogo.y = scrollView.contentOffset.y;
    
    //更新中线
    self.centerLine.height = CGRectGetMaxY(self.seatView.frame) + 2 * XZSmallMargin;
    
    if (scrollView.contentOffset.y < - XZseastsColMargin ) {
        self.centerLine.y = self.seatView.y - XZseastsColMargin + XZCenterLineY;
    }else{
        self.centerLine.y = scrollView.contentOffset.y + XZCenterLineY;
        self.centerLine.height = CGRectGetMaxY(self.seatView.frame) - scrollView.contentOffset.y - 2 * XZCenterLineY + XZseastsColMargin;
    }
    // 更新索引条
    self.rowindexView.x = scrollView.contentOffset.x + XZseastMinW_H;
    
    
    //更新indicator大小位置
    [self.indicatorView updateMiniIndicator];
    if (!self.indicatorView.hidden || self.seatScrollView.isZoomBouncing)return;
    self.indicatorView.alpha = 1;
    self.indicatorView.hidden = NO;
    
}

#pragma mark - <UIScrollViewDelegate>
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self.indicatorView selector:@selector(indicatorHidden) object:nil];
    self.centerLine.centerX = self.seatView.centerX;
    self.rowindexView.height = self.seatView.height + 2 * XZSmallMargin;
    self.hallLogo.centerX = self.seatView.centerX;
    self.maoyanLogo.centerX = self.seatView.centerX;
    [self.indicatorView updateMiniIndicator];
    [self scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    self.hallLogo.centerX = self.seatView.centerX;
    self.hallLogo.y = scrollView.contentOffset.y;
    self.centerLine.centerX = self.seatView.centerX;
    self.centerLine.y = scrollView.contentOffset.y + XZCenterLineY;
    self.maoyanLogo.centerX = self.seatView.centerX;
    [self.indicatorView updateMiniIndicator];
    [self scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self.indicatorView selector:@selector(indicatorHidden) object:nil];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self.indicatorView performSelector:@selector(indicatorHidden) withObject:nil afterDelay:2];
    
}

- (CGRect)_zoomRectInView:(UIView *)view forScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = view.bounds.size.height / scale;
    zoomRect.size.width = view.bounds.size.width / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
