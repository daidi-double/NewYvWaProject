//
//  HUDFailureShowView.m
//  NewVipxox
//
//  Created by 黄佳峰 on 16/8/29.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "HUDFailureShowView.h"

@implementation HUDFailureShowView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        UIButton*retryButton=[self viewWithTag:3];
        retryButton.layer.cornerRadius=6;
        retryButton.layer.masksToBounds=YES;
        [retryButton addTarget:self action:@selector(touchRetry:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImageView*imageView=[self viewWithTag:1];
        imageView.animationImages=[self animationImages];
        imageView.animationDuration=3;
        imageView.animationRepeatCount=0;
        [imageView startAnimating];
        
        
        
    }
    return self;
}


-(NSArray*)animationImages{
//    NSFileManager*fileM=[NSFileManager defaultManager];
//    NSString*path=[[NSBundle mainBundle]pathForResource:@"GifBundle" ofType:@"bundle"];
//    NSArray*array=[fileM contentsOfDirectoryAtPath:path error:nil];
//    
//    NSMutableArray*imageArrays=[NSMutableArray array];
//    
//    for (NSString*imageStr in array) {
//        UIImage*image=[UIImage imageNamed:[@"GifBundle.bundle" stringByAppendingPathComponent:imageStr]];
//        [imageArrays addObject:image];
//        
//    }
//    
//    
//    return imageArrays;
    
    NSMutableArray*imageArrays=[NSMutableArray array];
    for (int i=0; i<32; i++) {
        NSString * path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"sayaren00%d",i] ofType:@"jpg"];
        UIImage*image=[UIImage imageWithContentsOfFile:path];
        [imageArrays addObject:image];
    }
    
    
    
    return imageArrays;

    
}



-(void)touchRetry:(UIButton*)sender{
//    MyLog(@"bee");
    self.reloadBlock();
    
    
}


@end
