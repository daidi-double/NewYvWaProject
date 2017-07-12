//
//  MoviePScrollView.m
//  YuWa
//
//  Created by double on 17/2/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MoviePScrollView.h"

@implementation MoviePScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat imageWidth = (kScreen_Width - 60)/3.3;
        for (int i = 0; i<5; i++) {
            //修改
            _movieImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, self.height *0.7)];
            
            _movieImageView.center = CGPointMake(kScreen_Width/2 +(kScreen_Width*0.24+35)*i, self.height/2);
           
            _movieImageView.image =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"baobaoBG3" ofType:@"png"]];
            [self addSubview:_movieImageView];
        }
    }
    return self;


}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
