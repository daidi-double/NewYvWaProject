//
//  YWNewShopInfoTableViewCell.h
//  YuWa
//
//  Created by double on 17/4/26.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWShopInfoListModel.h"
@interface YWNewShopInfoTableViewCell : UITableViewCell
@property (nonatomic,strong)NSMutableArray * dataAry;
@property (nonatomic,strong)YWShopInfoListModel * model;
@property (nonatomic,copy)NSString * shopName;
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (nonatomic,strong)NSArray * cart;
@property(nonatomic,strong)NSMutableArray*saveAllImage;
@property(nonatomic,strong)NSMutableArray*saveAllLabel;

@property (nonatomic,copy)NSString * shop_id;

+ (CGFloat)getHeight:(NSArray *)array;
@end
