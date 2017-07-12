//
//  PHCategoryModel.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PHCategoryModel.h"
#import "PHSubCategoryModel.h"

@implementation PHCategoryModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"tag":PHSubCategoryModel.class};
    
}

@end
