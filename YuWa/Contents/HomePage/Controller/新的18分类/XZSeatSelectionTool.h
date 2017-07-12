//
//  XZSeatSelectionTool.h
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZSeatButton.h"
#import "XZSeatsModel.h"
#import "XZSeatModel.h"
@interface XZSeatSelectionTool : NSObject
/**验证座位是否落单*/
+(BOOL)verifySelectedSeatsWithSeatsDic:(NSMutableDictionary *)allAvailableSeats seatsArray:(NSArray *)seatsArray;
+(NSArray *)getNearBySeatsInSameRowForSeat:(XZSeatButton *)seat withAllAvailableSeats:(NSMutableDictionary *)allAvailableSeats;
+(BOOL)isSeat:(XZSeatButton *)s1 nearBySeatWithoutRoad:(XZSeatButton *)s2;

@end
