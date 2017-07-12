//
//  YWCarListModel.h
//  YuWa
//
//  Created by double on 17/4/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWCarListModel : NSObject

@property (nonatomic,strong)NSString * company_name;
@property (nonatomic,strong)NSString * company_img;
@property (nonatomic,strong)NSString * id;
@property (nonatomic,strong)NSString * discount;
@property (nonatomic,strong)NSString * pay_discount;
@property (nonatomic,strong)NSArray * cart;

//+(YWCarListModel *)listModelWithDic:(NSDictionary*)dic;
@end
