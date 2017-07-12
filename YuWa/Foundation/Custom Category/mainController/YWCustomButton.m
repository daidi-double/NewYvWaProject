//
//  YWCustomButton.m
//  YuWa
//
//  Created by double on 17/6/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWCustomButton.h"

@implementation YWCustomButton

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
//        self.btnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width*0.8f, self.width*0.8f)];
//        self.btnImageView.center = self.center;
//        self.btnImageView.centerY = self.centerY -10;
//        
//        [self addSubview:self.btnImageView];
//        
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height -15, self.width, 15)];
        self.title.textAlignment = 1;
        self.title.centerX = 28;
        self.title.text = title;
        self.title.font = [UIFont systemFontOfSize:10];
        self.title.textColor = [UIColor colorWithHexString:@"#9f9f9f"];
        [self addSubview:self.title];
        
    }
    return self;
}

@end
