//
//  MovieHeaderModel.h
//  YuWa
//
//  Created by double on 17/2/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieHeaderModel : NSObject
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * sub_title;
@property (nonatomic,strong) NSString * grade;//评分
@property (nonatomic,strong) NSString * sort;//类别
@property (nonatomic,strong) NSString * country_time;
@property (nonatomic,strong) NSString * play_time;
@property (nonatomic,strong) NSString * picUrl;
@property (nonatomic,assign) BOOL isWantLook;//想看
@property (nonatomic,assign) BOOL isGrade;//是否评分
@property (nonatomic,strong) NSString * user_grade;//用户评分

+ (MovieHeaderModel*)movieHeaderModelWithDic:(NSDictionary*)dic;

@end
