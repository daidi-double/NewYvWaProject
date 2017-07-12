//
//  UserSession.m
//  NewVipxox
//
//  Created by 黄佳峰 on 16/8/31.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "UserSession.h"
#import "JPUSHService.h"
#import "HttpObject.h"
#import "JWTools.h"

@implementation UserSession
static UserSession * user=nil;

+ (UserSession*)instance{
    if (!user) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            user=[[UserSession alloc]init];
        });
        user.token=@"";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [UserSession getDataFromUserDefault];
        });
    }
    
    return user;
}


+ (void)clearUser{
    [UserSession saveUserLoginWithAccount:@"" withPassword:@""];
    user = nil;
    user=[[UserSession alloc]init];
    user.token=@"";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient].options setIsAutoLogin:NO];
        
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error){
            MyLog(@"环信退出成功");
            [UserSession instance].isLoginHX = NO;
        }
        [UserSession getDataFromUserDefault];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
        });
        
        NSMutableArray * friendsRequest = [NSMutableArray arrayWithArray:[KUSERDEFAULT valueForKey:FRIENDSREQUEST]];
        friendsRequest = [NSMutableArray arrayWithCapacity:0];
        [KUSERDEFAULT setObject:friendsRequest forKey:FRIENDSREQUEST];
    });
}

+ (void)saveUserLoginWithAccount:(NSString *)account withPassword:(NSString *)password{
    user.account = account;
    [KUSERDEFAULT setValue:account forKey:AUTOLOGIN];
    user.password = password;
    [KUSERDEFAULT setValue:password forKey:AUTOLOGINCODE];
}

//get local saved data
+ (void)getDataFromUserDefault{
    NSString * accountDefault = [KUSERDEFAULT valueForKey:AUTOLOGIN];
    if (accountDefault) {
        if ([accountDefault isEqualToString:@""])return;
        
        user.account = accountDefault;
        user.password = [KUSERDEFAULT valueForKey:AUTOLOGINCODE];
        [UserSession autoLoginRequestWithPragram:@{@"phone":user.account,@"password":user.password,@"is_md5":@1}];
    }
}

//auto login
+ (void)autoLoginRequestWithPragram:(NSDictionary *)pragram{
    [[HttpObject manager]postNoHudWithType:YuWaType_Logion withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [UserSession saveUserInfoWithDic:responsObj[@"data"]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            EMError *errorLog = [[EMClient sharedClient] loginWithUsername:user.account password:user.hxPassword];
            if (!errorLog){
                [[EMClient sharedClient].options setIsAutoLogin:NO];
                [[EMClient sharedClient].chatManager getAllConversations];
                MyLog(@"环信登录成功");
                [UserSession instance].isLoginHX = YES;
            }else{
                [UserSession instance].isLoginHX = NO;
                //登录失败，就重新登录一次；
                EMError *errorLog = [[EMClient sharedClient] loginWithUsername:user.account password:user.hxPassword];
                if (!errorLog){
                    [[EMClient sharedClient].options setIsAutoLogin:NO];
                    [[EMClient sharedClient].chatManager getAllConversations];
                    MyLog(@"环信登录成功");
                    [UserSession instance].isLoginHX = YES;
                }else{
                    [UserSession instance].isLoginHX = NO;
                }
            }
            
            [JPUSHService setAlias:user.account callbackSelector:nil object:nil];
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
    }];
}

//解析登录返回数据
+ (void)saveUserInfoWithDic:(NSDictionary *)dataDic{
    user.token = dataDic[@"token"];
    user.uid = [dataDic[@"id"] integerValue];
    user.nickName = dataDic[@"nickname"];
    user.birthDay = dataDic[@"birthday"];
    user.password = dataDic[@"password"];
    [KUSERDEFAULT setValue:user.password forKey:AUTOLOGINCODE];
    user.hxPassword = dataDic[@"mobile"];
    user.local = dataDic[@"address"];
    
    NSArray * SexArr = @[@"男",@"女",@"未知"];
    NSNumber* sexNum=dataDic[@"sex"];
    NSInteger sexInt=[sexNum integerValue];
    if (sexInt>0&&sexInt<=3) {
        user.sex = [NSString stringWithFormat:@"%@",SexArr[sexInt-1]];

    }
    
    user.money = dataDic[@"money"];
    user.inviteID = dataDic[@"invite_uid"];
    user.invite_code = dataDic[@"invite_code"];
    user.logo = dataDic[@"header_img"];
    user.personality = dataDic[@"mark"];
    user.aldumCount = dataDic[@"aldumcount"];
    user.collected = dataDic[@"collected"];
    user.praised = dataDic[@"praised"];
    user.attentionCount = dataDic[@"attentioncount"];
    user.fans = dataDic[@"fans"];
    user.isVIP = dataDic[@"user_type"];
    user.last_login_time = dataDic[@"last_login_time"];
    user.status = dataDic[@"status"];
    user.reg_time = dataDic[@"reg_time"];
    user.sale_id = dataDic[@"sale_id"];
    user.email = dataDic[@"email"];
    user.baobaoLV = [dataDic[@"level"] integerValue];
    user.baobaoEXP = [dataDic[@"energy"] integerValue];
    NSInteger needExp = [dataDic[@"update_level_energy"] integerValue];
    user.baobaoNeedEXP = needExp?needExp>0?needExp:13500:13500;
    
    user.note_nums=dataDic[@"note_nums"];
    user.album_nums=dataDic[@"album_nums"];
    user.comment_nums=dataDic[@"comment_nums"];
    user.today_money=dataDic[@"today_money"];
    
    user.isLogin = YES;
}

@end
