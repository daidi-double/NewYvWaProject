//
//  MovieCinemaModel.h
//  YuWa
//
//  Created by double on 17/2/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieCinemaModel : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * screenings;//场次
@property (nonatomic,strong) NSString * cinema_adress;

@property (nonatomic,assign) BOOL isChooseSeat;//能否选座
@property (nonatomic,assign) BOOL isReturn_ticket;//能否退票
@property (nonatomic,assign) BOOL isChang_ticket;//能否改签
@property (nonatomic,assign) BOOL isFood;//有无小吃
@property (nonatomic,assign) BOOL isDiscount;//有无折扣卡 - 0有 1无

+ (MovieCinemaModel*)movieCinemaModelWithDic:(NSDictionary*)dic;
@end
