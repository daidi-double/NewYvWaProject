//
//  AppDelegate.m
//  NewVipxox
//
//  Created by 黄佳峰 on 16/8/29.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+window.h"
#import "VIPTabBarController.h"
#import <Hyphenate/Hyphenate.h>
//#import "EMSDK.h"
#import "EaseUI.h"

#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "VoiceChatViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

//  支付
#import "PCPayViewController.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UPPaymentControl.h"
//启动动画
#import "YWStartAnimation.h"

#import "YWMessageNotificationViewController.h"
#import "YWMessageChatViewController.h"
#import "UMMobClick/MobClick.h"//crash 崩溃监控日志

@interface AppDelegate ()<EMContactManagerDelegate,EMChatManagerDelegate,EMGroupManagerDelegate,EMClientDelegate,JPUSHRegisterDelegate,WXApiDelegate,EMCallManagerDelegate>

@end

@implementation AppDelegate
@synthesize splashView;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerShareSDK];//ShareSDK配置
    [self registerEMClientWithApplication:application withOptions:(NSDictionary *)launchOptions];//registerEMClient
    [self registerJPushWithOptions:launchOptions];
    
    [UserSession instance];
    [YWLocation shareLocation];
    //集成友盟crash日志记录
    [self umengTrack];
#pragma mark  --微信支付
    //向微信注册wxd930ea5d5a258f4f
    [WXApi registerApp:@"wxda48c07f355bc825" withDescription:@"demo 2.0"];
#pragma mark  ----国际化语言
    [InternationalLanguage initUserLanguage];//初始化应用语言
#pragma mark  -- 根视图
    
    VIPTabBarController *tabBar=[[VIPTabBarController alloc]init];
    self.window= [AppDelegate windowInitWithRootVC:tabBar];
    
