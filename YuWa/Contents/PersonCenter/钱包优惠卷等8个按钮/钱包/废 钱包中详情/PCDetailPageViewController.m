//
//  PCDetailPageViewController.m
//  YuWa
//
//  Created by double on 17/4/2.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PCDetailPageViewController.h"
#import "PCOrderDetailModel.h"
@interface PCDetailPageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *orderDetailTableView;
@property (nonatomic,strong)NSArray * titleAry;
@property (nonatomic,strong)NSMutableArray * dataAry;
@end

@implementation PCDetailPageViewController
- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收支详情";
    [self requestData];
    self.titleAry = @[@"账号订单:",@"类型:",@"收入:",@"收入方式:",@"时间:",@"交易状态:",@"余额:",@"备注:"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DetailCell"];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (self.dataAry.count > 0) {
        cell.detailTextLabel.text = self.dataAry[indexPath.row];
        if (indexPath.row == 4) {
            cell.detailTextLabel.text = [JWTools getTime:self.dataAry[indexPath.row]];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleAry[indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = RGBCOLOR(170, 170, 170, 1);
    }
    if (self.dataAry.count > 0) {
        if (indexPath.row == 2) {
            
        if ([self.dataAry[1] containsString:@"支出"]) {
            cell.textLabel.text = @"支出:";
        }
        }
    }
    cell.detailTextLabel.textColor = RGBCOLOR(120, 120, 121, 1);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

-(void)requestData{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETPAYDETAILPAGE];

    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"id":self.orderId};
    
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"data00 = %@",data[@"data"]);
        NSInteger errorCode = [data[@"errorCode"] integerValue];
        if (errorCode == 0) {
        PCOrderDetailModel * model = [PCOrderDetailModel yy_modelWithDictionary:data[@"data"]];
        [self.dataAry removeAllObjects];
        NSString * order_sn = model.order_sn;
        NSString * type = model.type;
        NSString * money = model.money;
        NSString * nickname;
            if (model.nickname.length >=11) {
                NSString * name = [model.nickname substringToIndex:7];
                nickname = [NSString stringWithFormat:@"%@****",name];
            }else{
                nickname = model.nickname;
            }
        NSString * ctime = model.ctime;
        NSString * account_status = model.account_status;//交易状态
        NSString * balance = model.balance;
            if (model.order_sn == nil) {
                order_sn = @"";
            }
        [self.dataAry addObject:order_sn];
        [self.dataAry addObject:type];
        if ([type containsString:@"积分"]) {
            CGFloat level;
            switch ([UserSession instance].baobaoLV) {
                case 1:
                   level  = 20.0 * [model.score floatValue];
                   money = [NSString stringWithFormat:@"%.4f",level];
                    break;
                case 2:
                    level  = 22.0 * [model.score floatValue];
                      money = [NSString stringWithFormat:@"%.4f",level];
                    break;
                case 3:
                    level  = 25.0 * [model.score floatValue];
                      money = [NSString stringWithFormat:@"%.4f",level];
                    break;
                case 4:
                    level  = 30.0 * [model.score floatValue];
                      money = [NSString stringWithFormat:@"%.4f",level];
                    break;
                case 5:
                    level  = 40.0 * [model.score floatValue];
                      money = [NSString stringWithFormat:@"%.4f",level];
                    break;
                case 6:
                    level  = 60.0 * [model.score floatValue];
                      money = [NSString stringWithFormat:@"%.4f",level];
                    break;
                default:
                    break;
            }
        
            }
        [self.dataAry addObject:money];
        [self.dataAry addObject:nickname];
        [self.dataAry addObject:ctime];
        [self.dataAry addObject:account_status];
        [self.dataAry addObject:balance];
        [self.dataAry addObject:type];

            
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
        [self.orderDetailTableView reloadData];
//        NSString * pay_to_shop_time = model.pay_to_shop_time;

        


        
    }];
    
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
