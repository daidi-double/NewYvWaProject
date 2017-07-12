//
//  CinemaModel.h
//  YuWa
//
//  Created by double on 17/5/15.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaModel : NSObject
@property (nonatomic,copy)NSString * cinema_name;//影院名
@property (nonatomic,copy)NSString * settle_price;//几元起
@property (nonatomic,copy)NSString * distance;//距离
@property (nonatomic,copy)NSString * intro;//简介
@property (nonatomic,copy)NSString * cinema_code;//影院id
@property (nonatomic,copy)NSString * language;//语言
@property (nonatomic,copy)NSString * province;//省编码
@property (nonatomic,copy)NSString * code;//影院编码
@property (nonatomic,copy)NSString * show_type;//播放类型
@property (nonatomic,copy)NSString * duration;//时长
@property (nonatomic,copy)NSString * tel;
@property (nonatomic,copy)NSString * film_show_time;
@property (nonatomic,copy)NSString * score;
@property (nonatomic,copy)NSString * stop_sell_time;
@property (nonatomic,copy)NSString * city;//城市编码
@property (nonatomic,copy)NSString * latutude;//维度
@property (nonatomic,copy)NSString * goodstype;//0:选座票和通兑票 1:选座票 2:通兑票 3.卖品 4.选座票和卖品 5.通兑票和卖品 6.选座票和通兑票和卖品
@property (nonatomic,copy)NSString * minprice;//起步价
@property (nonatomic,copy)NSString * hall_name;
@property (nonatomic,copy)NSString * id;
@property (nonatomic,copy)NSString * channelshowcode;
@property (nonatomic,copy)NSString * longitude;
@property (nonatomic,copy)NSString * county;
@property (nonatomic,copy)NSString * film_code;
@property (nonatomic,copy)NSString * film_end_time;
@property (nonatomic,copy)NSString * address;
@property (nonatomic,copy)NSString * film_count;//播放数量
@end
