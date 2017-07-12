//
//  BannerModel.h
//  YuWa
//
//  Created by double on 17/5/10.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject
@property (nonatomic,copy)NSString * image;
@property (nonatomic,copy)NSString * film_code;//影片编码或链接
@property (nonatomic,copy)NSString * type;//0影片，1链接
@property (nonatomic,copy)NSString * sort;//排序，越大越优先
@property (nonatomic,copy)NSString * film_name;
@end
