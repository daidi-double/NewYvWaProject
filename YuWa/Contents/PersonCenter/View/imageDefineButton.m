//
//  imageDefineButton.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/20.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "imageDefineButton.h"

@implementation imageDefineButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        _topImageView=[[UIImageView alloc]init];
//        _topImageView.backgroundColor=[UIColor blueColor];
        
        [self addSubview:self.topImageView ];
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.top);
            make.centerX.mas_equalTo(self.centerX);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            
        }];
        
        
 
        _bottomLabel=[[UILabel alloc]init];
        _bottomLabel.text=@"优惠券";
        _bottomLabel.font=[UIFont systemFontOfSize:12];
        _bottomLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.bottomLabel];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topImageView.mas_bottom).offset(5);
            make.centerX.mas_equalTo(self.centerX);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(@(18));
            
            
        }];
        
        
        
        
    }
    return self;
}


@end
