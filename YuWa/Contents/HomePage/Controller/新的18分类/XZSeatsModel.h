//
//  XZSeatsModel.h
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZSeatsModel.h"
@interface XZSeatsModel : NSObject
/**座位数组*/
@property (nonatomic, strong) NSArray *columns;

/**座位真实行，用于显示座位行号*/
@property (nonatomic, copy) NSString *rowId;

/**座位屏幕行，用于算座位frame*/
@property (nonatomic, copy) NSNumber *rowNum;

/**座位编码**/
@property (nonatomic,copy)NSString * code;

+(XZSeatsModel*)XZSeatsModelWithAry:(NSMutableArray*)ary;
@end
