//
//  CustomBtn.h
//  YuWa
//
//  Created by double on 2017/2/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBtn : UIButton
@property (nonatomic,strong) UIImageView * btnImageView;
@property (nonatomic,strong) UILabel * title;
-(instancetype)initWithFrame:(CGRect)frame  andTitle:(NSString*)title;

@end
