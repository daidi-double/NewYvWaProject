//
//  MovieCinemaViewController.h
//  YuWa
//
//  Created by double on 2017/2/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MovieCinemaViewController : UIViewController
@property (nonatomic,strong)UIButton * buy_ticket;
@property (nonatomic,copy)NSString * cinema_code;//影院编码
@property (nonatomic,copy)NSString * film_code;//电影编码
@property (nonatomic,copy)NSString * cityCode;//城市编码
@property (nonatomic,strong)YWLocation * location;
@property (nonatomic,assign)NSInteger status;//0是无通兑票，1有通兑票
@property (nonatomic,copy)NSString * filmName;
@end
