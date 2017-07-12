//
//  MovieDetailViewController.h
//  YuWa
//
//  Created by double on 17/5/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaAndBuyTicketModel.h"
@interface MovieDetailViewController : UIViewController
@property (nonatomic,copy)NSString * filmCode;
@property (nonatomic,strong)CinemaAndBuyTicketModel * cinemaDetailModel;
@end
