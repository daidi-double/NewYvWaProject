//
//  CinemaDetailModel.h
//  YuWa
//
//  Created by double on 17/5/31.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaDetailModel : NSObject
@property (nonatomic,strong)NSString * id;
@property (nonatomic,strong)NSString * code;//影院
@property (nonatomic,strong)NSString * img_addr;//影院图片
@property (nonatomic,strong)NSString * province;
@property (nonatomic,strong)NSString * city;
@property (nonatomic,strong)NSString * county;
@property (nonatomic,strong)NSString * address;
@property (nonatomic,strong)NSString * longitude;
@property (nonatomic,strong)NSString * latitude;
@property (nonatomic,strong)NSString * goodstype;
@property (nonatomic,strong)NSString * minprice;
@property (nonatomic,strong)NSString * devicepos;
@property (nonatomic,strong)NSArray * feature;//标签
@property (nonatomic,strong)NSString * cinema_name;//影院名称
@property (nonatomic,strong)NSString * score;//评分
@property (nonatomic,strong)NSString * tel;//电话
@property (nonatomic,strong)NSString * feature_img;//影院特色图片
@end
