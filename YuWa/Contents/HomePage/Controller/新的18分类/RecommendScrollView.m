//
//  RecommendScrollView.m
//  YuWa
//
//  Created by double on 2017/2/18.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "RecommendScrollView.h"
@interface RecommendScrollView()<UIGestureRecognizerDelegate>


@end
@implementation RecommendScrollView

- (instancetype)initWithFrame:(CGRect)frame andWithArray:(NSMutableArray *)ary{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CNaviColor;
        
        [self makeUI];
        
    }
    return self;
}
- (void)makeUI{
    CGFloat imageWidth = (kScreen_Width - 10-14)/2.1f;
    for (int i = 0; i<5; i++) {
        self.movieImageView = [[UIImageView alloc]initWithFrame:CGRectMake((imageWidth+7) * i, 0, imageWidth, self.bounds.size.height)];
        self.movieImageView.image = [UIImage imageNamed:@"a1000"];//修改
        self.movieImageView.tag = 1+i;
        self.movieImageView.userInteractionEnabled = YES;
        [self addSubview:self.movieImageView];
        
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playBtn.frame = CGRectMake(self.movieImageView.width -35, self.movieImageView.height-35, 30, 30);
        [self.playBtn setImage:[UIImage imageNamed:@"play1.png"] forState:UIControlStateNormal];
        [self.playBtn addTarget:self action:@selector(playBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.playBtn.tag = self.movieImageView.tag;
        [self.movieImageView addSubview:self.playBtn];
        
        
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecommendView:)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.delegate = self;
        
//        UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecommendView:)];
//        PrivateLetterTap.numberOfTouchesRequired = 1;
//        PrivateLetterTap.numberOfTapsRequired = 1;
//        PrivateLetterTap.delegate= self;

        [self.movieImageView addGestureRecognizer:tapGes];
       
        
    }
}
- (void)tapRecommendView:(UITapGestureRecognizer*)tap{
    
//    NSLog(@"播放界面 %ld",tap.view.tag);
    
}
- (void)playBtn:(UIButton*)sender{
   NSLog(@"播放界面 %ld",sender.tag);
}
@end
