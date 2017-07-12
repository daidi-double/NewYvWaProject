//
//  STCountDownButton.h
//  STCountDownButton
//
//  Created by https://github.com/STShenZhaoliang/STCountDownButton on 16/2/14.
//  Copyright © 2016年 https://github.com/STShenZhaoliang/STCountDownButton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCountDownButton : UIButton

/**
 *  1.设置秒数
 */
@property (nonatomic, assign)NSInteger second; 

/**
 *  2.开始倒计时
 */
- (void)start;

/**
 *  3.结束倒计时
 */
- (void)stop;

@end
