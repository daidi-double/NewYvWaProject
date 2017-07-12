//
//  MarketResearchTableViewCell.h
//  YuWa
//
//  Created by double on 17/6/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketResearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goalMarketNumberT;//目标人数2
@property (weak, nonatomic) IBOutlet UILabel *goalNumberLabel;//目标人数1
@property (weak, nonatomic) IBOutlet UILabel *marketTitleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *marketTypeLabel;//市场类型（90后）
@property (weak, nonatomic) IBOutlet UILabel *marketOne;//目标市场
@property (weak, nonatomic) IBOutlet UILabel *marketTwo;//目标市场
@property (weak, nonatomic) IBOutlet UILabel *marketTypeName;//市场类型
@property (weak, nonatomic) IBOutlet UILabel *goodTitleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;//团队
@property (weak, nonatomic) IBOutlet UILabel *otherGoodLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodContentLabel;//其他优势





@end
