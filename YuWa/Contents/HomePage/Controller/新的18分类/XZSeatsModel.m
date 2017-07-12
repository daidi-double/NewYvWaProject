//
//  XZSeatsModel.m
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "XZSeatsModel.h"

@implementation XZSeatsModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{ @"columns":@"XZSeatModel"};
}
+(XZSeatsModel*)XZSeatsModelWithAry:(NSMutableArray *)ary
{
    XZSeatsModel * XZModel = [[XZSeatsModel alloc]init];

    return XZModel;
}
@end
