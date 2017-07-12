//
//  RBNodeShowViewController.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBBasicViewController.h"
#import "RBHomeModel.h"

@interface RBNodeShowViewController : RBBasicViewController

@property (nonatomic,strong)RBHomeModel * model;
@property (nonatomic,strong)NSString * note_id;//从被赞、被收藏界面过来
@property (nonatomic,assign)BOOL isUser;//是否是自己
- (void)setupRefresh;
@end
