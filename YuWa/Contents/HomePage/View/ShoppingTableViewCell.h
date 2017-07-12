//
//  ShoppingTableViewCell.h
//  YuWa
//
//  Created by 黄佳峰 on 16/10/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingTableViewCell : UITableViewCell

@property(nonatomic,strong)NSMutableArray*allDatas;

@property(nonatomic,strong)void(^touchCollectionViewBlock)(NSInteger number);

@end
