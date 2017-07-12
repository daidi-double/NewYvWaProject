//
//  PlayTimeShowTableViewCell.h
//  YuWa
//
//  Created by double on 17/5/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmShowTimeModel.h"
@interface PlayTimeShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *showTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *hallNumber;
@property (weak, nonatomic) IBOutlet UILabel *seller_priceLabel;

@property (nonatomic,strong)FilmShowTimeModel * model;


@end
