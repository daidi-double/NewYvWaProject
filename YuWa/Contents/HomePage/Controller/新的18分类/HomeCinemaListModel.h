//
//  HomeCinemaListModel.h
//  YuWa
//
//  Created by double on 17/5/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCinemaListModel : NSObject
@property (nonatomic,copy)NSString * id;
@property (nonatomic,copy)NSString * minprice;//几元起
@property (nonatomic,copy)NSString * province;//省编码
@property (nonatomic,copy)NSString * longitude;
@property (nonatomic,copy)NSString * latitude;
@property (nonatomic,copy)NSString * goodstype;//影院供应商品类型：0:选座票和通兑票 1:选座票 2:通兑票
@property (nonatomic,copy)NSString * code;//影院编码
@property (nonatomic,copy)NSString * address;
@property (nonatomic,copy)NSString * city;//市编码
@property (nonatomic,copy)NSString * county;//区编码
@property (nonatomic,copy)NSString * tel;
@property (nonatomic,copy)NSString * distance;
@property (nonatomic,copy)NSString * cinema_name;//影院名
@property (nonatomic,copy)NSString * score;
@property (nonatomic,copy)NSString * film_code;
@end
