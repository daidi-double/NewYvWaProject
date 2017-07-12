//
//  OrderModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    "status" = 待付款,
//    "order_id" = 209,
//    "total_money" = 539.00,
//    "shop_img" = http://114.215.252.104/Public/Upload/20161107/14784877879161.jpg,
//    "non_discount_money" = 0.00,
//    "discount" = 0.00,
//    "shop_address" = 虹桥火车站二层麦当劳,
//    "shop_name" = McDolonds,
//    "pay_money" = 0.00,
//    "create_time" = 1474851923,
//    "shop_id" = 11,
//    }, 



@interface OrderModel : NSObject

@property(nonatomic,strong)NSString*status;//订单状态  电影：订单状态（1：未支付 2：已取消 3：已支付 4：出票成功 5：出票失败 6：已退票 7：已评价
@property(nonatomic,strong)NSString*order_id;
@property(nonatomic,strong)NSString*create_time;
@property(nonatomic,strong)NSString*total_money;   //总共需要支付的钱
@property(nonatomic,strong)NSString*pay_money;     //需要支付多少钱
//我的订单
@property(nonatomic,strong)NSString*shop_img;
@property(nonatomic,strong)NSString*non_discount_money;
@property(nonatomic,strong)NSString*shop_address;

@property(nonatomic,strong)NSString*shop_id;   //店铺的id
@property(nonatomic,strong)NSString*shop_name;     //店铺的名字
@property(nonatomic,strong)NSString*discount;      //折扣

@property(nonatomic,strong)NSArray * buy_shopAry;//购买的商品套餐
@property(nonatomic,assign)NSInteger is_coupon;//是否使用优惠券
@property(nonatomic,strong)NSString * coupon_money;//优惠券金额

//电影订单
@property(nonatomic,strong)NSString * address;
@property(nonatomic,strong)NSString * cinema_code;
@property(nonatomic,strong)NSString * cinema_name;
@property(nonatomic,strong)NSString * film_code;

//电影订单详情
@property (nonatomic,copy)NSString * seat;//通兑票座位为空
@property (nonatomic,copy)NSString * pay_time;
@property (nonatomic,copy)NSString * validate_memo;
@property (nonatomic,copy)NSString * be_per_price;
@property (nonatomic,copy)NSString * user_id;
@property (nonatomic,copy)NSString * show_type;
@property (nonatomic,copy)NSString * device_pos;
@property (nonatomic,copy)NSString * cinemaName;
@property (nonatomic,copy)NSString * pay_type;
@property (nonatomic,copy)NSString * per_price;
@property (nonatomic,copy)NSString * hall_name;
@property (nonatomic,copy)NSString * type;//1: 选座票 2: 通兑票
@property (nonatomic,copy)NSString * ticket_no;
@property (nonatomic,copy)NSString * id;
@property (nonatomic,copy)NSString * period_validity;//上映时间（选座票才有）或有效期（通兑票才有)
@property (nonatomic,copy)NSString * order_sn;
@property (nonatomic,copy)NSString * mobile;
@property (nonatomic,copy)NSString * num;//数量
@property (nonatomic,copy)NSString * channelshowcode;
@property (nonatomic,copy)NSString * balance_money;
@property (nonatomic,copy)NSString * third_pay_money;
@property (nonatomic,copy)NSString * filmName;
@property (nonatomic,copy)NSString * order_coder;
@property (nonatomic,copy)NSString * voucher_code;//凭证号
@property (nonatomic,copy)NSString * print_code;//取票号
@property (nonatomic,copy)NSString * verify_code;//取票验证码
+(OrderModel *)orderModelWithDic:(NSDictionary*)dic;

@end
