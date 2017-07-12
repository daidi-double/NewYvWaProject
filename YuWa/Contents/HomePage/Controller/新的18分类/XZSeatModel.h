//
//  XZSeatModel.h
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZSeatModel : NSObject
/**座位真实列，用于显示当前座位列号*/
@property (nonatomic, copy) NSString *columnId;

/**座位编号*/
@property (nonatomic, copy) NSString *seatNo;

/**座位状态 N/表示可以购票 LK／座位已售出 E/表示过道 LOVE/表示情侣座 */
@property (nonatomic, copy) NSString *st;

@property (nonatomic,copy) NSString * type;//2情侣座，1普通座

/**座位编码**/
@property (nonatomic,copy)NSString * code;

@end
