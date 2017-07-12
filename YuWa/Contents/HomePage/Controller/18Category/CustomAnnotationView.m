//
//  CustomAnnotationView.m
//  YuWa
//
//  Created by double on 17/3/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "Customview.h"

@interface CustomAnnotationView ()
@property (nonatomic,strong)Customview * view;

@end
@implementation CustomAnnotationView

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    

    if (self.view == nil)
    {
        self.view = [[Customview alloc] initWithFrame:CGRectMake(0, 0, 100 , 25)];
        self.view.shopNameLabel.text = self.annotation.title;
    
//        self.view.backgroundColor = [UIColor whiteColor];
        CGRect rect = [self.view.shopNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.view.shopNameLabel.font} context:nil];
        self.view.width = rect.size.width + 20;
        self.view.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.view.bounds) / 2.f + self.calloutOffset.y);
    }
    self.view.shopName = self.annotation.title;
        [self addSubview:self.view];

    [super setSelected:selected animated:animated];
}


@end
