//
//  HomeSixChooseTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "HomeSixChooseTableViewCell.h"

@implementation HomeSixChooseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (int i=0; i<6; i++) {
            UIView*backView=[[UIView alloc]initWithFrame:self.frame];
            backView.tag=300+i;
            backView.layer.borderWidth=0.25;
            backView.layer.borderColor=RGBCOLOR(200, 199, 204, 1).CGColor;
            [self.contentView addSubview:backView];
            
            UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUp:)];
            [backView addGestureRecognizer:tap];
            
            UILabel*mainLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreen_Width/2-10-50-20, 20)];
            mainLabel.font=FONT_CN_30;
            mainLabel.tag=100+i;
            mainLabel.text=@"10元吃到爽";
            [backView addSubview:mainLabel];
            
            UILabel*subLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10+20+5, kScreen_Width/2-10-50-20, 20)];
            subLabel.font=FONT_CN_30;
            subLabel.tag=1000+i;
            subLabel.text=@"超值工作餐";
            [backView addSubview:subLabel];
            
            UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width/2-50-10, 10, 50, 50)];
            imageView.layer.cornerRadius=25;
            imageView.layer.masksToBounds=YES;
            imageView.tag=10000+i;
            imageView.backgroundColor=[UIColor redColor];
            [backView addSubview:imageView];
            
            
            if (i<2) {
                backView.frame=CGRectMake(kScreen_Width/2*i, 0, kScreen_Width/2, 200/3);
                
            }else if (i<4){
                backView.frame=CGRectMake(kScreen_Width/2*(i-2), 200/3, kScreen_Width/2, 200/3);
                
            }else{
                backView.frame=CGRectMake(kScreen_Width/2*(i-4), 200/3*2, kScreen_Width/2, 200/3);
                
            }
            
            
        }
        
        
    }
    
    return self;
}


-(void)tapUp:(UITapGestureRecognizer*)tap{
//    NSLog(@"%ld",tap.view.tag);
    NSInteger number = tap.view.tag-300;
    if (_sixChooseBlock) {
        _sixChooseBlock(number);
    }
    
    
}

@end
