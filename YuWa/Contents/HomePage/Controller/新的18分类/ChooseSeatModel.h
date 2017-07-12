//
//  ChooseSeatModel.h
//  YuWa
//
//  Created by double on 17/5/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
//{
//    "code":"0300004100100101",
//    "colNum":"1",
//    "groupCode":"0201010071000041",
//    "loveCode":"",
//    "rowNum":"1",
//    "status":1,
//    "type":1,
//    "xcoord":1,
//    "ycoord":1
//},
@interface ChooseSeatModel : NSObject

@property (nonatomic,copy) NSString * code;//座位编码   1
@property (nonatomic,copy) NSString * colNum;//列号  1
@property (nonatomic,copy) NSString * groupCode;//分组编码
@property (nonatomic,copy) NSString * loveCode;//情侣座编码
@property (nonatomic,copy) NSString * rowNum;//行号
@property (nonatomic,copy) NSNumber * status;//可售状态（0：不可售，1可售）1
@property (nonatomic,copy) NSString * type;//座位类型1普通，2情侣
@property (nonatomic,copy) NSString * xcoord;//纵坐标，列
@property (nonatomic,copy) NSString * ycoord;//横坐标，排

+(NSMutableArray *)ChooseSeatModelWithDic:(NSMutableArray * )arr;

@end
