//
//  MovieResultViewController.m
//  YuWa
//
//  Created by double on 17/6/1.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieResultViewController.h"
#import "CinameTableViewCell.h"
#import "CinemaModel.h"
#import "MovieCinemaViewController.h"

#define CINAMECELL232 @"CinameTableViewCell"
@interface MovieResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * resultTabelView;
@end

@implementation MovieResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"搜索结果";
    self.view.backgroundColor=[UIColor whiteColor];
    [self makeUI];
}

- (void)makeUI{
    [self.view addSubview:self.resultTabelView];
    [self.resultTabelView registerNib:[UINib nibWithNibName:CINAMECELL232 bundle:nil] forCellReuseIdentifier:CINAMECELL232];
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    if (self.dataAry.count<1) {
        HUDLoadingShowView*view=[[NSBundle mainBundle]loadNibNamed:@"HUDLoadingShowView" owner:nil options:nil].firstObject;
        view.showLabel.text=@"抱歉没有数据。。";
        view.center = CGPointMake(kScreen_Width/2, kScreen_Height/3);
        [self.view addSubview:view];
        
        
        return;
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataAry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CinameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CINAMECELL232];
    cell.model = self.dataAry[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CinemaModel * model = self.dataAry[indexPath.section];
    MovieCinemaViewController * vc = [[MovieCinemaViewController alloc]init];
    vc.cinema_code = model.code;
    vc.film_code = model.film_code;
    vc.cityCode = model.city;
    if ([model.goodstype integerValue] != 1) {
        vc.status = 1;
    }else{
        vc.status = 0;
    }

    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableView*)resultTabelView{
    if (!_resultTabelView) {
        _resultTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _resultTabelView.delegate = self;
        _resultTabelView.dataSource = self;
        
    }
    return _resultTabelView;
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

@end
