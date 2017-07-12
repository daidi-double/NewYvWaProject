//
//  InfomationTableViewCell.h
//  YuWa
//
//  Created by double on 17/5/10.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaLabelModel.h"
@interface InfomationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic,strong) CinemaLabelModel * model;
@end
