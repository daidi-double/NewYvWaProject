//
//  MovieCinemaModel.m
//  YuWa
//
//  Created by double on 17/2/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieCinemaModel.h"

@implementation MovieCinemaModel
+ (MovieCinemaModel*)movieCinemaModelWithDic:(NSDictionary *)dic{
    MovieCinemaModel * cinemaModel = [[MovieCinemaModel alloc]init];
    cinemaModel.name = dic[@""];
    cinemaModel.price = dic[@""];
    cinemaModel.screenings = dic[@""];
    cinemaModel.cinema_adress = dic[@""];
    
    return cinemaModel;
}
@end
