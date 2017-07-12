//
//  PlayTimeCell.h
//  YuWa
//
//  Created by double on 17/2/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmShowTimeModel.h"
@interface PlayTimeCell : UITableViewCell
@property (nonatomic,strong)UILabel * beginTime;
@property (nonatomic,strong)UILabel * language;
@property (nonatomic,strong)UILabel * endTimeAndPlace;
@property (nonatomic,strong)UILabel * sell_price;
@property (nonatomic,strong)UILabel * price;

@property (nonatomic,strong)FilmShowTimeModel * model;

@end
