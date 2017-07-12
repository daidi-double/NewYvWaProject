//
//  YWPayMoneyTableViewCell.h
//  YuWa
//
//  Created by double on 17/4/25.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWPayMoneyTableViewCellDelegate <NSObject>

- (void)changMoney:(NSString *)money;

@end
@interface YWPayMoneyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UIImageView *youhuiImageView;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (nonatomic,copy) void(^moneyChangeBlock)(NSString * money);
@property (nonatomic,assign)id<YWPayMoneyTableViewCellDelegate>delegate;
-(void)hideBoradKey;
@end
