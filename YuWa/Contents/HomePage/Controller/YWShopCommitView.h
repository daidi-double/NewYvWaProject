//
//  YWShopCommitView.h
//  YuWa
//
//  Created by double on 17/4/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWShopCommitView : UIView
@property (nonatomic,strong)UITableView * shopCommitTableView;
@property (nonatomic,copy)NSString * shop_id;
@property (nonatomic,copy)NSString * totalScore;//综合评分
@end
