//
//  UserAgreenmentViewController.h
//  YuWa
//
//  Created by double on 17/3/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAgreenmentViewController : UIViewController
@property (nonatomic,assign) NSInteger staus;
@property (nonatomic,copy)void (^agreeBlock)();
@end
