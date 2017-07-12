//
//  CinemaHeaderModel.h
//  YuWa
//
//  Created by double on 17/5/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaHeaderModel : NSObject
@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * code;//影院编码
@property (nonatomic,copy) NSString * cinema_name;
@property (nonatomic,copy) NSString * province;//省编码
@property (nonatomic,copy) NSString * city;//城市编码
@property (nonatomic,copy) NSString * county;//国家编码
@property (nonatomic,copy) NSString * address;//地址
@property (nonatomic,copy) NSString * tel;//电话
@property (nonatomic,copy) NSString * longitude;//经度
@property (nonatomic,copy) NSString * latitude;//维度
@property (nonatomic,copy) NSString * score;//评分
@property (nonatomic,copy) NSString * film_code;//电影编码

@end
