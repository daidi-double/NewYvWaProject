//
//  CouponViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CouponViewController.h"

#import "YJSegmentedControl.h"
#import "PCCouponTableViewCell.h"    //cell

#import "JWTools.h"



#define CELL0    @"PCCouponTableViewCell"

@interface CouponViewController ()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,assign)NSUInteger whichCategory; //0 1 2  可用 已使用 已过期

@property (nonatomic,strong)UIView * wawaView;

@property(nonatomic,strong)NSMutableArray*modelUsed;
@property(nonatomic,strong)NSMutableArray*modelUnused;
@property(nonatomic,strong)NSMutableArray*modelOvertime;
@property (nonatomic,strong)NSMutableArray * imageAry;
@property (nonatomic,strong)NSMutableArray * colorAry;


@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=@"优惠券";
    [self getDatas];
    
    [self makeTopView];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self creatWawaView];
    NSArray * youhuiquanAry = @[@"youhuiquan_03",@"youhuiquan_06",@"youhuiquan_08",@"youhuiquan_10"];
    NSArray * colorAry = @[RGBCOLOR(255, 193, 0, 1),RGBCOLOR(54, 192, 250, 1),RGBCOLOR(7, 225, 158, 1),RGBCOLOR(255, 94, 108, 1)];
    [self.imageAry addObjectsFromArray:youhuiquanAry];
    [self.colorAry addObjectsFromArray:colorAry];
}

-(void)makeTopView{
    NSArray*array=@[@"可用",@"已使用",@"已过期"];
   UIView*view= [YJSegmentedControl segmentedControlFrame:CGRectMake(0, 64, kScreen_Width, 44) titleDataSource:array backgroundColor:[UIColor whiteColor] titleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:14] selectColor:CNaviColor buttonDownColor:CNaviColor Delegate:self];
    [self.view addSubview:view];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (self.whichCategory) {
        case 0:
            if (self.modelUnused.count <=0) {
                self.wawaView.hidden = NO;
            }else{
                self.wawaView.hidden = YES;
            }
            return self.modelUnused.count;
            
            break;
        case 1:
            if (self.modelUsed.count <=0) {
                self.wawaView.hidden = NO;
            }else{
                self.wawaView.hidden = YES;
            }
            return self.modelUsed.count;
            break;
        case 2:
            if (self.modelOvertime.count <=0) {
                self.wawaView.hidden = NO;
            }else{
                self.wawaView.hidden = YES;
            }
            return self.modelOvertime.count;
            break;
   
        default:
            break;
    }
    return self.modelUsed.count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCCouponTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    NSMutableArray*mtArray=[NSMutableArray array];
    switch (self.whichCategory) {
        case 0:
            mtArray=self.modelUnused;
            break;
        case 1:
            mtArray=self.modelUsed;

            break;
        case 2:
            mtArray=self.modelOvertime;

            break;
            
        default:
            break;
    }
//    UIView*leftView=[cell viewWithTag:1];
//    leftView.backgroundColor=[UIColor greenColor];
//    
//    UIView*rightView=[cell viewWithTag:2];
//    rightView.backgroundColor=[UIColor blueColor];
    
    
    //3 4 5 6
    CouponModel*model=mtArray[indexPath.section];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.whichCategory==0) {
        
        if (!self.shopID||!self.totailPayMoney) {
            return;
        }
        
        NSInteger number=indexPath.section;
        CouponModel*model=self.modelUnused[number];
        
        CGFloat min_free=[model.min_fee floatValue];
        if (min_free>self.totailPayMoney) {
            [JRToast showWithText:@"不满足最低消费金额，不能使用该优惠券"];
            return;
        }
        if ([model.shop_id isEqualToString:self.shopID]||[model.shop_id isEqualToString:@"0"])  {
            
        }else{
            [JRToast showWithText:@"该店铺不能使用这张优惠券"];
            return;
        }
        
            if ([self.delegate respondsToSelector:@selector(DelegateGetCouponInfoOld:)]) {
                [self.delegate DelegateGetCouponInfoOld:self.modelUnused[number]];
            }
            
            [self.navigationController popViewControllerAnimated:YES];

        
        
        
    }
    return;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)creatWawaView{
    
        _wawaView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, kScreen_Width, kScreen_Height/2)];
        _wawaView.hidden = YES;
        [self.view addSubview:_wawaView];
        UIImageView * wawaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width/2, 130, kScreen_Width/3, kScreen_Width/3)];
        wawaImageView.centerX = kScreen_Width/2;
        wawaImageView.image = [UIImage imageNamed:@"娃娃"];
        [_wawaView addSubview:wawaImageView];
        
        UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, wawaImageView.bottom, kScreen_Width/2, 40)];
        textLabel.centerX = kScreen_Width/2;
        textLabel.textAlignment = 1;
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textColor = RGBCOLOR(123, 124, 124, 1);
        textLabel.text = @"暂无优惠券哦~";
        [_wawaView addSubview:textLabel];
    
}
#pragma mark  --Datas
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PERSON_COUPON];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            
            //成功  给三个model 数组赋值
            NSArray*unused=data[@"data"][@"unused"];

            for (NSDictionary*dict in unused) {
                CouponModel*model=[CouponModel yy_modelWithDictionary:dict];
                [self.modelUnused addObject:model];
            }
            
            
            NSArray*used=data[@"data"][@"used"];
            for (NSDictionary*dict in used) {
              CouponModel*model=[CouponModel yy_modelWithDictionary:dict];
                [self.modelUsed addObject:model];
            }
            
         
            
            NSArray*overtime=data[@"data"][@"overtime"];
            for (NSDictionary*dict in overtime) {
                CouponModel*model=[CouponModel yy_modelWithDictionary:dict];
                [self.modelOvertime addObject:model];
            }
            
            [self.tableView reloadData];
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
}

#pragma mark  --delegate
-(void)segumentSelectionChange:(NSInteger)selection{
    self.whichCategory=selection;
    [self.tableView reloadData];
    MyLog(@"%lu",selection);
    
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

#pragma mark  -- set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+44, kScreen_Width, kScreen_Height-64-44) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSMutableArray *)modelUsed{
    if (!_modelUsed) {
        _modelUsed=[NSMutableArray array];
    }
    return _modelUsed;
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
-(NSMutableArray *)modelUnused{
    if (!_modelUnused) {
        _modelUnused=[NSMutableArray array];
    }
    return _modelUnused;
}

-(NSMutableArray *)modelOvertime{
    if (!_modelOvertime) {
        _modelOvertime=[NSMutableArray array];
    }
    return _modelOvertime;
}

@end
