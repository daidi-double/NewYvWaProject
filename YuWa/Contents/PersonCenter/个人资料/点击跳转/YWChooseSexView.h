//
//  YWChooseSexView.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface YWChooseSexView : UIView
@property(nonatomic,strong)UIPickerView*pickerView;
@property(nonatomic,copy)void(^touchConfirmBlock)(NSString*value);
@property(nonatomic,copy)void(^touchCancelBlock)();

-(YWChooseSexView*)initWithCustomeHeight:(CGFloat)height;
@end
