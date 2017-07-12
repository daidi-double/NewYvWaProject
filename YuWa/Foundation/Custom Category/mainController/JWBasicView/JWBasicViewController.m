//
//  JWBasicViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/19.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWBasicViewController.h"
#import "AppDelegate.h"
//#import "YWSharedEditorViewController.h"//自定义编辑分享
#import "JWLocalNotificationShowView.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

@interface JWBasicViewController ()

@end

@implementation JWBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - Notice
- (void)makeNoticeWithTime:(NSTimeInterval)secs withAlertBody:(NSString *)con{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate addLocalPushNotificationWithTime:secs withAlertBody:con];
    JWLocalNotificationShowView * showView = [[[NSBundle mainBundle]loadNibNamed:@"JWLocalNotificationShowView" owner:self options:nil]firstObject];
    showView.conLabel.text = con;
    [[UIApplication sharedApplication].keyWindow addSubview:showView];
    [UIView animateWithDuration:2.f animations:^{
        showView.alpha = 0.3f;
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
    }];
}

#pragma mark - MBProgressHUD
- (void)showHUDWithStr:(NSString *)showHud withSuccess:(BOOL)isSuccess{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = showHud;
    if (isSuccess) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"37x-Checkmark" ofType:@"png"];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    }
    hud.alpha = 0.55;
    hud.mode = MBProgressHUDModeCustomView;
//    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.88];
}

- (void)backBarAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Share
- (void)makeShareView{
    if (!self.shareView) {
        self.shareView = [[JWSharedView alloc]init];
        WEAKSELF;//SSDKPlatformType
        self.shareView.shareClickBlock = ^(SSDKPlatformType shareType){
            [weakSelf shareButtonClickHandlerWithType:shareType];
        };
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
}

- (void)shareButtonClickHandlerWithType:(SSDKPlatformType)shareType{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"shareLogo"]];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    if (shareType == SSDKPlatformTypeSinaWeibo) {
        //新浪微博
        [shareParams SSDKSetupSinaWeiboShareParamsByText:@"雨娃宝" title:@"雨娃宝" image:imageArray[0] url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHARE_HTTP,[JWTools stringThirtyTwoWithNumberTenBase:[UserSession instance].account]]] latitude:0.f longitude:0.f objectID:nil type:SSDKContentTypeAuto];
    }else if (shareType == SSDKPlatformSubTypeQZone){
        [shareParams SSDKSetupQQParamsByText:@"" title:@"雨娃宝" url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHARE_HTTP,[JWTools stringThirtyTwoWithNumberTenBase:[UserSession instance].account]]] thumbImage:imageArray[0] image:imageArray[0] type:SSDKContentTypeAuto forPlatformSubType:shareType];//SSDKPlatformSubTypeQZone或者SSDKPlatformSubTypeQQFriend其中一个
    }else{
        //微信(微信好友SSDKPlatformSubTypeWechatSession，微信朋友圈SSDKPlatformSubTypeWechatTimeline)应用
        [shareParams SSDKSetupWeChatParamsByText:@"" title:@"雨娃宝" url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHARE_HTTP,[JWTools stringThirtyTwoWithNumberTenBase:[UserSession instance].account]]] thumbImage:imageArray[0] image:imageArray[0] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:shareType];
    }
    
    //3、直接分享
    [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:{//分享成功
                [self showHUDWithStr:@"分享成功" withSuccess:YES];
                break;
            }
            case SSDKResponseStateFail:{//分享失败
                if ((shareType ==SSDKPlatformSubTypeWechatSession||shareType ==SSDKPlatformSubTypeWechatTimeline)&&![WXApi isWXAppInstalled]) {//没有安装微信
                    MyLog(@"没有安装微信!");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有安装微信" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    
                    [alert show];
                }else if (shareType ==SSDKPlatformSubTypeQZone&&![QQApiInterface isQQInstalled]){//没有安装微信
                    MyLog(@"没有安装QQ!");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有安装QQ" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    
                    [alert show];
                }else{
                    [self showHUDWithStr:@"分享失败" withSuccess:NO];
                }
                
                break;
            }case SSDKResponseStateCancel:{
                [self showHUDWithStr:@"分享已取消" withSuccess:NO];
            }
            default:
                break;
        }
    }];
    
    //    2.编辑页面
    //    [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundColor:CNaviColor];
    //    [SSUIEditorViewStyle setTitleColor:[UIColor whiteColor]];
    //    [SSUIEditorViewStyle setCancelButtonLabelColor:[UIColor whiteColor]];
    //    [SSUIEditorViewStyle setShareButtonLabelColor:[UIColor whiteColor]];
    //    [SSUIEditorViewStyle setTitle:@"分享"];
    //    [SSUIEditorViewStyle setCancelButtonLabel:@"  取消"];
    //    [SSUIEditorViewStyle setShareButtonLabel:@"确认  "];
    //    [SSUIEditorViewStyle setStatusBarStyle:UIStatusBarStyleDefault];
    
    //3、分享
//    [ShareSDK showShareEditor:shareType otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//        switch (state) {
//            case SSDKResponseStateSuccess:{//分享成功
//                break;
//            }
//            case SSDKResponseStateFail:{//分享失败
//                if ((shareType ==SSDKPlatformSubTypeWechatSession||shareType ==SSDKPlatformSubTypeWechatTimeline)&&![WXApi isWXAppInstalled]) {//没有安装微信
//                    MyLog(@"没有安装微信!");
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有安装微信" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//                    
//                    [alert show];
//                }else if (shareType ==SSDKPlatformSubTypeQZone&&![QQApiInterface isQQInstalled]){//没有安装微信
//                    MyLog(@"没有安装QQ!");
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有安装QQ" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//                    
//                    [alert show];
//                }else{
//                    [self showHUDWithStr:@"分享失败" withSuccess:NO];
//                }
//                
//                break;
//            }
//            case SSDKResponseStateCancel:{
//                [self showHUDWithStr:@"分享已取消" withSuccess:NO];
//            }
//            default:
//                break;
//        }
//        
//    }];
    
}


@end
