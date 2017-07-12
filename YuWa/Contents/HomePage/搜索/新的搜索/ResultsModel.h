//
//  ResultsModel.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/25.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultsModel : NSObject
/** 热搜名词 */
@property (nonatomic, copy) NSString * title;

/** 热搜id */
@property (nonatomic, strong) NSString* idd;

+(instancetype)cellModel:(NSDictionary *)Model;
@end
