//
//  YWShopCarView.h
//  YuWa
//
//  Created by double on 17/4/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YWShopCarViewDelegate <NSObject>

-(void)clearShop;

@end
@interface YWShopCarView : UIView
//@property (weak, nonatomic) IBOutlet UITableView *shopTableView;
//@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (strong, nonatomic)  UITableView *shopTableView;
@property (strong, nonatomic)  UIButton *clearBtn;
@property (nonatomic,strong) UIView * clearView;
@property (nonatomic,strong) UILabel * strLabel;
@property (nonatomic,copy) NSString * shop_id;
@property (nonatomic,assign)id<YWShopCarViewDelegate>delegate;

@property (nonatomic,strong)NSMutableArray * shopInfoAry;

+(CGFloat)getCellHeight:(NSArray *)array;

@end





