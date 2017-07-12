//
//  PayRecordModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayRecordModel : NSObject
//{
//    "money" = 20.00,
//    "order_id" = 1,
//    "ctime" = 1481779417,
//    "type" = 1,
//    "type_name" = 直接介绍分红,
//}


@property(nonatomic,strong)NSString*ctime;
@property(nonatomic,strong)NSString*money;
@property(nonatomic,strong)NSString*type_name;

@property(nonatomic,strong)NSString*type;  //收支类型,1为收入,0为支出



@end
