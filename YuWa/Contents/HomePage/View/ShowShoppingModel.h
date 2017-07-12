//
//  ShowShoppingModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/4.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopDetailGoodsModel.h"
@interface ShowShoppingModel : NSObject
//@property(nonatomic,strong)NSString*goods_img;
//@property(nonatomic,strong)NSString*goods_info;
//@property(nonatomic,strong)NSString*goods_name;
//@property(nonatomic,strong)NSString*goods_price;
//新的
@property(nonatomic,strong)NSString*id;
@property(nonatomic,strong)NSString*shop_id;
@property(nonatomic,strong)NSString*cat_name;
@property(nonatomic,strong)NSArray*cat_goods;
@property(nonatomic,strong)NSString*ctime;
@property(nonatomic,strong)NSString * cat_goods_num;
//+(ShowShoppingModel*)modelWithDic:(NSDictionary*)dic;
@end
