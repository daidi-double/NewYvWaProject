//
//  defineButton.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/19.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "defineButton.h"

@implementation defineButton

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        CGFloat buttonFloat=(kScreen_Width-82)/4;
//        
//        self.topLabel.frame=CGRectMake(0, 0, frame.size.width, frame.size.height/2);
//        self.topLabel.textAlignment=NSTextAlignmentCenter;
//        self.topLabel.font=FONT_CN_30;
//        self.topLabel.text=@"关注";
//        
//        self.bottomLabel.frame=CGRectMake(0, self.topLabel.bottom, frame.size.width, frame.size.height/2);
//        self.bottomLabel.textAlignment=NSTextAlignmentCenter;
//        self.bottomLabel.font=FONT_CN_30;
//        self.bottomLabel.text=@"9";
//        
//        
//        UIView*VlineView=[[UIView alloc]initWithFrame:CGRectMake(frame.size.width-1, frame.size.height/4, 1, frame.size.height/2)];
//        VlineView.backgroundColor=[UIColor whiteColor];
//        
//        
//        
//        
//    }
//    return self;
//}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        self.backgroundColor=[UIColor blueColor];
        
        self.topLabel=[[UILabel alloc]init];
        self.topLabel.frame=CGRectMake(0, 0, self.width,self.height);
        self.topLabel.textAlignment=NSTextAlignmentCenter;
        self.topLabel.font=[UIFont systemFontOfSize:15];
        self.topLabel.text=@"关注";
        self.topLabel.textColor=[UIColor whiteColor];
//        self.topLabel.backgroundColor=[UIColor greenColor];
        [self addSubview:self.topLabel];
        
        self.bottomLabel=[[UILabel alloc]init];
        self.bottomLabel.frame=CGRectMake(0, self.topLabel.bottom, self.frame.size.width, self.frame.size.height/2);
        self.bottomLabel.textAlignment=NSTextAlignmentCenter;
        self.bottomLabel.textColor=[UIColor whiteColor];
        self.bottomLabel.font=[UIFont systemFontOfSize:15];
        self.bottomLabel.text=@"9";
         [self addSubview:self.bottomLabel];
        
        
        UIView*VlineView=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width-1, self.frame.size.height/4, 1, self.frame.size.height/2)];
        VlineView.backgroundColor=[UIColor whiteColor];
        self.VlineView=VlineView;
        [self addSubview:VlineView];

//        self.backgroundColor=[UIColor blueColor];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
     self.topLabel.frame=CGRectMake(0, 0, self.width,self.height/2);
    self.bottomLabel.frame=CGRectMake(0, self.topLabel.bottom, self.frame.size.width, self.frame.size.height/2);
    self.VlineView.frame=CGRectMake(self.frame.size.width-1, self.frame.size.height/4, 1, self.frame.size.height/2);
    
    
    
//    self.bottomLabel.backgroundColor=[UIColor yellowColor];

    
}


//-(void)awakeFromNib{
//    [super awakeFromNib];
//    self.topLabel=[[UILabel alloc]init];
//    self.topLabel.frame=CGRectMake(0, 0, self.frame.size.width,self.frame.size.height/2);
//    self.topLabel.textColor=[UIColor whiteColor];
//    self.topLabel.textAlignment=NSTextAlignmentCenter;
//    self.topLabel.font=FONT_CN_30;
//    self.topLabel.text=@"关注";
//    [self addSubview:self.topLabel];
//    
//    self.bottomLabel=[[UILabel alloc]init];
//    self.bottomLabel.frame=CGRectMake(0, self.topLabel.bottom, self.frame.size.width, self.frame.size.height/2);
//    self.bottomLabel.textColor=[UIColor whiteColor];
//    self.bottomLabel.textAlignment=NSTextAlignmentCenter;
//    self.bottomLabel.font=FONT_CN_30;
//    self.bottomLabel.text=@"9";
//    [self addSubview:self.bottomLabel];
//    
//    
////    if (self.tag!=14) {
//        self.VlineView=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width-1, self.frame.size.height/4, 1, self.frame.size.height/2)];
//        self.VlineView.backgroundColor=[UIColor whiteColor];
//        [self addSubview:self.VlineView];
//
////    }
//    
// 
//    
//}

@end
