//
//  CommitView.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CommitView.h"
#import "CommentTableViewCell.h"
#import "CommitShopView.h"
#import "CommentModel.h"
//#import "CommitViewModel.h"
#import "YJSegmentedControl.h"

#define CELL0  @"CommentTableViewCell"


@interface CommitView()<UITableViewDataSource,UITableViewDelegate,YJSegmentedControlDelegate>
@property(nonatomic,strong)UITableView*tableView;
//@property(nonatomic,strong)UIView*topView; //顶部的view

@property(nonatomic,strong)NSMutableArray*allDatas;
@end
@implementation CommitView

-(void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

-(instancetype)initWithFrame:(CGRect)frame andArray:(NSMutableArray*)allDatas{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.allDatas=allDatas;
        [self addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];

//        [self addTableHeaderView];
        
    }
    
    return self;
}




#pragma mark  --tableView

//-(void)addTableHeaderView{
//
//    UIView*topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
//    topView.backgroundColor=[UIColor whiteColor];
//    self.topView=topView;
//    NSArray*titleArray=@[@"评论",@"电影",@"酒店"];
//    YJSegmentedControl*chooseView=[YJSegmentedControl segmentedControlFrame:CGRectMake(0, 0, kScreen_Width, 30) titleDataSource:titleArray backgroundColor:[UIColor whiteColor] titleColor:CsubtitleColor titleFont:[UIFont systemFontOfSize:14] selectColor:CNaviColor buttonDownColor:CNaviColor Delegate:self];
////    [chooseView selectTheSegument:2];
//    
//    [topView addSubview:chooseView];
//    
//    self.tableView.tableHeaderView=topView;
//    
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allDatas.count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    CommentModel *model=self.allDatas[indexPath.section];
    [cell giveValueWithModel:model];
//    cell.backgroundColor=[UIColor yellowColor];
   
    
    return cell;
    

    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CommitShopView*footView=[[NSBundle mainBundle]loadNibNamed:@"CommitShopView" owner:nil options:nil].firstObject;
    footView.frame=CGRectMake(0, 0, kScreen_Width, 60);
    CommentModel*model=_allDatas[section];

    footView.touchBlock=^(){
        MyLog(@"section=%lu",section);
        NSString*shopid=model.shop.id;
        if ([self.delegate respondsToSelector:@selector(DelegateToShop:)]) {
            [self.delegate DelegateToShop:shopid];
        }
        
    };
    
    
    UIImageView*imageView=[footView viewWithTag:1];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.shop.company_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

    UILabel*nameLabel=[footView viewWithTag:2];
    nameLabel.text=[NSString stringWithFormat:@"%@",model.shop.company_name];
    
    UILabel*locateLabel=[footView viewWithTag:3];
    locateLabel.text=[NSString stringWithFormat:@"%@  %@",model.shop.company_address,model.shop.catname];
    
    
    
    return footView;
    
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model=self.allDatas[indexPath.section];
    CGFloat aa=[CommentTableViewCell getCellHeight:model];
    return aa;
//    return 200;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}


#pragma mark  --delegate
//-(void)segumentSelectionChange:(NSInteger)selection{
//    MyLog(@"xxx");
//    //代理回去 刷新
//    if ([self.delegate respondsToSelector:@selector(DelegateForSelectedChange:)]) {
//        [self.delegate DelegateForSelectedChange:selection];
//    }
//    
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.scrollEnabled=NO;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end
