//
//  JRSegmentViewController.h
//  JRSegmentControl
//
//  Created by 湛家荣 on 15/8/29.
//  Copyright (c) 2015年 湛家荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRSegmentControl.h"

@interface JRSegmentViewController : UIViewController

@property (nonatomic, copy) NSMutableArray *viewControllers;
@property (nonatomic, copy) NSArray *titles;

/** 指示视图的颜色 */     //选中时候的颜色   透明
@property (nonatomic, strong) UIColor *indicatorViewColor;
/** segment的背景颜色 */         // 无色
@property (nonatomic, strong) UIColor *segmentBgColor;




//选中的颜色
@property(nonatomic,strong)UIColor *selectedColor;

/**
 *  segment每一项的文字颜色     //没有选中的颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
//enableScroll   yes 能滚动  不设置 不能滚动
@property(nonatomic,assign)BOOL enableScroll;



/** segment每一项的宽 */
@property (nonatomic, assign) CGFloat itemWidth;
/** segment每一项的高 */
@property (nonatomic, assign) CGFloat itemHeight;

@end

