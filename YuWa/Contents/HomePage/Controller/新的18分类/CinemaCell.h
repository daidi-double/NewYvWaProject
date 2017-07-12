//
//  CinemaCell.h
//  YuWa
//
//  Created by double on 2017/2/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCinemaListModel.h"
@interface CinemaCell : UITableViewCell

@property (nonatomic,strong)UILabel * cinemaName;
@property (nonatomic,strong)UILabel * price;
@property (nonatomic,strong)UILabel * distance;
@property (nonatomic,strong)HomeCinemaListModel * model;
@property (nonatomic,strong)UILabel * discount;
@property (nonatomic,assign)BOOL isdiscount;
@property (nonatomic,strong)UILabel * otherTicketLabel;//通兑票图标
@property (nonatomic,strong)UILabel * seatLabel;//选座图标

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDataAry:(NSMutableArray*)dataAry;
@end
