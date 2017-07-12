//
//  YWChooseTwoView.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/27.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWChooseTwoView.h"
#import "YWChooseOneTableViewCell.h"


#define CELL0   @"YWChooseOneTableViewCell"


@interface YWChooseTwoView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView*lineView;

@property(nonatomic,strong)UITableView*leftTableView;
@property(nonatomic,strong)UITableView*rightTableView;

//@property(nonatomic,strong)NSMutableArray*leftModelArray;
//@property(nonatomic,strong)NSMutableArray*rightModelArray;


@property(nonatomic,strong)NSMutableArray*arrayleft;
@property(nonatomic,strong)NSMutableArray*arrayRight;

@property(nonatomic,assign)NSInteger selectedNumber;    //选中的number
@end

@implementation YWChooseTwoView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.selectedNumber=0;
        
        for (int i=0; i<2; i++) {
            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width/2*i, 0, kScreen_Width/2, 40)];
            [button setTitle:@"商圈" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:15];
            button.tag=100+i;
            [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            
            if (button.tag==100) {
                [self addSubview:self.lineView];
            }
            
        }
        
        
        //创建两个 tableView
        [self addSubview:self.leftTableView];
        [self addSubview:self.rightTableView];
        
        [self.leftTableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
        [self.rightTableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
        
        
        
        
    }
    return self;
}

#pragma mark  -- tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.leftTableView]) {
        return self.arrayleft.count;
    }else{
        return [self.arrayRight[self.selectedNumber] count];
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.leftTableView]) {
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        cell.textLabel.text=self.arrayleft[indexPath.row];
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.font=[UIFont systemFontOfSize:12];
        
        return cell;
        
    }else{
        
          YWChooseOneTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        UIButton*button2=[cell viewWithTag:2];
        button2.hidden=NO;
        [button2 setTitle:self.arrayRight[self.selectedNumber][indexPath.row][@"subString"] forState:UIControlStateNormal];

        
        UIButton*button1=[cell viewWithTag:1];
        [button1 setTitle:self.arrayRight[self.selectedNumber][indexPath.row][@"mainString"] forState:UIControlStateNormal];
        
        
        return cell;
    }
    
    
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.leftTableView]) {
        for (int i=0; i<self.arrayleft.count; i++) {
            UITableViewCell*cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.textLabel.textColor=[UIColor blackColor];

            
        }
        
        UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor=CNaviColor;
        self.selectedNumber=indexPath.row;
        [self.rightTableView reloadData];
        
    }else{

        NSString*name=self.arrayRight[self.selectedNumber][indexPath.row][@"mainString"];
        if (_touchTableViewCellBlock) {
            _touchTableViewCellBlock(name);
        }
        
        
    }
    
}


#pragma mark -- touch
-(void)touchButton:(UIButton*)sender{
    NSInteger number =sender.tag-100;
    self.lineView.frame=CGRectMake(kScreen_Width/2*number, self.lineView.top, kScreen_Width/2, 2);
    
    MyLog(@"%lu",number);
    if (_touchAddressBlock) {
        _touchAddressBlock(number);
    }
    
    
}




#pragma mark  --set
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 40-2, kScreen_Width/2, 2)];
        _lineView.backgroundColor=CNaviColor;
    }
    return _lineView;
}

-(UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate=self;
        _leftTableView.dataSource=self;
    }
    return _leftTableView;
}

-(UITableView *)rightTableView{
    if (!_rightTableView) {
        _rightTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.delegate=self;
        _rightTableView.dataSource=self;
    }
    return _rightTableView;
}


-(void)setAllDatas:(NSArray *)allDatas{
    _allDatas=allDatas;
    self.leftTableView.frame=CGRectMake(0, 40, 120, self.frame.size.height-40);
    self.rightTableView.frame=CGRectMake(120, 40, kScreen_Width-120, self.frame.size.height-40);
    
    NSMutableArray*arrayleft=[NSMutableArray array];
    NSMutableArray*arrayRight=[NSMutableArray array];
    self.arrayleft=arrayleft;
    self.arrayRight=arrayRight;
    for (NSDictionary*maindict in allDatas) {
       NSString*str= maindict.allKeys.firstObject;
       NSArray*array=maindict.allValues.firstObject;
        
        [arrayleft addObject:str];
        [arrayRight addObject:array];
    
        
        
    }
    
    
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    
    
}


//-(NSMutableArray *)leftModelArray{
//    if (!_leftModelArray) {
//        _leftModelArray=[NSMutableArray array];
//    }
//    return _leftModelArray;
//}
//
//-(NSMutableArray *)rightModelArray{
//    if (!_rightModelArray) {
//        _rightModelArray=[NSMutableArray array];
//    }
//    return _rightModelArray;
//}

@end
