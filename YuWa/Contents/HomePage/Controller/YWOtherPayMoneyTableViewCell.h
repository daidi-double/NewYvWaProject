//
//  YWOtherPayMoneyTableViewCell.h
//  YuWa
//
//  Created by double on 17/4/25.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YWOtherPayMoneyTableViewCellDelegate <NSObject>

- (void)useYouhuiquanAction;

@end
@interface YWOtherPayMoneyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic,assign) id<YWOtherPayMoneyTableViewCellDelegate>delegate;


@end
