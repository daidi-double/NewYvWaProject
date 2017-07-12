//
//  PCOrderDetailModel.h
//  YuWa
//
//  Created by double on 17/4/2.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCOrderDetailModel : NSObject
@property (nonatomic,copy)NSString * discount;
@property (nonatomic,copy)NSString * counter_fee_money;
@property (nonatomic,copy)NSString * money;
@property (nonatomic,copy)NSString * account_status;//交易状态
@property (nonatomic,copy)NSString * order_sn;
@property (nonatomic,copy)NSString * total_money;
@property (nonatomic,copy)NSString * seller_uid;
@property (nonatomic,copy)NSString * discount_money;
@property (nonatomic,copy)NSString * order_id;
@property (nonatomic,copy)NSString * type;//类型
@property (nonatomic,copy)NSString * pay_money;
@property (nonatomic,copy)NSString * user_name;
@property (nonatomic,copy)NSString * nickname;
@property (nonatomic,copy)NSString * ctime;
@property (nonatomic,copy)NSString * pay_to_shop_time;
@property (nonatomic,copy)NSString * create_time;
@property (nonatomic,copy)NSString * status;
@property (nonatomic,copy)NSString * plateform_income_money;//平台抽成
@property (nonatomic,copy)NSString * balance;//余额
@property (nonatomic,copy)NSString * score;//积分
@end
