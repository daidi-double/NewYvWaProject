//
//  headerView.m
//  YuWa
//
//  Created by L灰灰Y on 2017/4/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "headerView.h"

@interface headerView ()
//支出
@property (weak, nonatomic) IBOutlet UILabel *zhichu;
//收入
@property (weak, nonatomic) IBOutlet UILabel *shouru;


@end
@implementation headerView
-(void)setPay:(NSString *)pay{
    _pay = pay;
    self.zhichu.text =  pay;
}
-(void)setIncome:(NSString *)income{
    _income = income;
    self.shouru.text = income;
}
@end
