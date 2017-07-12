//
//  DetailStoreFirstTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "DetailStoreFirstTableViewCell.h"

@implementation DetailStoreFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    UIButton*mapButton=[self viewWithTag:21];
//    [mapButton addTarget:self action:@selector(touchLocate) forControlEvents:UIControlEventTouchUpInside];
//    
    //文字
    UILabel*label=[self viewWithTag:22];
    UITapGestureRecognizer*labelTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLocate)];
     label.userInteractionEnabled=YES;
    [label addGestureRecognizer:labelTap];
    
    //左边的button
    UIButton*button=[self viewWithTag:25];
    [button addTarget:self action:@selector(addCollection) forControlEvents:UIControlEventTouchUpInside];
    
    //右边的图片
    UIImageView*imageView=[self viewWithTag:23];
    imageView.userInteractionEnabled=YES;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchPhone)];
    [imageView addGestureRecognizer:tap];
    
    
    //抢店铺的优惠券
    UIImageView*QiangImageView=[self viewWithTag:31];
    QiangImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer*tapp=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchQiang)];
    [QiangImageView addGestureRecognizer:tapp];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)touchPay:(UIButton *)sender {
    if (self.touchPayBlock) {
        self.touchPayBlock();
    }
    
}
- (void)touchLocate{
    MyLog(@"locate");
    if (self.touchLocateBlock) {
        self.touchLocateBlock();
    }
   
    
}


-(void)addCollection{
    //加入收藏
    if (self.touchAddCollection) {
        self.touchAddCollection();
    }
    
}

- (void)touchPhone{
    MyLog(@"phone");
    if (self.touchPhoneBlock) {
        self.touchPhoneBlock();
    }

}

-(void)touchQiang{
    if (self.touchQiangBlock) {
        self.touchQiangBlock();
    }
    
}


@end
