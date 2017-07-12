//
//  OtherTicketViewController.m
//  YuWa
//
//  Created by double on 17/5/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OtherTicketViewController.h"
#import "OtherTicketTableViewCell.h"
#import "OtherTicketPayViewController.h"
#import "OtherTicketModel.h"
#define otherTicketCell  @"OtherTicketTableViewCell"
@interface OtherTicketViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *otherTableView;
@property (nonatomic,strong)NSMutableArray * otherTicketAry;//通兑票数组
@property (nonatomic,strong)UIView * wawaView;

@end

@implementation OtherTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
}
-(void)makeUI{
    self.title = @"通兑票";
    [self creatWawaView];
    [self judgeIsContentOtherTicket];
    [self.otherTableView registerNib:[UINib nibWithNibName:otherTicketCell bundle:nil] forCellReuseIdentifier:otherTicketCell];
}
- (void)creatWawaView{
    
    _wawaView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height/2)];
    _wawaView.hidden = YES;
    [self.view addSubview:_wawaView];
    UIImageView * wawaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width/2, 100, kScreen_Width/3, kScreen_Width/3+20)];
    wawaImageView.centerX = kScreen_Width/2;
    wawaImageView.image = [UIImage imageNamed:@"娃娃"];
    [_wawaView addSubview:wawaImageView];
    
    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, wawaImageView.bottom, kScreen_Width, 40)];
    textLabel.centerX = kScreen_Width/2;
    textLabel.textAlignment = 1;
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = RGBCOLOR(123, 124, 124, 1);
    textLabel.text = @"来晚了，该影院已经没有通兑票了哦~";
    [_wawaView addSubview:textLabel];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.otherTicketAry.count<=0) {
        self.wawaView.hidden = NO;
    }else{
        self.wawaView.hidden = YES;
    }
    return self.otherTicketAry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherTicketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:otherTicketCell];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = self.otherTableView.backgroundColor;
    OtherTicketModel * model = self.otherTicketAry[indexPath.section];
    cell.model = model;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OtherTicketModel * model = self.otherTicketAry[indexPath.section];
    OtherTicketPayViewController * vc = [[OtherTicketPayViewController alloc]init];
    vc.cinemaCode = self.cinema_code;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
//获取通兑票
- (void)judgeIsContentOtherTicket{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_JUDGECONTENTOTHERTICKET];
    NSDictionary * pragrams = @{@"cityNo":self.cityCode,@"cinemaNo":self.cinema_code};
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"通兑票 %@",data);
        [self.otherTicketAry removeAllObjects];
        if ([data[@"errorCode"] integerValue] == 0) {
            for (NSDictionary * dict in data[@"data"]) {
                OtherTicketModel * model = [OtherTicketModel yy_modelWithDictionary:dict];
                [self.otherTicketAry addObject:model];
                
            }
            [self.otherTableView reloadData];
        }
        }];
    
}
- (NSMutableArray*)otherTicketAry{
    if (!_otherTicketAry) {
        _otherTicketAry = [NSMutableArray array];
    }
    return _otherTicketAry;
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
