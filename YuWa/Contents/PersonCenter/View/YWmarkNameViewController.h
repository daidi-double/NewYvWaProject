//
//  YWmarkNameViewController.h
//  YuWa
//
//  Created by L灰灰Y on 2017/6/12.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWmarkNameViewController : UIViewController
@property (nonatomic, copy) void(^nickName)(NSString * name);
@end
