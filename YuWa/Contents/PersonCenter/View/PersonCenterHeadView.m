//
//  PersonCenterHeadView.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/19.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PersonCenterHeadView.h"

@implementation PersonCenterHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIImageView*imageView=[self viewWithTag:1];
    imageView.layer.cornerRadius=25;
    imageView.layer.borderWidth=1;
    imageView.layer.borderColor=[UIColor whiteColor].CGColor;
    imageView.image=[UIImage imageNamed:@"placeholder"];
    imageView.layer.masksToBounds=YES;
    [imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTap)];
    [imageView addGestureRecognizer:tap];
    
    
    
    
    
//    UIButton*Bperson=[self viewWithTag:4];
//    Bperson.layer.cornerRadius=5;
//    Bperson.layer.borderWidth=1;
//    Bperson.layer.borderColor=[UIColor whiteColor].CGColor;
//    Bperson.layer.masksToBounds=YES;
    
    UIButton*follow=[self viewWithTag:5];
    follow.layer.cornerRadius=5;
    follow.layer.borderWidth=1;
    follow.layer.borderColor=[UIColor whiteColor].CGColor;
    follow.layer.masksToBounds=YES;
    
    UIButton*friend=[self viewWithTag:6];
    friend.layer.cornerRadius=5;
    friend.layer.borderWidth=1;
    friend.layer.borderColor=[UIColor whiteColor].CGColor;
    friend.layer.masksToBounds=YES;


    
}

-(void)touchTap{
    if (self.touchImageBlock) {
        self.touchImageBlock();
    }
    
}


@end
