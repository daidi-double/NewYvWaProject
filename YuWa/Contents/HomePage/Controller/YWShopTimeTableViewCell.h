//
//  YWShopTimeTableViewCell.h
//  YuWa
//
//  Created by double on 17/4/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWShopTimeTableViewCell : UITableViewCell

@property(nonatomic,strong)NSMutableArray*saveAllLabel;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

+(CGFloat)getHeight:(NSArray*)array;
@property(nonatomic,strong)NSArray*times;


@end
