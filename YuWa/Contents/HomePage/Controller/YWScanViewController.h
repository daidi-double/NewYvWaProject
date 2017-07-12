//
//  YWScanViewController.h
//  YuWa
//
//  Created by double on 17/3/31.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWScanViewController : UIViewController
@property (nonatomic,assign)void(^stringValueBlock)(NSString * stringValue);
@end
