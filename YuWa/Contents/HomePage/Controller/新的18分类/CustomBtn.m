//
//  CustomBtn.m
//  YuWa
//
//  Created by double on 2017/2/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CustomBtn.h"

@implementation CustomBtn

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
 
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width*0.3f, kScreen_Height*0.05f)];
        self.title.textAlignment = 1;
        self.title.text = title;
        self.title.font = [UIFont systemFontOfSize:14];

        [self addSubview:self.title];
        
        self.btnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width*0.25, 0, 10, 10)];
        self.btnImageView.center = CGPointMake(kScreen_Width*0.25, self.title.height/2);

        [self addSubview:self.btnImageView];
    }
    return self;
}
@end
