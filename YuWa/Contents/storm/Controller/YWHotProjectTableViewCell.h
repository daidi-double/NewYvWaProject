//
//  YWHotProjectTableViewCell.h
//  YuWa
//
//  Created by double on 17/6/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YWHotProjectTableViewCellDelegate <NSObject>

- (void)toShopPlanPage:(UIButton*)sender;
//- (void)toShopPlanPages:(UIImageView*)imageView;

@end
@interface YWHotProjectTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic,assign)id<YWHotProjectTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stageLabel;//阶段（已有用户）
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLaber;//当前竞价-文字
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLaber;//当前竞价-价格
@property (weak, nonatomic) IBOutlet UILabel *currentNumber;//当前围观人数和竞拍人数
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;//距离结束时间
@property (weak, nonatomic) IBOutlet UIImageView *statusLaber;//状态---拍卖中
@property (weak, nonatomic) IBOutlet UIButton *auctionBtn;//竞拍按钮

@end



