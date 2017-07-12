//
//  SellerIntroductTableViewCell.h
//  YuWa
//
//  Created by double on 17/6/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerIntroductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sellerIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *identityLabel;//身份1：创始人
@property (weak, nonatomic) IBOutlet UILabel *identityTwoLabel;//身份2：上午会员
@property (weak, nonatomic) IBOutlet UILabel *identityThreeLabel;//身份3：毕业院校和其他
@property (weak, nonatomic) IBOutlet UIImageView *sureNameImageView;//是否实名认证
@property (weak, nonatomic) IBOutlet UIScrollView *projectScrollView;



@end
