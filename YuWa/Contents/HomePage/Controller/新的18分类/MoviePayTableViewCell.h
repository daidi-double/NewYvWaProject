//
//  MoviePayTableViewCell.h
//  YuWa
//
//  Created by double on 17/5/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviePayTableViewCell : UITableViewCell
// 电影名称
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
// 影院名称
@property (weak, nonatomic) IBOutlet UILabel *cinemaNameLabel;
//演出时间，语言
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;

//座位
@property (weak, nonatomic) IBOutlet UILabel *seatNumberLabel;
@property (nonatomic,strong)NSMutableArray * dataAry;
@end
