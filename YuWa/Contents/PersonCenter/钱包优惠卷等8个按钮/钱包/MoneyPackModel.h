//
//  MoneyPackModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyPackModel : NSObject
//order_id = 460,
//ctime = 1482397492,
//time = 17:04,
//week = 四,
//type = 间接介绍分红,
//money = 0.0000,
//dateTime = 2016-12-22
@property(nonatomic,strong)NSString * ctime;
@property(nonatomic,strong)NSString * money;//获得的钱
@property(nonatomic,strong)NSString * date;//今日
@property(nonatomic,strong)NSString * dateTime;//年月日
@property(nonatomic,strong)NSString * type;//类型名称
@property(nonatomic,strong)NSString * myMoney;//我的余额
@property(nonatomic,strong)NSString * time;//时间9：00
@property(nonatomic,copy)NSString * week;
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,copy)NSString * id;
@end
