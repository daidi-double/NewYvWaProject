//
//  scheduleTwoTableViewCell.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scheduleTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *LadyButton;

@property(nonatomic,strong)void(^touchSelectedSexBlock)(NSString*str);
@end
