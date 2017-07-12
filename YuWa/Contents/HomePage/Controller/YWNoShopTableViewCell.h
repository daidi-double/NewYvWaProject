//
//  YWNoShopTableViewCell.h
//  YuWa
//
//  Created by double on 17/4/26.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YWNoShopTableViewCellDelegate <NSObject>

- (void)toBuyShop;

@end
@interface YWNoShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImageView;
@property (nonatomic,weak) id<YWNoShopTableViewCellDelegate>delegate;
@end
