//
//  JWBasicViewController.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/19.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBarButtonItem+SettingCustom.h"
#import "UIScrollView+JWGifRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "JWTools.h"
#import "HttpObject.h"

#import "JWSharedView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>

@interface JWBasicViewController : UIViewController

@property (nonatomic,strong)JWSharedView * shareView;

- (void)showHUDWithStr:(NSString *)showHud withSuccess:(BOOL)isSuccess;

- (void)backBarAction;
- (void)makeShareView;
- (void)makeNoticeWithTime:(NSTimeInterval)secs withAlertBody:(NSString *)con;

@end
