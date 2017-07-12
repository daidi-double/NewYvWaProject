//
//  YWNewUseCouponTableViewCell.h
//  YuWa
//
//  Created by double on 17/4/25.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YWNewUseCouponTableViewCellCellDelegate <NSObject>

- (void)useYouhuiquanAction;

@end

@interface YWNewUseCouponTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;
@property (weak, nonatomic) IBOutlet UILabel *useCouponLabel;

@property (nonatomic,assign) id<YWNewUseCouponTableViewCellCellDelegate>delegate;


@end
