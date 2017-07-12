//
//  YWPayMoneyViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPayMoneyViewController.h"
#import "PayMoneyTableViewCell.h"     //最上面的大cell
#import "PayMoney1TableViewCell.h"    //下面的小 cell

#define CELL0  @"PayMoneyTableViewCell"
#define CELL1  @"PayMoney1TableViewCell"

@interface YWPayMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIButton*sureButton;

@property(nonatomic,assign)BOOL current0;
@property(nonatomic,assign)BOOL current1;
@property(nonatomic,assign)BOOL current2;

@end

@implementation YWPayMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"支付订单";
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
    cell.selectionStyle=NO;
    
    if (indexPath.section==0&&indexPath.row==0) {
        //大的cell
        cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.selectionStyle=NO;
        
        UIImageView*imageView=[cell viewWithTag:1];
        imageView.image=[UIImage imageNamed:@"store.png"];
        
        UILabel*labelMoney=[cell viewWithTag:2];
        labelMoney.text=[NSString stringWithFormat:@"￥%.2f",_howMuchMoney];
        
        UILabel*labelShow=[cell viewWithTag:3];
        labelShow.text=self.whichPay;
        
        return cell;
    }else if (indexPath.section==0&&indexPath.row==1){
        //小的cell  账户余额
        UIImageView*imageView=[cell viewWithTag:1];
        imageView.image=[UIImage imageNamed:@"home_yue.png"];
        
        UILabel*labelMoney=[cell viewWithTag:2];
        labelMoney.text=[NSString stringWithFormat:@"账户余额：￥%@",[UserSession instance].money];
        
//        UIImageView*selectImage=[cell viewWithTag:3];
        
        
        return cell;
    }
    
    
    else if (indexPath.section==1&&indexPath.row==0){
        //微信支付
        
    }
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        return 80;
    }else{
        return 60;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 80;
    }
    return 0.001;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    }
    
    UIView*backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 80)];
    backgroundView.backgroundColor=[UIColor clearColor];
    
    self.sureButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 30, kScreen_Width-40, 50)];
    [self.sureButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(touchSureButton) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:self.sureButton];
    
    return backgroundView;
}


#pragma mark  --  touch
-(void)touchSureButton{
    
    
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    
    return _tableView;
}

@end
