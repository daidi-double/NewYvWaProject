//
//  ChooseMovieController.h
//  YuWa
//
//  Created by double on 2017/2/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseMovieController : UIViewController

@property (nonatomic,assign) NSInteger  markRow;
@property (nonatomic,copy)NSString * filmCode;
@property (nonatomic,copy)NSString * filmName;//电影名称

@property (nonatomic,assign)BOOL isOtherTicket;//是否含有通兑票
@property (nonatomic,strong) NSMutableArray * cityCodeAry;
@property (nonatomic,copy)NSString * cityCode;
@property(nonatomic,strong)NSString*coordinatex;   //经度
@property(nonatomic,strong)NSString*coordinatey;   //维度
@end
