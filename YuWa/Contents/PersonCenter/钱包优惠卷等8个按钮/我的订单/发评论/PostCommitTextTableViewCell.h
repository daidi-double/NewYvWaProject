//
//  PostCommitTextTableViewCell.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/18.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMTextView.h"

@interface PostCommitTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SAMTextView *samTextView;

@property (weak, nonatomic) IBOutlet UILabel *ShowLabel;
@end
