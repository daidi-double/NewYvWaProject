//
//  YYCoreData.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/26.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCoreData : NSObject
+(YYCoreData*)shareCoreData;

-(NSString*)userResPath:(NSString*)resPath;
@end
