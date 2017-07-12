//
//  ChooseSeatController.h
//  YuWa
//
//  Created by double on 17/2/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmShowTimeModel.h"
@interface ChooseSeatController : UIViewController
@property(nonatomic,strong)UILabel* titleLbl;
@property (nonatomic,strong)UILabel * playTime;
@property (nonatomic,strong)UIButton * sureBtn;
@property (nonatomic,strong) UILabel * allPrice;//总价;
@property (nonatomic,strong) UILabel * price_num;//价格和张数
@property (nonatomic,strong) UILabel * languageLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) NSString * cinemaName;
//@property (nonatomic,strong) UIButton * changeMovieBtn;//更换场次
@property (nonatomic,copy) NSString * channelshowcode;//渠道场次编码
@property (nonatomic,copy)NSString * hall_name;
@property (nonatomic,strong)FilmShowTimeModel * headerModel;
@property (nonatomic,copy)NSString * filmName;
@property (nonatomic,copy)NSString * cinemaCode;//影院编码
@end
