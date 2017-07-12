//
//  SearchResultsViewController.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/25.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchResultsViewControllerDelegate <NSObject>

//点击了哪一行 委托给搜索主控制器跳转
-(void)DelegateForReturnRow:(NSString*)idd andText:(NSString*)text;
//释放键盘
-(void)DelegateResignFirstRespon;

@end

@interface SearchResultsViewController : UIViewController
@property(nonatomic,strong)NSArray*allDatas;
@property(nonatomic,weak)id<SearchResultsViewControllerDelegate>delegate;
@end
