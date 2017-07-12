//
//  LookAllViewController.h
//  YuWa
//
//  Created by double on 2017/2/18.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookAllViewController : UIViewController
@property(nonatomic,strong)NSString*coordinatex;   //经度
@property(nonatomic,strong)NSString*coordinatey;   //维度
@property (nonatomic,strong) UIButton * sellBtn;
@property (nonatomic,copy)NSString * cityCode;
@end
