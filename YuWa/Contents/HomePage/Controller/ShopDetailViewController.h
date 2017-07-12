//
//  ShopDetailViewController.h
//  YuWa
//
//  Created by double on 17/4/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImageView;

@property (weak, nonatomic) IBOutlet UIView *BGView;//毛玻璃的底层
@property (weak, nonatomic) IBOutlet UIImageView *BGImageView;//毛玻璃效果层
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *shopCarBtn;//购物车
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;//更多
@property (weak, nonatomic) IBOutlet UILabel *everyMoneyLabel;//人均
@property (weak, nonatomic) IBOutlet UILabel *monthMoneyLabel;//月消费人次
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;//闪付立享几折
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//地址
@property (weak, nonatomic) IBOutlet UIView *manDanView;
@property (weak, nonatomic) IBOutlet UIView *shopAndCommontView;//商品和评价背景层
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UIImageView *accountImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//选择的数量
@property (weak, nonatomic) IBOutlet UIView *bottomBGView;//最底下的那个view
@property (weak, nonatomic) IBOutlet UIView *accountBGView;

@property (nonatomic,copy) NSString * shop_id;
@end
