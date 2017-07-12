//
//  HUDLoadingShowView.m
//  NewVipxox
//
//  Created by 黄佳峰 on 16/8/29.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "HUDLoadingShowView.h"

@implementation HUDLoadingShowView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.userInteractionEnabled=NO;
        
        UIImageView*imageView=[self viewWithTag:1];
        imageView.animationImages=[self animationImages];
        imageView.animationDuration=3;
        imageView.animationRepeatCount=0;
        [imageView startAnimating];

        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

-(NSArray*)animationImages{

    NSMutableArray*imageArrays=[NSMutableArray array];
    for (int i=0; i<32; i++) {
        NSString * path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"sayaren00%d",i] ofType:@"jpg"];
        UIImage*image=[UIImage imageWithContentsOfFile:path];
        
        [imageArrays addObject:image];
    }
    
    
    
    return imageArrays;
}

@end
