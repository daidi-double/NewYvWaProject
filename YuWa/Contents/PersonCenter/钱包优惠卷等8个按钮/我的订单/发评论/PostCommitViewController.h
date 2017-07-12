//
//  PostCommitViewController.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/18.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCommitViewController : UIViewController
@property(nonatomic,assign)NSInteger stauts;//判断跳回哪个界面
@property(nonatomic,strong)NSString*shop_id;   //店铺的id
@property(nonatomic,strong)NSString*order_id;   //订单id
@end
