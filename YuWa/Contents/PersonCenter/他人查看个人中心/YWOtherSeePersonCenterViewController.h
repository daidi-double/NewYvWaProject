//
//  YWOtherSeePersonCenterViewController.h
//  YuWa
//
//  Created by 黄佳峰 on 16/10/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPPersonCenterViewController.h"


@interface YWOtherSeePersonCenterViewController : UIViewController

@property(nonatomic,strong)NSString * uid;
@property(nonatomic,copy)NSString * nickName;
@property(nonatomic,copy)NSString * otherIcon;   //此人的头像
@property(nonatomic,copy)NSString * user_type;//此人的user_type;
@end
