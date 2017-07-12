//
//  YWShopScoreTableViewCell.h
//  YuWa
//
//  Created by double on 17/4/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWShopScoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *shopScoreLabel;

@property (nonatomic,copy)NSString * totalScore;

@end
