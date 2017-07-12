//
//  BusinessMumberHeaderView.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "BusinessMumberHeaderView.h"

@interface BusinessMumberHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation BusinessMumberHeaderView


-(void)awakeFromNib{
     [super awakeFromNib];

    [self makeUI];
    UIView*totailView=[self viewWithTag:21];
    UITapGestureRecognizer*totailTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTotailTap)];
    [totailView addGestureRecognizer:totailTap];
    
    UIView*WillView=[self viewWithTag:22];
    UITapGestureRecognizer*WillTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchWillTap)];
    [WillView addGestureRecognizer:WillTap];

}
- (void)makeUI{
    
    self.imageView=[self viewWithTag:100];

    _imageView.animationImages=[self animationImages];
    _imageView.animationDuration=3;
    _imageView.animationRepeatCount=0;
    [_imageView startAnimating];


}
-(NSArray*)animationImages{
    NSMutableArray*imageArrays=[NSMutableArray array];
    for (int i=0; i<60; i++) {
        NSString*imageName=[NSString stringWithFormat:@"波浪个人_000%d",i];
        NSBundle*bundle=[NSBundle mainBundle];
        NSString*path=[bundle pathForResource:imageName ofType:@"png"];
        
        UIImage*image=[UIImage imageWithContentsOfFile:path];
        [imageArrays addObject:image];
    }
    return imageArrays;
}

-(void)touchTotailTap{
   
    if (self.TotailBlock) {
        self.TotailBlock();
    }
    
}
- (IBAction)questionBtnAction:(UIButton *)sender {
}

-(void)touchWillTap{
    if (self.waitBlock) {
        self.waitBlock();
    }
    
}

@end
