//
//  MyIncomeModel.h
//  YuWa
//
//  Created by double on 17/3/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyIncomeModel : NSObject

//今日、昨天日期
//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间，几点
//@property (weak, nonatomic) IBOutlet UIImageView *fenhongImageView;//分红图标
//@property (weak, nonatomic) IBOutlet UILabel *fenhongNameLabel;//分红类别名称
//@property (weak, nonatomic) IBOutlet UILabel *myMoneyLabel;//我的余额
//@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;//日期2017.12.12
//@property (weak, nonatomic) IBOutlet UILabel *payMoney;//收入或者支出

@property (nonatomic,copy)NSString * week;
@property (nonatomic,copy)NSString * ctime;
@property (nonatomic,copy)NSString * type;
@property (nonatomic,copy)NSString * total_money;
@property (nonatomic,copy)NSString * money;
@property (nonatomic,copy)NSString * dateTime;//2012-12-12
@property (nonatomic,copy)NSString * time;//10;20

@end
