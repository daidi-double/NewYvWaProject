//
//  ShopPlanHeaderView.m
//  YuWa
//
//  Created by double on 17/6/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ShopPlanHeaderView.h"

@implementation ShopPlanHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.lightView];
        [self addSubview:self.headerNameLabel];
        [self addSubview:self.headerImageView];
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(14, 0, kScreen_Width-28, 0.5)];
        line.backgroundColor = RGBCOLOR(234, 235, 236, 1);
        [self addSubview:line];
    }
    return self;
}

- (UIView*)lightView{
    if (!_lightView) {
        _lightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
        _lightView.backgroundColor = RGBCOLOR(234, 235, 236, 1);
    }
    return _lightView;
}
-(UILabel*)headerNameLabel{
    if (!_headerNameLabel) {
        _headerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 80, 30)];
        _headerNameLabel.textColor = CNaviColor;
        _headerNameLabel.center = CGPointMake(kScreen_Width/2+10, self.height/2+5);
        _headerNameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium"size:16];
    }
    return _headerNameLabel;
}

- (UIImageView*)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.headerNameLabel.left -24, 0, 20, 20)];
        _headerImageView.centerY = self.headerNameLabel.centerY;
    }
    return _headerImageView;
}
@end
