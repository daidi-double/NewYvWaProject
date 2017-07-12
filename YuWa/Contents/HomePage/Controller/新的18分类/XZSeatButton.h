//
//  XZSeatButton.h
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZSeatModel.h"
#import "XZSeatsModel.h"
@interface XZSeatButton : UIButton
/**座位模型*/
@property (nonatomic, strong) XZSeatModel * seatmodel;

/**座位模型组*/
@property (nonatomic, strong) XZSeatsModel * seatsmodel;

/**座位绑定索引，用于判断独坐*/
@property (nonatomic,assign) NSInteger seatIndex;

@property (nonatomic,copy)NSString * code;
/**验证座位是否可选*/
-(BOOL)isSeatAvailable;
@end
