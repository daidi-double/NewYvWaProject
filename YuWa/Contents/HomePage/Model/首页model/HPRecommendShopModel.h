//
//  HPRecommendShopModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/10/31.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPRecommendShopModel : NSObject

@property(nonatomic,strong)NSString*company_img;
@property(nonatomic,strong)NSString*company_name;
@property(nonatomic,strong)NSString*star;
@property(nonatomic,strong)NSString*per_capita;   //人均
//@property(nonatomic,strong)NSString*category;
@property(nonatomic,strong)NSString*catname;    //属于哪一类
@property(nonatomic,strong)NSString*discount;   //打多少折
@property(nonatomic,strong)NSArray*holiday;     //特别活动
@property(nonatomic,strong)NSArray*tag_name;   //美食等 小标签

@property(nonatomic,strong)NSString*company_near;  //距离我多远
@property(nonatomic,strong)NSString*id;     //本店的id
@property(nonatomic,strong)NSString*cid;
@property(nonatomic,strong)NSString*coordinatex;
@property(nonatomic,strong)NSString*coordinatey;


@end
