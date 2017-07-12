//
//  SalesPriceViewController.h
//  YuWa
//
//  Created by double on 17/7/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesPriceViewController : UIViewController
@property (strong,nonatomic) UIView * BgView;//选择价格的背景view，底部的视图
@property (strong, nonatomic) UIButton *increaseBtn;//加价按钮
@property (strong, nonatomic) UILabel *myPriceLabel;//我的价格
@property (strong, nonatomic) UILabel *directnessLabel;//直接出价
@property (strong,nonatomic) UILabel * cautionTitleLabel;//当前价
@property (strong,nonatomic) UILabel * cautionTitleTwoLabel;//当前价
@property (strong,nonatomic) UILabel * priceLabel;//下次出价
@property (strong,nonatomic) UILabel * priceTwoLabel;//下次出价
@property (strong,nonatomic) UIView * line;
@property (strong,nonatomic) UIView * delegateBGView;//直接出价弹窗背景视图
@property (nonatomic,strong) UIView * delegatePriceBGView;//弹窗的透明背景层
@property (nonatomic,strong) UIView * delegateOfferView;//代理出价透明背景层
@property (nonatomic,strong) UIView * offerView;//代理出价弹窗背景视图

-(CGFloat)getCellHeightStr:(NSString*)content contentOfFont:(NSInteger)font;
- (void)creatPayView;
@end
