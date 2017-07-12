//
//  ResultsModel.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/25.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ResultsModel.h"

@implementation ResultsModel

+(instancetype)cellModel:(NSDictionary *)Model
{
    ResultsModel * hot = [self new];
    hot.title = Model[@"title"];
    hot.idd = Model[@"idd"];
    return hot;
}
@end
