//
//  WinnerModel.h
//  YuWa
//
//  Created by double on 17/3/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WinnerModel : NSObject
@property (nonatomic,copy) NSString * win_info;//一等奖
@property (nonatomic,copy) NSString * user_id;
@property (nonatomic,copy) NSString * code;
@property (nonatomic,assign) NSInteger  id;//奖品id
@property (nonatomic,copy) NSString * nickname;//昵称
@property (nonatomic,copy) NSString * username;//登入用户名
@property (nonatomic,copy) NSString * is_exchange;//是否兑换 0、1 0：表示未兑奖，1：表示已兑奖
@property (nonatomic,copy) NSString * is_kind;//0:表示非实物，1：表示实物
@end
