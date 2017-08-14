//
//  PayBusinessViewController.h
//  YuWa
//
//  Created by double on 17/3/8.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayBusinessViewController : UIViewController
@property (nonatomic,assign) CGFloat order_id;//订单id
@property(nonatomic,assign)NSInteger ischoose; //1 微信 2 支付宝 3 银联支付
@end
