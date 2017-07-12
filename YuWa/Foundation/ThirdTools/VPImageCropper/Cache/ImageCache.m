//
//  ImageCache.m
//  CZhao
//
//  Created by LeMo-test on 15/8/10.
//  Copyright (c) 2015年 youke. All rights reserved.
//

#import "ImageCache.h"



#define CACHE_FOLDER        @"/Caches"
#define HEAD_IMAGE_NAME @"/headimage.png"

@implementation ImageCache
//document目录
+ (NSString *)documentsFolderPath
{
    return  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
//缓存目录
+ (NSString *)cacheFolderPath
{
    NSString *path=[[self documentsFolderPath] stringByAppendingPathComponent:CACHE_FOLDER];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return  path;
}
//头像路径
+(NSString *)headImagePath:(UIImage *)image
{
    NSString *path = [[self cacheFolderPath]stringByAppendingString:HEAD_IMAGE_NAME];
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    
    return path;
}
//头像清理
+(void)headImageClean
{
    NSString *path = [[[self documentsFolderPath]stringByAppendingString:CACHE_FOLDER]stringByAppendingString:HEAD_IMAGE_NAME];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}


@end
