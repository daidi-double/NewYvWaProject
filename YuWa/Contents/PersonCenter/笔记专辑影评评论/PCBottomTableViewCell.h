//
//  PCBottomTableViewCell.h
//  YuWa
//
//  Created by 黄佳峰 on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPPersonCenterViewController.h"

@protocol PCBottomTableViewCellDelegate <NSObject>

-(void)DelegateForNote:(NSInteger)number;    //-1 为发布

-(void)DelegateForAlbum:(NSInteger)number andMax:(NSInteger)maxNumber;  //专辑


////选中了评论下面的 那个按钮
//-(void)DelegateForSelectedWhichButton:(NSInteger)section;
//点击了评论那里的店铺按钮
-(void)DelegateForToShopDetail:(NSString*)shopid;

@end

@interface PCBottomTableViewCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDatas:(NSMutableArray*)allDatas andWhichCategory:(showViewCategory)number;

-(instancetype)initWithOtherStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDatas:(NSMutableArray*)allDatas andWhichCategory:(showViewCategory)number;

@property(nonatomic,assign)id<PCBottomTableViewCellDelegate>delegate;
@end
