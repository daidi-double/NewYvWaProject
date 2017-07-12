//
//  CouponModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/2.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponModel : UIScrollView

//{
//    "end_time" = 1478369547,
//    "discount_fee" = 0,
//    "coupon_id" = 25,
//    "shop_id" = 1,
//    "begin_time" = 0,
//    "name" =  优惠券 2（9折）,
//    "min_fee" = 0,
//}, 


@property(nonatomic,strong)NSString*min_fee;  //满多少才能使用
@property(nonatomic,strong)NSString*discount_fee;   //抵用多少
@property(nonatomic,strong)NSString*shop_id;  //对应的店铺id  只能这家店铺用
@property(nonatomic,strong)NSString*coupon_id;  //抵用券的id

@property(nonatomic,assign)NSInteger type;//优惠券的类型 1.商家自发劵(所有用户可以抢100%几率抢的到）（商家前台自己发布，后台显示数据) 2.平台通用劵 (此类优惠券发布后，所有用户均会自动获取，所有用户所有商家）（后台发布） 3.平台指定商家劵（此类优惠券发布后，所有用户均会自动获取，所有用户指定商家）（后台发布） 4.平台活动赠送劵（后台设定指定用户拿的到，指定用户指定商家）（后台发布）
@property(nonatomic,strong)NSString*name;  //抵用券的标题
@property(nonatomic,strong)NSString*begin_time;  //抵用券开始的时间
@property(nonatomic,strong)NSString*end_time;   //抵用券结束的时间

//@property(nonatomic,strong)NSString*status;  //状态 可用 已使用 已过期


@end
