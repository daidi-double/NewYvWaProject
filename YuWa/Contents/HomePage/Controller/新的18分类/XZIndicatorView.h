//
//  XZIndicatorView.h
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZIndicatorView : UIView
/** 初始化快捷方法 */
-(instancetype)initWithView:(UIView *)mapView withRatio:(CGFloat)ratio withScrollView:(UIScrollView *)myScrollview;

/** 滚动时更新 */
- (void)updateMiniIndicator;

/** 更新座位选中的图片 */
-(void)updateMiniImageView;

/** 隐藏 */
-(void)indicatorHidden;

@end
