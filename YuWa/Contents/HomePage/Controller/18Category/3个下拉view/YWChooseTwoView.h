//
//  YWChooseTwoView.h
//  YuWa
//
//  Created by 黄佳峰 on 16/9/27.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWChooseTwoView : UIView

@property(nonatomic,strong)NSArray*allDatas;

@property(nonatomic,strong)void(^touchAddressBlock)(NSInteger number);    //点击上面的两个按钮
@property(nonatomic,strong)void(^touchTableViewCellBlock)(NSString*name);   //选择了什么

@end
