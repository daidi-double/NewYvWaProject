//
//  YWPayViewController.h
//  YuWa
//
//  Created by 黄佳峰 on 16/10/10.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PayCategory){
    PayCategoryQRCodePay=0,   //二维码支付
    PayCategoryWritePay //手写支付
    
    
};


@interface YWPayViewController : UIViewController
@property(nonatomic,assign)PayCategory whichPay;  //哪种支付

@property(nonatomic,strong)NSString*shopID;  //店铺的id
@property(nonatomic,strong)NSString*shopName;  //店铺的名字
@property(nonatomic,assign)CGFloat shopZhekou;  //店铺的折扣

//如果是  扫码支付 就得有下面的参数 否则就不需要
@property(nonatomic,assign)CGFloat payAllMoney;    //需要支付的总额
@property(nonatomic,assign)CGFloat NOZheMoney;     //不打折的金额



//----------------------------------------------

//折扣多少
+(instancetype)payViewControllerCreatWithWritePayAndShopNameStr:(NSString*)shopName andShopID:(NSString*)shopID andZhekou:(CGFloat)shopZhekou;

+(instancetype)payViewControllerCreatWithQRCodePayAndShopNameStr:(NSString*)shopName andShopID:(NSString*)shopID andZhekou:(CGFloat)shopZhekou andpayAllMoney:(CGFloat)payAllMoney andNOZheMoney:(CGFloat)NOZheMoney;


@end
