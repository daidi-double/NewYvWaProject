//
//  YYCoreData.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/26.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "YYCoreData.h"

static YYCoreData *coreData=nil;

@implementation YYCoreData

+(YYCoreData*)shareCoreData{
    if (!coreData) {
        static dispatch_once_t token;
        dispatch_once(&token, ^{
            
            coreData=[[YYCoreData alloc]init];

        });
           }
    return coreData;
    
}

-(NSString*)userResPath:(NSString*)resPath{
    [self creatDomentPath];
    NSString*str=[[self getDomentPath] stringByAppendingString:resPath];
    return str;
    
}

-(void)creatDomentPath{
    NSFileManager*manager=[NSFileManager defaultManager];
  BOOL succeed=  [manager createDirectoryAtPath:[self getDomentPath] withIntermediateDirectories:YES attributes:nil error:nil];
    if (succeed) {
        NSLog(@"创建用户路径成功：%@",[self getDomentPath]);
    }else{
        NSLog(@"创建用户路径失败：%@",[self getDomentPath]);
    };
    
}

-(NSString*)getDomentPath{
    NSArray*path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*documentPath=path[0];
    NSString*userName=@"Search";
    return [documentPath stringByAppendingString:userName];
}


@end
