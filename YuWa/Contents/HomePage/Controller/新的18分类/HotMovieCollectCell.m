//
//  HotMovieCollectCell.m
//  YuWa
//
//  Created by double on 2017/2/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "HotMovieCollectCell.h"

@implementation HotMovieCollectCell
- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.movieView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height*0.8)];
        self.movieView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_movieView];
        
        self.movieName = [[UILabel alloc]initWithFrame:CGRectMake(0, self.movieView.size.height, self.bounds.size.width, self.bounds.size.height*0.2)];
        
        self.movieName.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.movieName];
    }
    return self;
}

@end
