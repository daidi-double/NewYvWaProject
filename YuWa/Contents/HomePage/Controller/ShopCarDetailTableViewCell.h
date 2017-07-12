//
//  ShopCarDetailTableViewCell.h
//  YuWa
//
//  Created by double on 17/4/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWCarListModel.h"
@protocol ShopCarDetailTableViewCellDeleate <NSObject>

-(void)cleaerShopCarList:(UIButton*)sender;
-(void)goToAccount:(NSString *)money andBtn:(UIButton*)sender;

@end
@interface ShopCarDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImageView;
@property (nonatomic,strong)YWCarListModel * model;
@property (nonatomic,strong)NSArray * shops;
@property(nonatomic,strong)NSMutableArray*saveAllImage;
@property(nonatomic,strong)NSMutableArray*saveAllLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *accountBtn;
@property (nonatomic,copy)NSString * shop_id;

@property (nonatomic,assign)id<ShopCarDetailTableViewCellDeleate>delegate;


+(CGFloat)getHeight:(NSArray*)array;
@end


