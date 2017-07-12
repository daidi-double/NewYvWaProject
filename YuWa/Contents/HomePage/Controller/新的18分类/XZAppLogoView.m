//
//  XZAppLogoView.m
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "XZAppLogoView.h"
#import "UIView+Frame.h"
@implementation XZAppLogoView

- (void)drawRect:(CGRect)rect {
    
    UIImage *appLogo = [UIImage imageNamed:@"yuwagrayBG.png"];//这里更换你applogo图标
    
    [appLogo drawInRect:rect];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
