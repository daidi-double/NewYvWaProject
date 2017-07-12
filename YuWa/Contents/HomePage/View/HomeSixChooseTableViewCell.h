//
//  HomeSixChooseTableViewCell.h
//  YuWa
//
//  Created by 黄佳峰 on 16/9/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeSixChooseTableViewCell : UITableViewCell

@property(nonatomic,strong)void(^sixChooseBlock)(NSInteger number);
@end
