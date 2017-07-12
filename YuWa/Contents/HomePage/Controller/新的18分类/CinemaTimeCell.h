//
//  CinemaTimeCell.h
//  YuWa
//
//  Created by double on 2017/2/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaModel.h"
@interface CinemaTimeCell : UITableViewCell
@property (nonatomic,strong)UILabel * cinemaName;
@property (nonatomic,strong)UILabel * price;
@property (nonatomic,strong)UILabel * distance;
@property (nonatomic,strong)CinemaModel * model;
//@property (nonatomic,strong)UILabel * screeningTime;//场次时间
@property (nonatomic,strong)UILabel * otherTicketLabel;//通兑票图标
@property (nonatomic,strong)UILabel * seatLabel;//选座图标

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDataAry:(NSMutableArray*)dataAry;
@end
