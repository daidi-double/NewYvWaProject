//
//  IntroduceMoneyViewController.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "introduceModel.h"

typedef NS_ENUM(NSInteger,IntroduceType){
    IntroduceTypeBusinesser=0,
    IntroduceTypeUser
    
};

@interface IntroduceMoneyViewController : UIViewController
@property(nonatomic,strong)introduceModel *model;
@property(nonatomic,assign)IntroduceType introduceType;

@end
