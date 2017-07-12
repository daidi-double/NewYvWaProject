//
//  YWActivityTableViewCell.h
//  YuWa
//
//  Created by double on 17/4/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWActivityTableViewCell : UITableViewCell
@property(nonatomic,strong)NSMutableArray*saveAllImage;
@property(nonatomic,strong)NSMutableArray*saveAllLabel;
@property(nonatomic,strong)NSArray*holidayArray;
@property(nonatomic,strong)NSString * zhekou;
@property (weak, nonatomic) IBOutlet UIView *titleBGView;

+(CGFloat)getCellHeight:(NSArray*)array;

@end
