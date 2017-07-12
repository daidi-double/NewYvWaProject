//
//  ShopDetaliViewController.m
//  YuWa
//
//  Created by double on 17/2/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ShopDetaliViewController.h"
#import "MovieCinemaViewController.h"
#import "YWLoginViewController.h"
@interface ShopDetaliViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * shopTableView;
@property (nonatomic,strong)NSMutableArray * cellDataArr;//存放有效期等标题
@property (nonatomic,strong)NSMutableArray * cellOtherDataArr;
@end

@implementation ShopDetaliViewController
- (NSMutableArray*)cellDataArr{
    if (!_cellDataArr) {
        _cellDataArr = [NSMutableArray array];
    }
    return _cellDataArr;
}
- (NSMutableArray*)cellOtherDataArr{
    if (!_cellOtherDataArr) {
        _cellOtherDataArr = [NSMutableArray array];
    }
    return _cellOtherDataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray * cellAry = @[@"有效期",@"使用时间",@"预约提醒",@"其他"];
    NSArray * cellOtherAry = @[@"2017.01.10至",@"24小时可用",@"无需预约",@"不可同享其他优惠"];
    [self.cellDataArr addObjectsFromArray:cellAry];
    [self.cellOtherDataArr addObjectsFromArray:cellOtherAry];
    [self makeUI];
    
    // Do any additional setup after loading the view.
}
- (void)makeUI
{
    _shopTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
    _shopTableView.delegate = self;
    _shopTableView.dataSource = self;
   
    [self.view addSubview:_shopTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section != 2) {
        return 2;
    }else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kScreen_Height * 0.3f;
    }else{
        return 2.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3 && indexPath.row == 1) {
        MovieCinemaViewController * movieVC = [[MovieCinemaViewController alloc]init];
        [self.navigationController pushViewController:movieVC animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"shopCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"￥16";
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            UILabel * subtitle = [[UILabel alloc]initWithFrame:CGRectMake(cell.width * 0.2f, cell.height/4, cell.width/3, cell.height/2)];
            subtitle.text = @"影院价:￥21";
            subtitle.font = [UIFont systemFontOfSize:12];
            subtitle.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:subtitle];
            
            UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            buyBtn.frame = CGRectMake(cell.width * 0.65f, 5, cell.width/3, cell.height-10);
            buyBtn.backgroundColor = CNaviColor;
            buyBtn.layer.masksToBounds = YES;
            buyBtn.layer.cornerRadius = 5;
            [buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
            [buyBtn addTarget:self action:@selector(buyshop) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:buyBtn];
            
        }else{
            NSArray * imageAry = @[@"随时退",@"过期退"];
            for (int i = 0; i<2; i++) {
                UIImageView * quitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15 + (cell.width/4 + 10)*i, cell.height * 0.2f, kScreen_Width/5, cell.height * 0.6f)];
                quitImageView.image = [UIImage imageNamed:imageAry[i]];
                [cell.contentView addSubview:quitImageView];
            }
 
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"套餐详情";
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.center = CGPointMake(cell.width * 0.2f, cell.height/2);
            
        }else{
            UILabel * detali = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
            detali.textColor = [UIColor blackColor];
            detali.numberOfLines = 0;
            detali.font = [UIFont systemFontOfSize:14];
            detali.text = @"   爆米花        1份       ￥60";
            [cell.contentView addSubview:detali];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"购买须知";
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.center = CGPointMake(cell.width * 0.2f, cell.height/2);
        }else{

            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
            cell.textLabel.text = _cellDataArr[indexPath.row - 1];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.text = _cellDataArr[indexPath.row - 1];
        }
    }else{
        if (indexPath.section == 3) {
        
          if (indexPath.row == 0) {
            cell.textLabel.text = @"影院信息";
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.center = CGPointMake(cell.width * 0.2f, cell.height/2);
          }else{
              cell.textLabel.text = @"万达";
              cell.textLabel.textColor = [UIColor grayColor];
              cell.detailTextLabel.textColor = [UIColor lightGrayColor];
              cell.detailTextLabel.text = @"梅岭街道";
              
              UIButton * iphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
              iphoneBtn.frame = CGRectMake(cell.width*0.8f, 5, cell.width*0.2f, cell.height-10);
              iphoneBtn.backgroundColor = [UIColor clearColor];
              [iphoneBtn setImage:[UIImage imageNamed:@"dianhua.png"] forState:UIControlStateNormal];
              [iphoneBtn addTarget:self action:@selector(iphoneNum) forControlEvents:UIControlEventTouchUpInside];
              [cell.contentView addSubview:iphoneBtn];

          }
        }
    }

    return cell;
}
- (void)iphoneNum{
    MyLog(@"拨打电话");
    NSString *allString = [NSString stringWithFormat:@"tel:17759725085"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
    
}
- (void)buyshop{
    MyLog(@"立即购买");
    if ([self judgeLogin]) {
        
    }
}

- (BOOL)judgeLogin{
    if (![UserSession instance].isLogin) {
        YWLoginViewController * vc = [[YWLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    return [UserSession instance].isLogin;
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
