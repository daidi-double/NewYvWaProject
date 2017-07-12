//
//  CityCodeModel.h
//  YuWa
//
//  Created by double on 17/5/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityCodeModel : NSObject
@property (nonatomic,copy) NSString * name;//地区名称
@property (nonatomic,copy) NSString * cinema_count;//影院数量
@property (nonatomic,copy) NSString * code;//地区编码
@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * parent_code;//本地区所属地区的编码

@end
