//
//  XZSeatsView.h
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZSeatButton.h"
@interface XZSeatsView : UIView
/** 按钮宽度 */
@property (nonatomic,assign) CGFloat seatBtnWidth;

/** 按钮高度 */
@property (nonatomic,assign) CGFloat seatBtnHeight;

/** 座位图宽度 */
@property (nonatomic,assign) CGFloat seatViewWidth;

/** 座位图高度 */
@property (nonatomic,assign) CGFloat seatViewHeight;

//@property (nonatomic,assign) NSInteger markseatNum;
//@property (nonatomic,assign) NSInteger markseatcolumn;

/**  seatsArray座位数组 maxW默认最大座位父控件的宽度 actionBlock按钮点击回调－>传回是当前选中的按钮和全部可选的座位*/

-(instancetype)initWithSeatsArray:(NSMutableArray *)seatsArray maxNomarWidth:(CGFloat)maxW maxCount:(NSInteger)maxCount seatBtnActionBlock:(void(^)(XZSeatButton *seatBtn,NSMutableDictionary *allAvailableSeats))actionBlock;
-(NSInteger) getSeatBtnHeight;

@end
