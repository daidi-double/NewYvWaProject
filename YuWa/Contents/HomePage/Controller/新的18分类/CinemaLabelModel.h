//
//  CinemaLabelModel.h
//  YuWa
//
//  Created by double on 17/5/31.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaLabelModel : NSObject
@property (nonatomic,strong)NSString * id;
@property (nonatomic,strong)NSString * cinema_id;
@property (nonatomic,strong)NSString * name;//标签名称
@property (nonatomic,strong)NSString * introduce;//简介
@property (nonatomic,strong)NSString * add_time;//
@property (nonatomic,strong)NSString * updata_time;
@property (nonatomic,strong)NSString * status;//1未删除 2删除
@property (nonatomic,strong)NSString * sort;//排序，越大越优先
@end
