//
//  UseCouponViewController.h
//  YuWa
//
//  Created by double on 17/5/4.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@protocol UseCouponViewControllerDelegate <NSObject>

-(void)DelegateGetCouponInfo:(CouponModel*)model;

@end
@interface UseCouponViewController : UIViewController
@property (nonatomic,copy)NSString * shop_id;
@property (nonatomic,copy)NSString * total_money;
@property (nonatomic,assign)NSInteger couponType;//0为其他界面。1为电影
@property (nonatomic,copy)NSString* cinema_code;
@property(nonatomic,assign)id<UseCouponViewControllerDelegate>delegate;
@end
