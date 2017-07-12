//
//  BusinessMumberHeaderView.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessMumberHeaderView : UIView

@property(nonatomic,strong)void(^TotailBlock)();
@property(nonatomic,strong)void(^waitBlock)();
@property (nonatomic,strong)UILabel * today_money;//今日收益
@property (nonatomic,strong)UILabel * label2;//今日收益标题
@property (nonatomic,strong)UILabel * all_money;//总收益
@property (nonatomic,strong)UILabel * label3;//总收益标题
@property (nonatomic,strong)UILabel * jifen;//积分
@property (nonatomic,strong)UILabel * jifenTitle;
@end
