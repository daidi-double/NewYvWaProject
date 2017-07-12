//
//  ShopDetailGoodsModel.h
//  YuWa
//
//  Created by double on 17/4/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDetailGoodsModel : NSObject
@property(nonatomic,strong)NSString*goods_id;
@property(nonatomic,strong)NSString*goods_name;
@property(nonatomic,strong)NSString*goods_cat_id;//商品分类id
@property(nonatomic,strong)NSString*uid;
@property(nonatomic,strong)NSString*num;
@property(nonatomic,strong)NSString*goods_num;
@property(nonatomic,strong)NSString*shop_id;
@property(nonatomic,strong)NSString*goods_info;
@property(nonatomic,strong)NSString*goods_price;
@property(nonatomic,strong)NSString*goods_disprice;//折后价格
@property(nonatomic,strong)NSString*goods_img;
@property(nonatomic,strong)NSString*ctime;
@property(nonatomic,strong)NSString*month_sales;//月销售量
@property (nonatomic,strong)NSString * number;

@end
