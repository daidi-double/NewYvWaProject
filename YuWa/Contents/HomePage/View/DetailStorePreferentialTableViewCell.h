//
//  DetailStorePreferentialTableViewCell.h
//  YuWa
//
//  Created by 黄佳峰 on 16/9/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailStorePreferentialTableViewCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

//得到的高
+(CGFloat)getCellHeightWitharray:(NSMutableArray*)array;

@property(nonatomic,strong)NSArray*allDatas;   //所有的数据
@property(nonatomic,strong)NSString*defultZhe;  //默认打几折

@end
