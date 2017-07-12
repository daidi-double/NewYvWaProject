//
//  ImageCache.h
//  CZhao
//
//  Created by LeMo-test on 15/8/10.
//  Copyright (c) 2015年 youke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

+ (NSString *)documentsFolderPath;
+(NSString *)headImagePath:(UIImage *)image;
+(void)headImageClean;

@end
