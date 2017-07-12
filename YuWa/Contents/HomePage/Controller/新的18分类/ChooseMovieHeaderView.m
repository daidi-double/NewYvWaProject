//
//  ChooseMovieHeaderView.m
//  YuWa
//
//  Created by double on 2017/2/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChooseMovieHeaderView.h"
@interface ChooseMovieHeaderView ()<UIGestureRecognizerDelegate>

@end
@implementation ChooseMovieHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
 
        
    }
    return self;
}
- (void)setModel:(CinemaAndBuyTicketModel *)model{
    _model = model;
    [self setData];
}

- (void)setData{
    [self bgImageView];
   [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.image]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    if (self.status == 1) {
        [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.poster]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    self.title.text = self.model.name;

    self.categoryLabel.width = [self getLabelWidth:self.model.type];
    self.categoryLabel.text = [NSString stringWithFormat:@"%@",self.model.type];
    if (self.model.type== nil) {
        self.categoryLabel.text = @"";
    }
    self.countryLabel.width = [self getLabelWidth:self.model.country];

    self.countryLabel.text = [NSString stringWithFormat:@"%@",self.model.country];
    if (self.model.country== nil) {
        self.countryLabel.text = @"";
    }
    self.timeLabel.frame = CGRectMake(self.countryLabel.right +10, self.publishDateLabel.bottom+10, [self getLabelWidth:[NSString stringWithFormat:@"%@分钟",self.model.duration]], self.bounds.size.height*0.15);
    _timeLabel.text = [NSString stringWithFormat:@"%@分钟",self.model.duration];
    if (self.model.publish_date == nil) {
         self.publishDateLabel.text = [JWTools getTime:self.model.publishDate];
    }else{
         self.publishDateLabel.text = [JWTools getTime:self.model.publish_date];
    }
    self.scoreLabel.text = self.model.score;
    [self addSubview:self.gradeBtn];
    [self addSubview:self.rightImageView];
    CGFloat realZhengshu;
    CGFloat realXiaoshu;

    NSString * starNmuber1 = self.model.score;
    CGFloat totalScroe = [starNmuber1 floatValue]/2;
    NSString *starNmuber = [NSString stringWithFormat:@"%.2f",totalScroe];
    NSString*zhengshu=[starNmuber substringToIndex:1];
    realZhengshu=[zhengshu floatValue];
    NSString*xiaoshu=[starNmuber substringFromIndex:1];
    CGFloat CGxiaoshu=[xiaoshu floatValue];
    
    if (CGxiaoshu>=0.75) {
        realXiaoshu=0;
        realZhengshu= realZhengshu+1;
    }else if (CGxiaoshu>=0&&CGxiaoshu<0.25){
        realXiaoshu=0;
    }else{
        realXiaoshu=0.5;
        
    }
    
    for (int a = 0; a<5; a++) {
        UIImageView * startImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.posterImageView.right +11 +(15+3)*a, self.posterImageView.origin.y, 15, 15)];
        startImageView.tag = 40 +a;
        if (startImageView.tag-40<realZhengshu) {
            //亮
            startImageView.image=[UIImage imageNamed:@"home_lightStar"];
        }else if (startImageView.tag-40==realZhengshu&&realXiaoshu<0.75 && realXiaoshu >=0.25){
            //半亮
            startImageView.image=[UIImage imageNamed:@"home_halfStar"];
            
        }else{
            //不亮
            startImageView.image=[UIImage imageNamed:@"home_grayStar"];
        }
        
        
        [self addSubview:startImageView];
    }
    

}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, self.bounds.size.height*0.7)];
        _bgImageView.image = [UIImage imageNamed:@"headerBGView"];
        _bgImageView.userInteractionEnabled = YES;
        
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_bgImageView];
    }
    return _bgImageView;
}
- (UIImageView *)posterImageView{
    if (!_posterImageView) {
        _posterImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreen_Width/3, self.bounds.size.height*0.85)];

        _posterImageView.userInteractionEnabled = YES;

        _posterImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_posterImageView];
    }
    return _posterImageView;
}

- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(self.posterImageView.right + 11, 30, kScreen_Width/2, self.bounds.size.height*0.15)];
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = [UIColor whiteColor];
        _title.text = @"";
        [self addSubview:_title];
    }
    return _title;
}

- (UILabel *)publishDateLabel{
    if (!_publishDateLabel) {
        _publishDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.posterImageView.right + 11, self.title.bottom, kScreen_Width/2, self.bounds.size.height*0.15)];
        _publishDateLabel.font = [UIFont systemFontOfSize:15];
        _publishDateLabel.textColor = [UIColor whiteColor];
        _publishDateLabel.text = @"";
        [self addSubview:_publishDateLabel];
    }
    return _publishDateLabel;
}
- (UILabel*)countryLabel {
    if (!_countryLabel) {
        _countryLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x, self.publishDateLabel.bottom+10, kScreen_Width/2, self.bounds.size.height*0.15)];
        _countryLabel.backgroundColor = [UIColor whiteColor];
        _countryLabel.textColor = CNaviColor;
        _countryLabel.font = [UIFont systemFontOfSize:13];
        _countryLabel.textAlignment = 1;
        _countryLabel.text = @"";
        _countryLabel.layer.cornerRadius = 3;
        _countryLabel.layer.masksToBounds = YES;
        [self addSubview:_countryLabel];
        
    }
    return _countryLabel;
}
- (UILabel*)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.countryLabel.right +10, self.publishDateLabel.bottom+10, kScreen_Width/2, self.bounds.size.height*0.15)];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.textColor = CNaviColor;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.text = @"";
        _timeLabel.textAlignment =1;
        _timeLabel.layer.cornerRadius = 3;
        _timeLabel.layer.masksToBounds = YES;
        [self addSubview:_timeLabel];
        
    }
    return _timeLabel;
}
- (UILabel *)categoryLabel
{
    if (!_categoryLabel) {
        
        _categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x, self.timeLabel.bottom+10, kScreen_Width/2, self.bounds.size.height*0.15f)];
        _categoryLabel.backgroundColor = [UIColor whiteColor];
        _categoryLabel.textColor = CNaviColor;
        _categoryLabel.font = [UIFont systemFontOfSize:13];
        _categoryLabel.text = @"";
        _categoryLabel.textAlignment = 1;
        _categoryLabel.layer.cornerRadius = 3;
        _categoryLabel.layer.masksToBounds = YES;
        [self addSubview:_categoryLabel];
    }
    return _categoryLabel;
}


- (UILabel *)scoreLabel{
    if (!_scoreLabel) {
        
        _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.posterImageView.right + 110, 10, 35, self.bounds.size.height*0.1f)];
        _scoreLabel.textColor = [UIColor whiteColor];
        
        _scoreLabel.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:_scoreLabel];
    }
    return _scoreLabel;
}

- (UIImageView*)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 38, 0, 8, 15)];
        _rightImageView.centerY = self.height/2;
        _rightImageView.tag = 1011;
        _rightImageView.image = [UIImage imageNamed:@"右箭头"];
        
    }
    return _rightImageView;
}


- (void)gradeBtn:(UIButton*)sender{
    NSLog(@"评分");
    [self.delegate commend];
}

//计算自动宽度
- (CGFloat)getLabelWidth:(NSString*)str{
    CGRect Width = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height*0.1) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    return Width.size.width + 15;
 
}

@end
