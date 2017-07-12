//
//  MovieHeaderModel.m
//  YuWa
//
//  Created by double on 17/2/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieHeaderModel.h"

@implementation MovieHeaderModel
+ (MovieHeaderModel*)movieHeaderModelWithDic:(NSDictionary *)dic{
    MovieHeaderModel * movieModel = [[MovieHeaderModel alloc]init];
    movieModel.title = dic[@"title"];
    movieModel.sub_title = dic[@""];
    movieModel.grade = dic[@""];
    movieModel.sort = dic[@""];
    movieModel.country_time = dic[@""];
    movieModel.play_time = dic[@""];
    movieModel.picUrl = dic[@""];
//    movieModel.isGrade = dic[@""];
//    movieModel.isWantLook = dic[@""];
    return movieModel;
}
@end
