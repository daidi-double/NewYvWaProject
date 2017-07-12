//
//  CommitShopView.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/18.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CommitShopView.h"

@implementation CommitShopView


-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchHeader)];
    [self addGestureRecognizer:tap];
    
    
}

-(void)touchHeader{
    MyLog(@"11");
    if (self.touchBlock) {
        self.touchBlock();
    }
}

@end
