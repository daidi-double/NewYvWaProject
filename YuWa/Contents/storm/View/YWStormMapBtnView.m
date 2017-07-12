//
//  YWStormMapBtnView.m
//  YuWa
//
//  Created by Tian Wei You on 16/11/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWStormMapBtnView.h"
#import "JWTools.h"

@implementation YWStormMapBtnView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0.f, 5.f, 100.f, 40.f);
        self.BGbtn = [[UIButton alloc]initWithFrame:self.frame];
        [self.BGbtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.BGbtn];
        
        self.showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(4.f, 2.f, 36.f, 36.f)];
        self.showImageView.layer.cornerRadius = 18.f;
        self.showImageView.layer.masksToBounds = YES;
        [self addSubview:self.showImageView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.showImageView.frame) + 3.f, 0.f, 60.f, 22.f)];
        self.nameLabel.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:self.nameLabel];
        
        self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.nameLabel.frame), self.nameLabel.width, 18.f)];
        self.distanceLabel.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:self.distanceLabel];
    }
    return self;
}

- (void)lengthSet{
    self.nameLabel.width = [JWTools labelWidthWithLabel:self.nameLabel];
    self.distanceLabel.width = [JWTools labelWidthWithLabel:self.distanceLabel];
    CGFloat width = 40.f + ([JWTools labelWidthWithLabel:self.nameLabel]>[JWTools labelWidthWithLabel:self.distanceLabel]?[JWTools labelWidthWithLabel:self.nameLabel]:[JWTools labelWidthWithLabel:self.distanceLabel]);
    self.frame = CGRectMake(0.f, 0.f, width < kScreen_Width?width : kScreen_Width, 40.f);
    self.BGbtn.frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
}

- (void)chooseBtnAction:(id)sender {
    self.callViewBlock();
}


@end
