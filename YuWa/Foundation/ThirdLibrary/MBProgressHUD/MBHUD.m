//
//  MBHUD.m
//  GKAPP
//
//  Created by 黄佳峰 on 15/11/11.
//  Copyright © 2015年 黄佳峰. All rights reserved.
//

#import "MBHUD.h"

@implementation MBHUD


-(void)showCustomDialog:(NSString*)str {
//    HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
//    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
//    HUD.labelText = str;
//    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] ;
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        sleep(2);
//    } completionBlock:^{
//        [HUD removeFromSuperview];
//               HUD = nil;
//    }];
    
    HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)=
    NSString * path = [[NSBundle mainBundle]pathForResource:@"37x-Checkmark" ofType:@"png"];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]] ;
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.delegate = self;
    HUD.labelText = str;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:3];


    
    
}
@end
