//
//  YWMainShoppingTableViewCell.h
//  YuWa
//
//  Created by 黄佳峰 on 16/9/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWMainShoppingTableViewCell : UITableViewCell

@property(nonatomic,strong)NSArray*holidayArray;
@property(nonatomic,strong)NSString * zhekou;
@property (weak, nonatomic) IBOutlet UIView *bgLineView;


+(CGFloat)getCellHeight:(NSArray*)array;
@end
