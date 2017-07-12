//
//  CommendViewController.h
//  YuWa
//
//  Created by double on 17/2/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaAndBuyTicketModel.h"
@interface CommendViewController : UIViewController
@property (nonatomic,strong) UILabel * comLabel;
@property (nonatomic,assign) NSInteger status;//1为订单界面过来的评价，0为电影界面过来
@property (nonatomic,copy)NSString * order_id;
@property (nonatomic,copy)NSString * film_code;
@property (nonatomic,strong)CinemaAndBuyTicketModel * headerModel;
@end
