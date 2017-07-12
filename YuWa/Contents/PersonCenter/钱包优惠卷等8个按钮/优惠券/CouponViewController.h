//
//  CouponViewController.h
//  YuWa
//
//  Created by 黄佳峰 on 16/10/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@protocol CouponViewControllerDelegate <NSObject>

-(void)DelegateGetCouponInfoOld:(CouponModel*)model;

@end

@interface CouponViewController : UIViewController

@property(nonatomic,strong)NSString*shopID;  //店铺的id  当优惠券的shop_id等于0的是后是 店铺通用优惠券   或者优惠券的shop——id 相等
@property(nonatomic,assign)CGFloat totailPayMoney;  //这次消费 打过折之后 需要付的钱  用来判断能不能使用这样优惠券

@property(nonatomic,assign)id<CouponViewControllerDelegate>delegate;
@end
