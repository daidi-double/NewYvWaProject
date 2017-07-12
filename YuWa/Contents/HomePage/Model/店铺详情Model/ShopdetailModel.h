//
//  ShopdetailModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/3.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopdetailModel : NSObject
//"id": "12",
//"cid": "1",
//"is_top": "1",
//"company_name": "美食商家12",
//"company_img": "http://114.215.252.104/Public/Upload/20161031/14779191114984.png",
//"company_address": "",
//"company_near": "虹桥",
//"company_first_tel": "",
//"company_second_tel": "",
//"per_capita": "100",
//"discount": "8.5",
//"star": "1.0",
//"score": "0.0",
//"coordinatex": "",
//"coordinatey": "",
//"begin_time": "0",
//"end_time": "0",
//"company_mark": "",
//"ctime": "0",
//"infrastructure": [],
//"holiday": [ ],
//"goods": [ ],
//"comment": [ ],
//"total_photo": "0",
//"back_photo": null,
//"recommend_shop": []
//}

@property(nonatomic,strong)NSString*pay_discount;    //支付的折扣（已经是最低了，和平时与节日的对比过了）
@property(nonatomic,strong)NSString*id;      //店铺id
@property(nonatomic,strong)NSString*cid;      //类id
@property(nonatomic,strong)NSString*is_top;    //是否首页推荐
@property(nonatomic,strong)NSString*company_name;    //店铺名字
@property(nonatomic,strong)NSString*company_img;     //店铺图片
@property(nonatomic,strong)NSString*company_address;    //店铺地址
@property(nonatomic,strong)NSString*company_near;       //店铺附近
@property(nonatomic,strong)NSString*company_first_tel;    //第一个号码
@property(nonatomic,strong)NSString*company_second_tel;   //第二个号码
@property(nonatomic,strong)NSString*per_capita;            //人均
@property(nonatomic,strong)NSString*discount;             //打折力度
@property(nonatomic,strong)NSString*star;                 //几个星
@property(nonatomic,strong)NSString*score;                //多少分  没用
@property(nonatomic,strong)NSString*coordinatex;           //经度
@property(nonatomic,strong)NSString*coordinatey;           //维度
@property(nonatomic,strong)NSString*begin_time;           //开始时间  没用
@property(nonatomic,strong)NSString*end_time;           //结束时间    没用
@property(nonatomic,strong)NSString*company_mark;     //连锁快餐？ 没用
@property(nonatomic,strong)NSString*ctime;            //没用
@property(nonatomic,strong)NSString*total_photo;       //总共图片的个数
@property(nonatomic,strong)NSString*back_photo;     //背景图片地址
@property(nonatomic,strong)NSString*catname; //那个大类
@property(nonatomic,strong)NSString*tag;   //标签
@property(nonatomic,strong)NSString*total_comment;   //总评论数
@property(nonatomic,strong)NSString*top_than_other;  //高于同行
@property(nonatomic,assign)BOOL is_collection;   //1为已经收藏  0为未收藏
@property(nonatomic,strong)NSString*order_nums ;
@property (nonatomic,strong)NSString * monthSale;//月销售量

@property(nonatomic,strong)NSArray*infrastructure;           //商家详情
@property(nonatomic,strong)NSArray*holiday;           // 活动
@property(nonatomic,strong)NSArray*goods;           //  推荐商品
@property(nonatomic,strong)NSArray*comment;           //  评论
@property(nonatomic,strong)NSArray*recommend_shop;           //推荐店铺
@property(nonatomic,strong)NSArray * business_hours;//营业时间
@property(nonatomic,strong)NSArray*tag_name;//所属分类
@property (nonatomic,strong)NSArray * cart;//购物车内容

@end
