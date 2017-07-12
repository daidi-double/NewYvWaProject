//
//  YWNewDiscountPayViewController.h
//  YuWa
//
//  Created by double on 17/4/25.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWCarListModel.h"
#import "YWShopInfoListModel.h"
typedef NS_ENUM(NSInteger,PayCategoryMethod){
    PayCategoryQRCodePayMethod=0,   //二维码支付
    PayCategoryWritePayMethod //手写支付
    
    
};


@interface YWNewDiscountPayViewController : UIViewController
@property (nonatomic,strong)NSMutableArray * dataAry;
@property (nonatomic,strong)YWCarListModel * model;
@property (nonatomic,strong)YWShopInfoListModel * infoModel;
@property (nonatomic,copy)NSString * money;
@property (nonatomic,assign)NSInteger status;//1.无单品的情况，2.有单品，3.扫码支付
@property (nonatomic,strong)NSString * shopDiscount;
@property(nonatomic,assign)PayCategoryMethod whichPay;  //哪种支付
@property(nonatomic,strong)NSString*shopID;  //店铺的id
@property(nonatomic,strong)NSString*shopName;  //店铺的名字
@property(nonatomic,assign)CGFloat shopZhekou;  //店铺的折扣

//如果是  扫码支付 就得有下面的参数 否则就不需要
@property(nonatomic,assign)CGFloat payAllMoney;    //需要支付的总额
@property(nonatomic,assign)CGFloat NOZheMoney;     //不打折的金额


//折扣多少
+(instancetype)payViewControllerCreatWithWritePayAndShopName:(NSString*)shopName andShopID:(NSString*)shopID andZhekou:(CGFloat)shopZhekou;

+(instancetype)payViewControllerCreatWithQRCodePayAndShopName:(NSString*)shopName andShopID:(NSString*)shopID andZhekou:(CGFloat)shopZhekou andpayAllMoney:(CGFloat)payAllMoney andNOZheMoney:(CGFloat)NOZheMoney;
@end
