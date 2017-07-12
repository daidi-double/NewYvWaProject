//
//  CommentTableViewCell.h
//  YuWa
//
//  Created by 黄佳峰 on 16/9/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentModel;

@interface CommentTableViewCell : UITableViewCell
@property (nonatomic,assign)NSInteger status;//1为电影评论
//@property(nonatomic,strong)NSDictionary*allDatas;

-(void)giveValueWithModel:(CommentModel*)model;
+(CGFloat)getCellHeight:(CommentModel*)model;

@end
