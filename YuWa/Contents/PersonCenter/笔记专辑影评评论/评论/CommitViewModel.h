//
//  CommitViewModel.h
//  YuWa
//
//  Created by 黄佳峰 on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommitViewModel : NSObject
@property(nonatomic,strong)NSString*photoImage;   //用户头像
@property(nonatomic,strong)NSString*userName;      //用户名字
@property(nonatomic,strong)NSString*pointNumber;    //用户打了几分   只能是整数小于等于5
@property(nonatomic,strong)NSString*date;         //日期
@property(nonatomic,strong)NSString*content;      //评论的内容
@property(nonatomic,strong)NSArray*images;        //评论的图片

//商家的店名
//商家的地址
//店铺的图片
//店铺的大分类
//店铺的小分类
//店铺的id  用于跳转


@end
