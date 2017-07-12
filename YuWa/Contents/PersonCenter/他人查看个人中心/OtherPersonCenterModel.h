//
//  OtherPersonCenterModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    "data" = {
//        "praised" = 0,
//        "attentioncount" = 1,
//        "is_fans" = 0,
//        "album_nums" = 2,
//        "address" = ,
//        "header_img" = http://114.215.252.104/Public/Upload/20161118/14794599234401.png,
//        "collected" = 0,
//        "fans" = 0,
//        "nickname" = Scarlet,
//        "mark" = ,
//        "note_nums" = 6,
//        "comment_nums" = 6,
//    },



@interface OtherPersonCenterModel : NSObject

@property(nonatomic,strong)NSString*username;  //环信的用户名
@property(nonatomic,strong)NSString*address; //地址
@property(nonatomic,strong)NSString*nickname; //
@property(nonatomic,strong)NSString*header_img;
@property(nonatomic,strong)NSString*mark;        //个性签名

@property(nonatomic,strong)NSString*is_fans;  //是粉丝，是否关注

@property(nonatomic,strong)NSString*attentioncount;
@property(nonatomic,strong)NSString*fans;
@property(nonatomic,strong)NSString*praised;
@property(nonatomic,strong)NSString*collected;

@property(nonatomic,strong)NSString*note_nums;  //多少条笔记
@property(nonatomic,strong)NSString*album_nums;  //专辑的数量
@property(nonatomic,strong)NSString*comment_nums; //评论数

@property(nonatomic,strong)NSString*user_type;
@end
