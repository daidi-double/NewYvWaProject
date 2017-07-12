//
//  YWChooseOneView.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/26.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWChooseOneView.h"
#import "YWChooseOneTableViewCell.h"

#import "ChooseOneModel.h"


#define CELL0  @"YWChooseOneTableViewCell"

@interface YWChooseOneView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray*modelArray;

@end

@implementation YWChooseOneView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.tableView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.tableView];
        
        [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
        
        
    }
    
    return self;
}



#pragma mark  --tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.allDatas) {
        return [self.modelArray count];
    }else{
        return 0;
    }
   
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWChooseOneTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];

    ChooseOneModel*model=self.modelArray[indexPath.row];
        

    UIButton*button=[cell viewWithTag:1];
    [button setTitle:model.mainString forState:UIControlStateNormal];
    
    UIButton*numberButton=[cell viewWithTag:2];
    [numberButton setTitle:model.subString forState:UIControlStateNormal];
 
    
    if (model.isSelected==YES) {
        [button setSelected:YES];
        [numberButton setSelected:YES];
        
    }else{
        [button setSelected:NO];
        [numberButton setSelected:NO];

    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (int i=0; i<self.modelArray.count; i++) {
        ChooseOneModel*model=self.modelArray[i];
        model.isSelected=NO;
        }
    
    
    ChooseOneModel*model=self.modelArray[indexPath.row];
    model.isSelected=YES;
    [self.tableView reloadData];
    
    
    if (_ChooseOneBlock) {
        _ChooseOneBlock(model.mainString);
    }

    
    
    
}


#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 0) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

-(NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray=[NSMutableArray array];
    }
    return _modelArray;
}

-(void)setAllDatas:(NSArray *)allDatas{
    _allDatas=[allDatas copy];
    
    for (int i=0; i<allDatas.count; i++) {
        ChooseOneModel*model=[ChooseOneModel yy_modelWithJSON:allDatas[i]];
        [self.modelArray addObject:model];
    }
    
    
    
      self.tableView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.tableView reloadData];
    
}

@end
