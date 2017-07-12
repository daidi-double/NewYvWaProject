//
//  YWdetailViewController.h
//  YuWa
//
//  Created by L灰灰Y on 2017/4/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWdetailModel.h"
@interface YWdetailViewController : UIViewController
@property (nonatomic, strong) YWdetailModel *model;
@property (nonatomic,assign)NSInteger  status;//1,待处理，2接受，3拒绝
@end
