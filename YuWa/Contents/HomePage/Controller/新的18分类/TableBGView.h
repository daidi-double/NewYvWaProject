//
//  TableBGView.h
//  YuWa
//
//  Created by double on 17/2/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TableBGViewDelegate <NSObject>

- (void)creatPlaceView:(NSInteger)tag andTitle:(NSString *)title;

@end
@interface TableBGView : UIView
@property (nonatomic,assign) NSInteger staus;
@property (nonatomic,copy)NSString * cityCode;
@property (nonatomic,copy) void (^titleBlock)(NSString * title,NSString * cityCode);
@property (nonatomic,copy) void (^titleBlockT)(NSString * title,NSString * listType);
@property (nonatomic,strong)NSString * filmCode;
@property (nonatomic,assign)id<TableBGViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andTag:(NSInteger)tag andTitle:(NSString *)title andIndex:(NSInteger)index andFilmCode:(NSString*)filmCode andCityCode:(NSString*)cityCode;//index 0为首页，1为选择影院

@end

