//
//  OrderModel.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OrderModel.h"
//status;
//@property(nonatomic,strong)NSString*order_id;
//@property(nonatomic,strong)NSString*shop_img;
//@property(nonatomic,strong)NSString*non_discount_money;
//@property(nonatomic,strong)NSString*shop_address;
//@property(nonatomic,strong)NSString*create_time;
//
//@property(nonatomic,strong)NSString*shop_id;   //店铺的id
//@property(nonatomic,strong)NSString*shop_name;     //店铺的名字
//@property(nonatomic,strong)NSString*pay_money;     //需要支付多少钱
//@property(nonatomic,strong)NSString*discount;      //折扣
//@property(nonatomic,strong)NSString*total_money;   //总共需要支付的钱
//
//@property(nonatomic,strong)NSMutableArray * buy_shopAry;//购买的商品套餐
//@property(nonatomic,strong)NSString * orderState;//订单状态
@implementation OrderModel
+(OrderModel*)orderModelWithDic:(NSDictionary *)dic{
    OrderModel * model = [[OrderModel alloc]init];
    model.shop_id = dic[@"shop_id"];
    model.order_id = dic[@"order_id"];
    model.total_money = dic[@"total_money"];
    model.shop_img = dic[@"shop_img"];
    model.non_discount_money = dic[@"non_discount_money"];
    model.discount = dic[@"discount"];
    model.shop_address = dic[@"shop_address"];
    model.shop_name = dic[@"shop_name"];
    model.pay_money =dic[@"pay_money"];
    model.create_time = dic[@"create_time"];
    model.status = dic[@"status"];
    
    
    return model;
}
@end
