//
//  ChooseBtnView.m
//  YuWa
//
//  Created by double on 17/3/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChooseBtnView.h"
#import "CustomTableViewCell.h"
#define CUSTOMCELL @"CustomTableViewCell"
@implementation ChooseBtnView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray * busnessImageArr = @[@"收支明细",@"直接介绍分红",@"间接介绍分红",@"商务会员分红",@"直接积分分红",@"间接积分分红",@"消费支出",@"退款",@"提现支出"];
        NSArray * customerImageArr = @[@"收支明细",@"直接介绍分红",@"间接介绍分红",@"消费支出",@"退款",@"提现"];
//        NSArray * shopImageArr = @[@"收支明细",@"直接介绍分红",@"间接介绍分红",@"积分分红",@"退款",@"提现",@"店铺收款"];
        self.type = [[UserSession instance].isVIP integerValue];
        if (self.type == 2) {
            [self.titleArr removeAllObjects];
            [self.titleArr addObjectsFromArray:busnessImageArr];
        }else if (self.type == 1){
            [self.titleArr removeAllObjects];
            [self.titleArr addObjectsFromArray:customerImageArr];
        }else{
//            [self.titleArr removeAllObjects];
//            [self.titleArr addObjectsFromArray:shopImageArr];
        }
        [self addSubview:self.titleTableView];
    }
    return self;
}
- (NSMutableArray*)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
        
    }
    return _titleArr;
}

- (UITableView*)titleTableView{
    if (!_titleTableView) {
        _titleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, 35*self.titleArr.count) style:UITableViewStylePlain];

        _titleTableView.delegate = self;
        _titleTableView.dataSource = self;
        _titleTableView.separatorColor = RGBCOLOR(235, 235, 235, 1);
//        [_titleTableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:CUSTOMCELL];
    }
    return _titleTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIButton * titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0, 0, kScreen_Width, 35);
    [titleBtn setTitleColor:RGBCOLOR(132, 132, 132, 1) forState:UIControlStateNormal];
    [titleBtn setTitleColor:CNaviColor forState:UIControlStateSelected];
    [titleBtn setTitle:self.titleArr[indexPath.row] forState:UIControlStateNormal];

    [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [titleBtn addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    titleBtn.tag = indexPath.row +100;
    [cell.contentView addSubview:titleBtn];
    if (indexPath.row == 0) {
        titleBtn.selected = YES;
        markBtn.selected = NO;
        markBtn = titleBtn;
    }
    
    
    
    return cell;
}


-(void)refreshAction:(UIButton*)sender{
    if (sender.selected == YES) {
        return;
    }
    sender.selected = YES;
    markBtn.selected = NO;
    markBtn = sender;
    
    self.titleBlock(sender.tag-100,self.titleArr[sender.tag-100]);
    [self.delegate goRefresh:sender.tag-100];
    
}


@end
