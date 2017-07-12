//
//  UseCouponViewController.m
//  YuWa
//
//  Created by double on 17/5/4.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "UseCouponViewController.h"
#import "PCCouponTableViewCell.h"


#define COUPONCELL @"PCCouponTableViewCell"
@interface UseCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *useCouponTabeleView;
@property(nonatomic,strong)NSMutableArray*modelUnused;
@property (nonatomic,strong)NSMutableArray * imageAry;
@property (nonatomic,strong)NSMutableArray * colorAry;

@end

@implementation UseCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择优惠券";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getCouponData];
}
- (void)makeUI{
    [self.useCouponTabeleView registerNib:[UINib nibWithNibName:COUPONCELL bundle:nil] forCellReuseIdentifier:COUPONCELL];
    NSArray * youhuiquanAry = @[@"youhuiquan_03",@"youhuiquan_06",@"youhuiquan_08",@"youhuiquan_10"];
    NSArray * colorAry = @[RGBCOLOR(255, 193, 0, 1),RGBCOLOR(54, 192, 250, 1),RGBCOLOR(7, 225, 158, 1),RGBCOLOR(255, 94, 108, 1)];
    [self.imageAry addObjectsFromArray:youhuiquanAry];
    [self.colorAry addObjectsFromArray:colorAry];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelUnused.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCCouponTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:COUPONCELL];
    CouponModel * model = self.modelUnused[indexPath.section];
    UIImageView * youhuiquanImageView = [cell viewWithTag:1];
    UILabel * strLabel = [cell viewWithTag:2];
    UILabel*timeLabel=[cell viewWithTag:6];
    UILabel*dis_freeLabel=[cell viewWithTag:3];
    UILabel*min_freeLabel=[cell viewWithTag:4];
    UILabel*title=[cell viewWithTag:5];
    UIImageView * rightImageView = [cell viewWithTag:8];
    UIImageView * leftImageView = [cell viewWithTag:7];
    if (model.type == 1) {
        youhuiquanImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageAry[1]]];
        rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",self.imageAry[1]]];
        leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@2",self.imageAry[1]]];
        strLabel.textColor = self.colorAry[1];
        dis_freeLabel.textColor = self.colorAry[1];
        min_freeLabel.textColor = self.colorAry[1];
        
    }else if(model.type == 2) {
        youhuiquanImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageAry[0]]];
        rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",self.imageAry[0]]];
        leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@2",self.imageAry[0]]];
        strLabel.textColor = self.colorAry[0];
        dis_freeLabel.textColor = self.colorAry[0];
        min_freeLabel.textColor = self.colorAry[0];
    }else if(model.type == 3) {
        youhuiquanImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageAry[2]]];
        rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",self.imageAry[2]]];
        leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@2",self.imageAry[2]]];
        strLabel.textColor = self.colorAry[2];
        dis_freeLabel.textColor = self.colorAry[2];
        min_freeLabel.textColor = self.colorAry[2];
    }else{
        youhuiquanImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageAry[3]]];
        rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",self.imageAry[3]]];
        leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@2",self.imageAry[3]]];
        strLabel.textColor = self.colorAry[3];
        dis_freeLabel.textColor = self.colorAry[3];
        min_freeLabel.textColor = self.colorAry[3];
    }
    dis_freeLabel.text=[NSString stringWithFormat:@"￥%@",model.discount_fee];
    
    min_freeLabel.text=[NSString stringWithFormat:@"满%@减",model.min_fee];
    
    title.text=model.name;
    
    NSString*startTime=[JWTools getTime:model.begin_time];
    NSString*endTime=[JWTools getTime:model.end_time];
    timeLabel.text=[NSString stringWithFormat:@"%@至%@",startTime,endTime];
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        
        NSInteger number=indexPath.section;

        if ([self.delegate respondsToSelector:@selector(DelegateGetCouponInfo:)]) {
            [self.delegate DelegateGetCouponInfo:self.modelUnused[number]];
        }
        
        [self.navigationController popViewControllerAnimated:YES];

    return;
}

-(void)getCouponData{
    NSString*urlStr;
    NSDictionary*params;
    if (self.couponType == 1) {
       urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_PAY_CHECKCOUPON];
        params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"cinema_code":self.shop_id,@"total_money":self.total_money};
    }else{
       urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PERSON_CANUSECOUPON];
       params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"shop_id":self.shop_id,@"total_money":self.total_money};
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"能使用的优惠券%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            
            NSArray*unused=data[@"data"];
            for (NSDictionary*dict in unused) {
                CouponModel*model=[CouponModel yy_modelWithDictionary:dict];
                [self.modelUnused addObject:model];
            }
            
        }else{
            MyLog(@"参数 %@",params);
            [JRToast showWithText:@"网络异常，稍后再试" duration:1];
        }
        [self.useCouponTabeleView reloadData];
    }];
}


-(NSMutableArray *)modelUnused{
    if (!_modelUnused) {
        _modelUnused=[NSMutableArray array];
    }
    return _modelUnused;
}
- (NSMutableArray *)imageAry{
    if (!_imageAry) {
        _imageAry = [NSMutableArray array];
    }
    return _imageAry;
}

- (NSMutableArray*)colorAry{
    if (!_colorAry) {
        _colorAry = [NSMutableArray array];
    }
    return _colorAry;
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
