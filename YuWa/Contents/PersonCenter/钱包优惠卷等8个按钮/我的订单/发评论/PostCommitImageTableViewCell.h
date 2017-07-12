//
//  PostCommitImageTableViewCell.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/18.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostCommitImageTableViewCellDelegate <NSObject>

-(void)delegateForTouchAddImage;
-(void)delegateForTouchDeleteImageWithTag:(NSInteger)tag;


@end

@interface PostCommitImageTableViewCell : UITableViewCell

//@property(nonatomic,strong)NSArray*allDatas;

@property(nonatomic,assign)id<PostCommitImageTableViewCellDelegate>delegate;

-(void)getDataImage:(NSArray*)array;
-(CGFloat)getCellHeightWith:(NSArray*)array;



@end