#pragma mark -- 启动页动画
    [self.window makeKeyAndVisible];
    [YWStartAnimation startAnimationWithView:self.window];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];   //清除角标
    [application cancelAllLocalNotifications];
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - ShareSDK
- (void)registerShareSDK{//调用registerApp方法来初始化SDK并且初始化第三方平台
    /**
     *  设置ShareSDK的appKey
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"17e6aee320f88"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType){
                     switch (platformType){
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo){
              
              switch (platformType){
                  case SSDKPlatformTypeSinaWeibo:
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"2515778668" appSecret:@"918c341ba8373fc356e1f308c6ee9305" redirectUri:@"http://www.sharesdk.cn" authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"101358926" appKey:@"4156927df9c4853af6f383f0e78bd9e8" authType:SSDKAuthTypeBoth];
                      break;
                      
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wxe1688beb5d248457" appSecret:@"0a8cc210c9d05f4841ddcf9815f1d491"];
                      break;
                  default:
                      break;
              }
          }];
}

#pragma mark - EMClient
- (void)registerEMClientWithApplication:(UIApplication *)application withOptions:(NSDictionary *)launchOptions{
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"YvWaNotificationDevelop";
#else
    apnsCertName = @"YvWaNotificationProducation";
#endif
    NSString * appkey= @"ceoshanghaidurui#duruikejiyuwa";
    
    
    EMOptions *options = [EMOptions optionsWithAppkey:appkey];
    options.apnsCertName = apnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];//好友代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];//登录代理
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    //注册实时通话回调
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:appkey apnsCertName:apnsCertName otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];

    //iOS10 注册APNs
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                [application registerForRemoteNotifications];
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeSound| UIRemoteNotificationTypeAlert) categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else {
            
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert)];
        }
        
        
    }
#endif
    
}


/*!
 *  \~chinese
 *  用户A拨打用户B，用户B会收到这个回调
 *
 *  @param aSession  会话实例
 *
 */

- (void)callDidReceive:(EMCallSession *)aSession{
    NSLog(@" 用户A拨打用户B，用户B会收到这个回调");
    VoiceChatViewController * voiceVC = [[VoiceChatViewController alloc]init];
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    voiceVC.callSession = aSession;
    voiceVC.remoteUsername = aSession.remoteName;
    if (aSession.type == 0) {
        voiceVC.isSender = NO;
        voiceVC.status = 1;
        voiceVC.conversation = [[EMClient sharedClient].chatManager getConversation:aSession.remoteName type:EMConversationTypeChat createIfNotExist:YES];
    }else{//视频
        voiceVC.type = 1;
        voiceVC.status = 1;
        voiceVC.isSender = NO;
        
        
    }
    [topRootViewController presentViewController:voiceVC animated:YES completion:nil];
    
    
}
- (void)didReceiveMessages:(NSArray *)aMessages{
    YWMessageChatViewController * chatVC = [[YWMessageChatViewController alloc]init];
    UIApplication * application = [UIApplication sharedApplication];
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
     for(EMMessage *message in aMessages){
          BOOL needShowNotification = (message.chatType = EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
         if (needShowNotification) {
             
             [chatVC showNotificationWithMessage:message];
         }
     }
}

#pragma mark - private
- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getGroupsWithoutPushNotification:nil];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage{
    NSMutableArray * friendsRequest = [NSMutableArray arrayWithArray:[KUSERDEFAULT valueForKey:FRIENDSREQUEST]];
    NSDictionary * requestDic = @{@"hxID":aUsername,@"message":aMessage,@"status":@"0"};//0未读1未处理2同意3拒绝
    if (!friendsRequest)friendsRequest = [NSMutableArray arrayWithCapacity:0];
    [friendsRequest insertObject:requestDic atIndex:0];
    [KUSERDEFAULT setObject:friendsRequest forKey:FRIENDSREQUEST];
}

- (void)didLoginFromOtherDevice{//当前登录账号在其它设备登录时会接收到该回调
    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
}
- (void)didRemovedFromServer{//当前登录账号已经被从服务器端删除时会收到该回调
    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
}

#pragma mark - JPush
- (void)saveJupshNotificationDicWithDic:(NSDictionary *)dic{
    NSMutableArray * jpushArr = [NSMutableArray arrayWithArray:[KUSERDEFAULT valueForKey:JPush_Notification_DicArr]];
    if (!jpushArr)jpushArr = [NSMutableArray arrayWithCapacity:0];
    [jpushArr insertObject:dic atIndex:0];
    [KUSERDEFAULT setObject:jpushArr forKey:JPush_Notification_DicArr];
    
    //起别名
}

- (void)registerJPushWithOptions:(NSDictionary *)launchOptions{
    //    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {//可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    
    NSString * appKey = @"e5d6efcb778acab672b43b94";
    
    BOOL isProduction = NO;
#if DEBUG
    isProduction = NO;
#else
    isProduction = YES;
#endif
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:@"App Store" apsForProduction:isProduction advertisingIdentifier:nil];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            MyLog(@"registrationID获取成功：%@",registrationID);
        }else{
            MyLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {/// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {//Optional
    MyLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    MyLog(@"离线推送注册失败error -- %@",error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    MyLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        [self saveJupshNotificationDicWithDic:userInfo];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    
#else
    //    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
#endif
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        MyLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
        [self saveJupshNotificationDicWithDic:userInfo];
        
    }else {// 判断为本地通知
        MyLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        [self saveJupshNotificationDicWithDic:userInfo];
        //        YWMessageNotificationViewController*vc=[[YWMessageNotificationViewController alloc]init];
        //        UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:vc];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
        //        [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString * filePath1 = [documentPath stringByAppendingPathComponent:@"push.plist"];
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath1];
        if ([dic objectForKey:@"ispush"]) {
            //表示存在这个key，
            [dic setValue:@"1" forKey:@"ispush"];
        }else{
            [dic setValue:@"1" forKey:@"ispush"];
        }
        [dic writeToFile:filePath1 atomically:YES];
        
        VIPTabBarController *tabBar=[[VIPTabBarController alloc]init];
        self.window= [AppDelegate windowInitWithRootVC:tabBar];
        //发送通知。是远程推送的通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"didReceiveNotification" object:nil];
    }else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count])return nil;
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    
    
    return str;
}



