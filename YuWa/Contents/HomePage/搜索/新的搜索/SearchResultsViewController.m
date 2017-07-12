//
//  SearchResultsViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/25.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "ResultsTableViewCell.h"
#import "showResultsViewController.h"   //展示搜索结果

#define RESULTSCELL  @"ResultsTableViewCell"

@interface SearchResultsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView*tableView;
@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:RESULTSCELL bundle:nil] forCellReuseIdentifier:RESULTSCELL];
    
}
//-(void)falseDatas{
//    self.allDatas=@[@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4"];
//    
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allDatas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultsTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:RESULTSCELL];
    cell.selectionStyle=NO;
    UILabel*title =[cell viewWithTag:1];
    title.text=self.allDatas[indexPath.row][@"title"];
    
    UILabel*number=[cell viewWithTag:2];
    number.text=self.allDatas[indexPath.row][@"num"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不能跳转  只能 代理了。。
    //通过数据帅选 idd
    NSString*str=self.allDatas[indexPath.row][@"title"];
    
    if ([self.delegate respondsToSelector:@selector(DelegateForReturnRow:andText:)]) {
        [self.delegate DelegateForReturnRow:nil andText:str];
    }
    
    
      
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.alwaysBounceVertical=YES;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

//隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [[self findFirstResponderBeneathView:self.navigationController.view] resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(DelegateResignFirstRespon)]) {
        [self.delegate DelegateResignFirstRespon];
    }
    
    
}

-(void)setAllDatas:(NSArray *)allDatas{
    _allDatas=allDatas;
    [self.tableView reloadData];
    
}


@end
