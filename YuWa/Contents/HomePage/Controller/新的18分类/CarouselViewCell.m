//
//  CarouselViewCell.m
//  YuWa
//
//  Created by double on 2017/2/18.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CarouselViewCell.h"

@implementation CarouselViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, self.bounds.size.height)];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
@end
