//
//  FilmListModel.h
//  YuWa
//
//  Created by double on 17/5/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilmListModel : NSObject
@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * name;//电影名称
@property (nonatomic,copy) NSString * code;//电影编码
@property (nonatomic,copy) NSString * score;
@property (nonatomic,copy) NSString * image;
@property (nonatomic,copy) NSString * publish_date;//上映时间
@property (nonatomic,copy) NSString * highlight;//简介
@property (nonatomic,copy) NSString * duration;//时长
@property (nonatomic,copy) NSString * allDate;//播放日期
@end
