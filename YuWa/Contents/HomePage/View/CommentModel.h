//
//  CommentModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/4.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopdetailModel.h"

@interface CommentModel : NSObject

//customer_uid": "4",
//"score": "3.0",
//"ctime": "1445435345",
//"seller_content": "",
//"customer_content": "还不错",
//"img_url": [],
//"customer_name": "18015885217",
//"customer_header_img": ""

@property(nonatomic,strong)NSString*customer_uid;
@property(nonatomic,strong)NSString*score;
@property(nonatomic,strong)NSString*ctime;
@property(nonatomic,strong)NSString*seller_content;
@property(nonatomic,strong)NSString*customer_content;
@property(nonatomic,strong)NSArray*img_url;
@property(nonatomic,strong)NSString*customer_name;
//@property(nonatomic,strong)NSString*customer_header_img;
@property(nonatomic,strong)NSString*customer_img;
@property(nonatomic,strong)NSArray*rep_list;
@property(nonatomic,strong)NSString*id;
//商家回复
@property(nonatomic,strong)NSMutableArray* shangJiaRep;

//一些店铺的信息  只有个人中心才有
//@property(nonatomic,strong)NSString*company_name;
//@property(nonatomic,strong)NSString*company_address;
//@property(nonatomic,strong)NSString*company_img;
//@property(nonatomic,strong)NSString*catname
//@property(nonatomic,strong)NSString*tag
@property(nonatomic,strong)ShopdetailModel*shop;   //店铺详情里面的数据

@end
