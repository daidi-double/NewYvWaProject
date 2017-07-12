//
//  FoodViewController.m
//  YuWa
//
//  Created by double on 17/2/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "FoodViewController.h"
#import "SeeMovieCell.h"
#import "ShopDetaliViewController.h"
#import "PayViewController.h"

@interface FoodViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * foodTableView;

@end

@implementation FoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"观影套餐";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeTableView];
    // Do any additional setup after loading the view.
}
- (void)makeTableView{
    _foodTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
    _foodTableView.delegate = self;
    _foodTableView.dataSource = self;
    [self.view addSubview:_foodTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        return 60.f;
    }
    return 20.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopDetaliViewController * shopVC = [[ShopDetaliViewController alloc]init];
    [self.navigationController pushViewController:shopVC animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"foodCell"];
    }
    if (indexPath.row == 0) {
    cell.textLabel.text = @"观影套餐";
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }else{
    SeeMovieCell * cell = [[SeeMovieCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SeeMovieCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
     }
    return cell;
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
