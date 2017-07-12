//
//  ChooseBtnView.h
//  YuWa
//
//  Created by double on 17/3/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseBtnViewDelegate <NSObject>

-(void)goRefresh:(NSInteger)row;

@end

@interface ChooseBtnView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIButton * markBtn;
}
@property(nonatomic,strong)UITableView * titleTableView;
@property(nonatomic,strong)NSMutableArray * titleArr;
@property (nonatomic,strong)UIImageView * titleImageView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,assign)NSInteger type;//0-商务会员 1- 消费者 2 - 商家
@property (nonatomic,copy)void (^titleBlock)(NSInteger row,NSString * title);
@property (nonatomic,assign) id <ChooseBtnViewDelegate>delegate;
@end



