//
//  UserSession.h
//  NewVipxox
//
//  Created by 黄佳峰 on 16/8/31.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSession : NSObject

@property (nonatomic,assign)NSInteger uid;//uid
@property (nonatomic,copy)NSString * token;   //用户登录后标识
@property (nonatomic,copy)NSString * account;  //账户
@property (nonatomic,copy)NSString * password;   //密码
@property (nonatomic,copy)NSString * hxPassword;   //环信密码
@property (nonatomic,copy)NSString * inviteID;  //邀请ID
@property (nonatomic,copy)NSString * invite_code;//邀请码      

@property (nonatomic,copy)NSString * logo;//头像
@property (nonatomic,copy)NSString * nickName;//昵称
@property (nonatomic,copy)NSString * sex;//性别
@property (nonatomic,copy)NSString * birthDay;//生日
@property (nonatomic,copy)NSString * local;   //常驻地
@property (nonatomic,copy)NSString * personality;   //个人签名
@property (nonatomic,copy)NSString * businessAgreement;//商务会员协议
@property (nonatomic,copy)NSString * agreement;//用户协议


@property (nonatomic,copy)NSString * attentionCount;//关注数
@property (nonatomic,copy)NSString * fans;//粉丝
@property (nonatomic,copy)NSString * praised;//被赞数
@property (nonatomic,copy)NSString * collected;//被收藏
@property (nonatomic,copy)NSString * aldumCount;  //专辑个数
@property (nonatomic,copy)NSString * money; //钱
@property (nonatomic,copy)NSString * last_login_time;
@property (nonatomic,copy)NSString * reg_time;
@property (nonatomic,copy)NSString * status;
@property (nonatomic,copy)NSString * email;
@property (nonatomic,copy)NSString * sale_id;

//note_nums  album_nums  comment_nums
@property(nonatomic,strong)NSString*note_nums;    //多少条笔记
@property(nonatomic,strong)NSString*album_nums;    //多少个专辑
@property(nonatomic,strong)NSString*comment_nums;  //多少条评论
@property(nonatomic,strong)NSString*today_money;  //今日收益    今天到登录为止时候的介绍分红和商务分红相加的钱（不算积分分红）7天后才会结算这部分钱

@property (nonatomic,strong)NSNumber*isVIP;//是否是会员    1普通用户2销售        没有3商家了移除
@property (nonatomic,strong)NSString * bankName;//记录上次提现的银行卡
@property (nonatomic,strong)NSString * bankCard;//记录上次提现的银行卡号
//@property(nonatomic,copy)NSString * currency; //货币
//已经登录
@property(nonatomic,assign)BOOL isLogin;   //是否登录   （这个要自己给他）

@property (nonatomic,assign)NSInteger baobaoLV;    //雨娃宝宝等级
@property (nonatomic,assign)NSInteger baobaoEXP;    //宝宝的经验
@property (nonatomic,assign)NSInteger baobaoNeedEXP;   //宝宝升级需要的经验
//记录环信是否登录成功，成功是 yes  失败是NO；
@property (nonatomic, assign)  BOOL isLoginHX;
+(UserSession*)instance;  //创建单例
+(void)clearUser;   //退出登录 删除数据

+ (void)saveUserLoginWithAccount:(NSString *)account withPassword:(NSString *)password;  //save login data

+ (void)saveUserInfoWithDic:(NSDictionary *)dataDic;//save user data
+ (void)autoLoginRequestWithPragram:(NSDictionary *)pragram;

@end
