//
//  CinemaHeaderView.h
//  YuWa
//
//  Created by double on 17/2/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoviePScrollView.h"
#import "CinemaHeaderModel.h"
#import "FilmListModel.h"
@protocol CinemaHeaderViewDelegate <NSObject>

- (void)ToCinemaDetaliPage;
- (void)ToLocation;
- (void)callIphone:(NSString *)iphoneStr;


- (void)filmName:(NSString *)filmName andIndex:(NSInteger)index andfilmCode:(NSString *)filmCode andPlayDate:(NSString *)playDate;
@end

@interface CinemaHeaderView : UIView
@property (nonatomic,strong)UILabel * cinemaName;
@property (nonatomic,strong)UILabel * address;
@property (nonatomic,strong)UILabel * score;
@property (nonatomic,strong)UILabel * foodName;
@property (nonatomic,strong)UILabel * price;
@property (nonatomic,strong)UIButton * addressBtn;
@property (nonatomic,strong)UIButton * iphoneBtn;
@property (nonatomic,strong)UIImageView * ice_cream ;//冰激凌图片
@property (nonatomic,strong)UIView * touchView;
@property (nonatomic,assign)NSInteger num;//记录初始偏移量
//@property (nonatomic,strong)NSMutableArray * flimListAry;
@property (nonatomic,strong) CinemaHeaderModel * model;

@property (nonatomic,copy)NSString * cinema_code;//影院编码


@property (nonatomic,strong)UIView * BGScrollView;
@property (nonatomic,strong)UILabel * movieTitle;
@property (nonatomic,strong)UILabel * introduce;
@property (nonatomic,strong)UILabel * movieScore;
@property (nonatomic,strong)UILabel * durationLabel;//时长
@property (nonatomic,assign)BOOL isDiscount;//0是不存在优惠卡，1是存在优惠卡

@property (nonatomic,assign) id<CinemaHeaderViewDelegate>delegate;
@property (nonatomic,strong)UICollectionView * movieCollectView;
@property (nonatomic,strong)UIImageView * movieImageView;
@property (nonatomic,strong)UIImageView * BGroundView;

@property (nonatomic,strong)NSMutableArray *movies;


@end



