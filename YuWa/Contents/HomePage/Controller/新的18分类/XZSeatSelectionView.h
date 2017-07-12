//
//  XZSeatSelectionView.h
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZSeatSelectionView : UIView
/**frame 初始化必需设置你的frame  seatsArray座位数组    hallName影厅名称   actionBlock按钮点击回调－>传回就是选中的按钮数组和全部可选按钮*/
@property (nonatomic,assign) NSInteger markSeatNum;
@property (nonatomic,assign) NSInteger markSeatColumn;
-(instancetype)initWithFrame:(CGRect)frame SeatsArray:(NSMutableArray *)seatsArray HallName:(NSString *)hallName seatBtnActionBlock:(void(^)(NSMutableArray *selecetedSeats,NSMutableDictionary *allAvailableSeats,NSMutableArray *cancelAry,NSString *errorStr))actionBlock;
@end
