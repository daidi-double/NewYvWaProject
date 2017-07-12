//
//  YWShopDetailViewController.m
//  YuWa
//
//  Created by double on 17/4/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShopDetailViewController.h"
#import "YWShopDetailTableViewCell.h"
#import "YWActivityTableViewCell.h"//优惠活动
#import "StoreDescriptionTableViewCell.h"//商家详情
#import "ShopdetailModel.h"
#import "YWShopTimeTableViewCell.h"//营业时间

#define TIMECELL    @"YWShopTimeTableViewCell"
#define DetailCell  @"YWShopDetailTableViewCell"
#define ActivityCell     @"YWActivityTableViewCell"
#define CELL4   @"StoreDescriptionTableViewCell"
@interface YWShopDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *shopDetailTableView;
@property(nonatomic,strong)ShopdetailModel*mainModel;
@end

@implementation YWShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺详情";
    [self.shopDetailTableView registerNib:[UINib nibWithNibName:DetailCell bundle:nil] forCellReuseIdentifier:DetailCell];
    [self.shopDetailTableView registerNib:[UINib nibWithNibName:ActivityCell bundle:nil] forCellReuseIdentifier:ActivityCell];
    self.shopDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDatas];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 88;
    }else if (indexPath.section == 1){
        NSMutableArray*mtArray=[self.mainModel.holiday mutableCopy];
        return [YWActivityTableViewCell getCellHeight:mtArray];
    }else if (indexPath.section == 2){
        NSMutableArray*mtArray=[self.mainModel.infrastructure mutableCopy];
        return [StoreDescriptionTableViewCell getHeight:mtArray];
        
    }else{
        NSMutableArray * mtArray = [self.mainModel.business_hours mutableCopy];
        MyLog(@"高度%f,%ld",[YWShopTimeTableViewCell getHeight:mtArray],mtArray.count);
        return [YWShopTimeTableViewCell getHeight:mtArray];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5.f;
    }
    return 0.001f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YWShopDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DetailCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.mainModel;
        return cell;
    }else if (indexPath.section == 1){
        YWActivityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ActivityCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel * zheLabel = [cell viewWithTag:10];
        NSString*zheNum=[self.mainModel.discount substringFromIndex:2];
        if ([zheNum integerValue] % 10 == 0) {
            zheNum = [NSString stringWithFormat:@"%ld",[zheNum integerValue]/10];
        }else{
            zheNum = [NSString stringWithFormat:@"%.1f",[zheNum floatValue]/10];
        }
        zheLabel.text=[NSString stringWithFormat:@"%@折，闪付立享",zheNum];
        
        CGFloat num=[self.mainModel.discount floatValue];
        if (num>=1 || num == 0.00) {
            zheLabel.text=@"不打折";
        }

        cell.holidayArray = self.mainModel.holiday;
        return cell;
    }else if (indexPath.section == 2){
        StoreDescriptionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL4];
        if (!cell) {
            cell=[[StoreDescriptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL4 ];
        }
        cell.selectionStyle=NO;
        cell.allDatas=self.mainModel.infrastructure;
        
        return cell;
    }else{
        YWShopTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TIMECELL];
        if (!cell) {
            cell = [[YWShopTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TIMECELL];
        }
        cell.selectionStyle = NO;
        cell.times = self.mainModel.business_hours;
        return cell;
    }
}
- (void)getDatas{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SHOP_SHOPINFO];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"shop_id":self.shop_id};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"店铺详情data = %@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            self.mainModel = [ShopdetailModel yy_modelWithDictionary:data[@"data"][@"detail"]];
            
        }
        [self.shopDetailTableView reloadData];
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
