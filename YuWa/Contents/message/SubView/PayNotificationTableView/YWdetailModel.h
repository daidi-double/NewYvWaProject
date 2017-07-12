//
//  YWdetailModel.h
//  YuWa
//
//  Created by L灰灰Y on 2017/4/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWdetailModel : NSObject
//卖家信息
@property (nonatomic, copy) NSString *seller_message;
//店名
@property (nonatomic, copy) NSString *shop_name;
//时间
@property (nonatomic, copy) NSString *ctime;
//电话
@property (nonatomic, copy) NSString *customer_phone;
//别名
@property (nonatomic, copy) NSString *customer_name;
//性别
@property (nonatomic, copy) NSString *customer_sex;

@property (nonatomic, copy) NSString *customer_num;

@property (nonatomic,copy) NSString * shop_id;

//卖家信息
@property (nonatomic, copy) NSString *customer_message;
@end
