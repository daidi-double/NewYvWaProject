//
//  PCPayViewController.h
//  YuWa
//
//  Created by 黄佳峰 on 16/10/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YWPayMViewController.h"
#import "WXApi.h"
@interface PCPayViewController : UIViewController<WXApiDelegate>
@property (nonatomic,assign)NSInteger status;//1为电影支付过来，0为其他支付，2为电影通兑票,3为保证金缴纳
@property(nonatomic,assign)CGFloat blanceMoney;  //需要付多少钱
@property(nonatomic,assign)CGFloat order_id;  //订单号、电影订单id
@property(nonatomic,copy)NSString * shop_ID;//店铺id
@property(nonatomic,copy)NSString * orderCode;//电影订单号

//微信支付
+(instancetype)sharedManager;
-(void)TowechatPay:(NSDictionary*)dict;
//单利
@end
