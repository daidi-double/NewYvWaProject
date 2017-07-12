//
//  XZSeatSelectionTool.m
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "XZSeatSelectionTool.h"

@implementation XZSeatSelectionTool
#pragma mark - 判断座位旁边是否留下单个位置

//=======================================
+(BOOL)verifySelectedSeatsWithSeatsDic:(NSMutableDictionary *)allAvailableSeats seatsArray:(NSArray *)seatsArray{
    NSArray *seatBtnsArr = [allAvailableSeats allValues];
    if ([seatBtnsArr count] > 0) {
        for (XZSeatButton *currentBtn in seatBtnsArr) {
            
            if([currentBtn isSeatAvailable]){
                NSInteger idx = currentBtn.seatIndex;
                
                XZSeatButton *preBtn =  [allAvailableSeats objectForKey:[NSString stringWithFormat:@"%zd", idx - 1]];
                XZSeatButton *nextBtn = [allAvailableSeats objectForKey:[NSString stringWithFormat:@"%zd", idx + 1]];
                
                
                BOOL isPreOK = preBtn != nil &&
                [preBtn.seatsmodel.rowId isEqualToString:currentBtn.seatsmodel.rowId] &&
                [preBtn isSeatAvailable];//判断是否在同一列，且状态为可选
                
                BOOL isNextOK = nextBtn != nil &&
                [nextBtn.seatsmodel.rowId isEqualToString:currentBtn.seatsmodel.rowId]&&
                [nextBtn isSeatAvailable];
                
                
                NSInteger preBtnCol = [preBtn.seatsmodel.columns indexOfObject:preBtn.seatmodel];//上一个座位屏幕列
                NSInteger currentBtnCol = [currentBtn.seatsmodel.columns indexOfObject:currentBtn.seatmodel];//当前座位屏幕列
                NSInteger nextBtnCol = [nextBtn.seatsmodel.columns indexOfObject:nextBtn.seatmodel];//下一个座位屏幕列
                
                if (isPreOK) {
                    isPreOK =  ABS(currentBtnCol - preBtnCol) == 1;
                    
                }
                if (isNextOK) {
                    isNextOK = ABS(currentBtnCol - nextBtnCol) == 1;
                    
                }
                
                if (!isPreOK && !isNextOK) {
                    NSArray *nearBySeats = [self getNearBySeatsInSameRowForSeat:currentBtn withAllAvailableSeats:allAvailableSeats];
                    
                    
                    if ([nearBySeats count] == 2 ||[nearBySeats count] == 1) {
                        continue;
                    }
                    
                    if ([nearBySeats count] == 3) {
                        NSInteger idx = [nearBySeats indexOfObject:currentBtn];
                        
                        if (idx == 0 && ![nearBySeats[2] isSeatAvailable]) {
                            continue;
                        }else if(idx == 2 && ![nearBySeats[0] isSeatAvailable]) {
                            continue;
                        }
                    }
                    
                    if ([nearBySeats count] == 4) {
                        NSInteger idx = [nearBySeats indexOfObject:currentBtn];
                        
                        if (idx == 0 && ![nearBySeats[3] isSeatAvailable]) {
                            continue;
                        }else if(idx == 3 && ![nearBySeats[0] isSeatAvailable]) {
                            continue;
                        }
                    }
                    
                    if ([nearBySeats count] == 5) {
                        NSInteger idx = [nearBySeats indexOfObject:currentBtn];
                        
                        if (idx == 0 && ![nearBySeats[4] isSeatAvailable]) {
                            continue;
                        }else if(idx == 4 && ![nearBySeats[0] isSeatAvailable]) {
                            continue;
                        }
                    }
                    
                    for (int i = 0; i < seatsArray.count; i++) {
                        XZSeatsModel *seatsModel = seatsArray[i];
                        for (XZSeatModel *s in seatsModel.columns) {
                            if((preBtn && [preBtn.seatmodel.seatNo isEqualToString:s.seatNo]) ||
                               (nextBtn && [nextBtn.seatmodel.seatNo isEqualToString:s.seatNo])    ) {
                                return NO;
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    return YES;
}

+(NSArray *)getNearBySeatsInSameRowForSeat:(XZSeatButton *)seat withAllAvailableSeats:(NSMutableDictionary *)allAvailableSeats{
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:seat];
    
    NSInteger idx = seat.seatIndex - 1;
    
    //左边
    XZSeatButton *tmp= [allAvailableSeats objectForKey:[NSString stringWithFormat:@"%zd", idx]];
    while([self isSeat:tmp nearBySeatWithoutRoad:seat]){
        [result insertObject:tmp atIndex:0];
        idx--;
        tmp = [allAvailableSeats objectForKey:[NSString stringWithFormat:@"%zd", idx]];
    }
    
    idx = seat.seatIndex + 1;
    //右边
    tmp= [allAvailableSeats objectForKey:[NSString stringWithFormat:@"%zd", idx]];
    while([self isSeat:tmp nearBySeatWithoutRoad:seat]){
        [result addObject:tmp];
        idx++;
        tmp = [allAvailableSeats objectForKey:[NSString stringWithFormat:@"%zd", idx]];
    }
    
    
    return result;
}

+(BOOL)isSeat:(XZSeatButton *)s1 nearBySeatWithoutRoad:(XZSeatButton *)s2{
    NSInteger s1Col = [s1.seatsmodel.columns indexOfObject:s1.seatmodel];//当前座位列
    NSInteger s2Col = [s2.seatsmodel.columns indexOfObject:s2.seatmodel];//下一个座位列
    return     s1 != nil &&
    [s1.seatsmodel.rowId isEqualToString:s2.seatsmodel.rowId] &&
    ABS(s1Col - s2Col) == ABS([s1.seatmodel.columnId intValue] - [s2.seatmodel.columnId intValue]) ;
}


@end
