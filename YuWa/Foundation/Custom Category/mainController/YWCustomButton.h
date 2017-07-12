//
//  YWCustomButton.h
//  YuWa
//
//  Created by double on 17/6/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWCustomButton : UIButton
@property (nonatomic,strong)UILabel * title;
@property (nonatomic,strong)UIImageView *btnImageView;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title;

@end