///本地添加
- (void)addLocalPushNotificationWithTime:(NSTimeInterval)secs withAlertBody:(NSString *)con{
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    //    center.delegate = self;
    content.title = @"雨娃宝";// 标题
    content.subtitle = @"";// 子标题
    content.body = con;// 内容
    content.badge = @0;// 标记个数
    content.sound = [UNNotificationSound defaultSound];// 推送提示音
    // content.sound = [UNNotificationSound soundNamed:@"音频文件名"];// 指定音频文件
    //    content.launchImageName = @"Default";// 启动图片(好像不起作用)
    content.userInfo = @{@"name":@"YWLocalNotifiction"};// 附加信息
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"puff.jpg" ofType:nil];// 添加附件
    //    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"mazy" URL:[NSURL fileURLWithPath:filePath] options:0 error:nil];
    //    content.attachments = @[attachment];
    
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:secs+0.1 repeats:NO];// 通过时间差，多少秒后推送本地推送
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"YWLocalNotifiction" content:content trigger:trigger];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            MyLog(@"推送添加成功");
        }
    }];
    
    
#else
    UILocalNotification *notification = [[UILocalNotification alloc] init];// 创建一个本地推送
    NSDate * nowDate = [NSDate dateWithTimeIntervalSinceNow:secs];// secs 秒 后 推送一条消息
    
    if (notification != nil) {
        notification.fireDate = nowDate;// 设置推送时间
        notification.timeZone = [NSTimeZone defaultTimeZone];// 设置时区
        notification.repeatInterval = 0;// 设置重复间隔
        notification.soundName =UILocalNotificationDefaultSoundName;// 推送声音
        notification.alertBody = con;// 推送内容
        //        notification.applicationIconBadgeNumber = 1;//显示在icon上的红色圈中的数子
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name" forKey:@"YWLocalNotifiction"];
        notification.userInfo = info;//设置userinfo 方便在之后需要撤销的时候使用
        UIApplication *app = [UIApplication sharedApplication];//添加推送到UIApplication
        [app scheduleLocalNotification:notification];
    }
#endif
}

//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"雨娃宝" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//
//    [alert show];
////    application.applicationIconBadgeNumber -= 1;// 图标上的数字减1
//    MyLog(@"didReceiveLocalNotification");
//
//}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if(buttonIndex == 1){
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://fir.im/XXXX"]];
//    }
//}




- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
        return YES;
    }
    if ([url.host isEqualToString:@"uppayresult"]) {
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            if (self.unionpayBlock) {
                self.unionpayBlock(data);
                
            }
            
            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
        }];
        
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            if([code isEqualToString:@"success"]) {
                
                //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
            }
            
            else if([code isEqualToString:@"fail"]) {
                //交易失败
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
            }
        }];
        return YES;
        
    }
    
    return  [WXApi handleOpenURL:url delegate:[PCPayViewController sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
        return YES;
    }
    if ([url.host isEqualToString:@"uppayresult"]) {
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            if([code isEqualToString:@"success"]) {
                
                
                //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
            }
        }];
        return YES;
        
    }
    
    return  [WXApi handleOpenURL:url delegate:[PCPayViewController sharedManager]];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //用户中途退出
            NSLog(@"result = %@",resultDic);
            if (self.aliPayBlock) {
                self.aliPayBlock(resultDic);
            }
            
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
        return YES;
    }
    if ([url.host isEqualToString:@"uppayresult"]) {
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            if (self.unionpayBlock) {
                self.unionpayBlock(data);
                
            }
            
            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
        }];
        
        
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            if([code isEqualToString:@"success"]) {
                
                //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
            }
            
            else if([code isEqualToString:@"fail"]) {
                //交易失败
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
            }
        }];
        return YES;
        
    }
    
    return  [WXApi handleOpenURL:url delegate:[PCPayViewController sharedManager]];
    
}
- (void)umengTrack {
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"592f8adc45297d77e9001477";
    UMConfigInstance.secret = @"secretstringaldfkals";
    //    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
}
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
//    // NSData转为NSString
//    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
// 
@end
