//
//  MovieDetailHeaderView.h
//  YuWa
//
//  Created by double on 17/5/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseMovieHeaderView.h"
#import "CinemaAndBuyTicketModel.h"

@protocol MovieDetailHeaderViewDelegate <NSObject>

- (void)toCommentScore;
- (void)refreshUI:(NSInteger)status;

@end
@interface MovieDetailHeaderView : UIView
{
    UIButton * markBtn;
}
@property (nonatomic,strong) UILabel * daoyanLabel;//导演
@property (nonatomic,strong) UILabel * performerLabel;//主演
@property (nonatomic,strong) UILabel * countryLabel;//国家
@property (nonatomic,strong) UILabel * categoryLabel;//类型
@property (nonatomic,strong) UIView * line;
@property (nonatomic,strong) UILabel * introduceLabel;
@property (nonatomic,strong) UIButton * moreBtn;
@property (nonatomic,assign) NSInteger  status;//0省略的介绍，1展开介绍
@property (nonatomic,strong) CinemaAndBuyTicketModel * model;
@property (nonatomic,assign)id<MovieDetailHeaderViewDelegate>delegate;

+(CGFloat)getHeaderHeight:(NSString *)introduce;

@end
