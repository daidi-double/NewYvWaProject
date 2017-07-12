//
//  YWMessageNotificationModel.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWMessageNotificationModel : NSObject

@property (nonatomic,copy)NSString * status;//1待处理 2已接受 3拒绝
@property (nonatomic,copy)NSString * shop_name;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * ctime;
@property (nonatomic,strong)NSArray * details;
@property (nonatomic,strong)NSString * pay_money;
@property (nonatomic,strong)NSString * order_id;
@property (nonatomic,strong)NSString * title;
@end
