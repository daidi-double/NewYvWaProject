//
//  OtherTicketModel.h
//  YuWa
//
//  Created by double on 17/5/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherTicketModel : NSObject
@property (nonatomic,copy)NSString * validType;//有效期类型 0:固定天数 1：时间段
@property (nonatomic,copy)NSString * priceType;//价格类型 0：常规价1：忙时价 2：闲时价
@property (nonatomic,copy)NSString * memo;//产品说明
@property (nonatomic,copy)NSString * validateMemo;//凭证下发说明
@property (nonatomic,copy)NSString * price;//结算价：单位分
@property (nonatomic,copy)NSString * showType;//兑换放映类型（0：2D 1：3D 2：IMAX2D 3：IMAX3D 4：中 国巨幕2D 5：中国巨幕3D）
@property (nonatomic,copy)NSString * devicePos;//pos终端位置说明
@property (nonatomic,copy)NSString * ticketNo;//票编号
@property (nonatomic,copy)NSString * ticketType;//通兑票类型 1：单家通兑票 2：多家通兑票
@property (nonatomic,copy)NSString * ticketName;//票名称
@property (nonatomic,copy)NSString * validDate;//有效期：2015-04-16，validType=0时为空
@property (nonatomic,copy)NSString * range;//使用范围
@property (nonatomic,copy)NSString * validDays;//有效天数validType=1时为空
@property (nonatomic,copy)NSString * percentage;//调价比例
@property (nonatomic,copy)NSString * per_price;//单价（原价）：分
@end
