//
//  PCGetMoneyViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PCGetMoneyViewController.h"

#import "GetMoneyTableViewCell.h"

#define CELL0   @"GetMoneyTableViewCell"

@interface PCGetMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;

@end

@implementation PCGetMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"提现申请";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"GetMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:CELL0];
    
    [self makeFooterView];
    
}
-(void)makeFooterView{
    UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
    bottomView.backgroundColor=[UIColor clearColor];
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, kScreen_Width-20, 18)];
    label.text=@"24小时内到账";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    [bottomView addSubview:label];
    
    UIButton *sureButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 50, kScreen_Width-40, 45)];
    sureButton.backgroundColor=CNaviColor;
    [sureButton setTitle:@"申请提现" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(touchGetMoney) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureButton];
    
    self.tableView.tableFooterView=bottomView;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    if (indexPath.row==0) {
        //
        UILabel*label=[cell viewWithTag:1];
        label.text=@"支付宝";
        UITextField*textField=[cell viewWithTag:2];
        textField.placeholder=@"请输入账号";
        
    }else if (indexPath.row==1){
        UILabel*label=[cell viewWithTag:1];
        label.text=@"提现金额";
        
        UITextField*textField=[cell viewWithTag:2];
        textField.placeholder=@"请输入金额";
        
        
    }
    
    
    
    if (indexPath.row==2) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            
        }
        
        cell.textLabel.text= [NSString stringWithFormat:@"当前账户余额：￥%.2f",self.money];
        cell.selectionStyle=NO;
        return cell;

        
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


#pragma mark  --touch
-(void)touchGetMoney{
    MyLog(@"提现");
    
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


//隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

@end
