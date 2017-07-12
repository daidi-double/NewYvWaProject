//
//  FilmDetailTableViewCell.h
//  YuWa
//
//  Created by double on 17/6/6.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilmDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UIButton *badBtn;
@property (nonatomic,assign)NSInteger ctype;//1：点赞或吐槽 2：取消点赞或吐槽
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (nonatomic,copy)NSString * filmNo;//影片编码
@property (nonatomic,assign)NSInteger type;//1点赞 2：吐槽
@property (nonatomic,strong)NSString * present_like;
@end
