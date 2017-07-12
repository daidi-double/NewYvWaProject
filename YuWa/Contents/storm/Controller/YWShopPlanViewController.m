//
//  YWShopPlanViewController.m
//  YuWa
//
//  Created by double on 17/6/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShopPlanViewController.h"
#import "ShopPlanFirstTableViewCell.h"
#import "ShopPlanHeaderView.h"
#import "ProducePhotoTableViewCell.h"
#import "SellerIntroductTableViewCell.h"
#import "ShopmodelTableViewCell.h"
#import "ShopPlanFourTableViewCell.h"
#import "FourTwoTableViewCell.h"
#import "MarketResearchTableViewCell.h"
#import "ProjectTableViewCell.h"
#import "SalesDetailViewController.h"//竞拍详情

#define PROJECTCELL @"ProjectTableViewCell"
#define RESEARCHCELL @"MarketResearchTableViewCell"
#define FOURTWOCELL @"FourTwoTableViewCell"
#define FOURCELL @"ShopPlanFourTableViewCell"
#define SHOPMODELCELL @"ShopmodelTableViewCell"
#define SELLERCELL  @"SellerIntroductTableViewCell"
#define PRODUCETABLEVIEWCELL @"ProducePhotoTableViewCell"
#define PLANCELL @"ShopPlanFirstTableViewCell"
#define IS_IPHONE5  ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )//判断是否为苹果5s
@interface YWShopPlanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *shopTableView;
@property (weak, nonatomic) IBOutlet UIButton *autionBtn;//竞拍按钮
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
//更多按钮
@property (weak, nonatomic) IBOutlet UILabel *cautionMoneyLabel;//保证金
@property (weak, nonatomic) IBOutlet UIButton *payBtn;//缴纳
@property (nonatomic,strong)NSArray * headerNameAry;
@property (nonatomic,strong)NSArray * headerImageViewAry;
@property (nonatomic,strong)ShopPlanHeaderView * headerView;

@end

@implementation YWShopPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self makeUI];
}

- (void)makeUI{
    self.title = @"商业计划书";
    self.headerNameAry = @[@"",@"产品快照",@"卖家介绍",@"商业模式",@"",@"",@"市场调研",@""];
    self.headerImageViewAry = @[@"",@"xiangji",@"seller",@"shopmodel",@"",@"",@"market",@""];
    self.cautionMoneyLabel.layer.borderColor = CNaviColor.CGColor;
    self.cautionMoneyLabel.layer.borderWidth = 0.3;
    [self.shopTableView registerNib:[UINib nibWithNibName:PLANCELL bundle:nil] forCellReuseIdentifier:PLANCELL];
    [self.shopTableView registerNib:[UINib nibWithNibName:SELLERCELL bundle:nil] forCellReuseIdentifier:SELLERCELL];
    [self.shopTableView registerNib:[UINib nibWithNibName:FOURCELL bundle:nil] forCellReuseIdentifier:FOURCELL];
    [self.shopTableView registerNib:[UINib nibWithNibName:FOURTWOCELL bundle:nil] forCellReuseIdentifier:FOURTWOCELL];
    [self.shopTableView registerNib:[UINib nibWithNibName:RESEARCHCELL bundle:nil] forCellReuseIdentifier:RESEARCHCELL];
    [self.shopTableView registerNib:[UINib nibWithNibName:PROJECTCELL bundle:nil] forCellReuseIdentifier:PROJECTCELL];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.shopTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (indexPath.section == 0) {
        ShopPlanFirstTableViewCell * planCell = [tableView dequeueReusableCellWithIdentifier:PLANCELL];

        planCell.selectionStyle = NO;
        return planCell;
        
    }else if (indexPath.section ==1){
        ProducePhotoTableViewCell * photoCell = [tableView dequeueReusableCellWithIdentifier:PRODUCETABLEVIEWCELL];
        if (!photoCell) {
            photoCell = [[ProducePhotoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PRODUCETABLEVIEWCELL];
        }
        photoCell.selectionStyle = NO;
        return photoCell;
    }else if (indexPath.section ==2){
        SellerIntroductTableViewCell * sellerCell = [tableView dequeueReusableCellWithIdentifier:SELLERCELL];

        sellerCell.selectionStyle = NO;
        return sellerCell;
    }else if (indexPath.section ==3){
        ShopmodelTableViewCell * modelCell = [tableView dequeueReusableCellWithIdentifier:SHOPMODELCELL];
        if (!modelCell) {
            modelCell = [[ShopmodelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SHOPMODELCELL];
        }
        modelCell.selectionStyle = NO;
        return modelCell;
    }else if (indexPath.section ==4){
        ShopPlanFourTableViewCell * fourCell = [tableView dequeueReusableCellWithIdentifier:FOURCELL];

        fourCell.layer.shouldRasterize = YES;
        fourCell.selectionStyle = NO;
        return fourCell;
    }else if (indexPath.section ==5){
        FourTwoTableViewCell * fourTCell = [tableView dequeueReusableCellWithIdentifier:FOURTWOCELL];

        fourTCell.layer.shouldRasterize = YES;
        fourTCell.selectionStyle = NO;
        return fourTCell;
    }else if (indexPath.section ==6){
        MarketResearchTableViewCell * researchTCell = [tableView dequeueReusableCellWithIdentifier:RESEARCHCELL];

        researchTCell.selectionStyle = NO;
        return researchTCell;
    }else{
        ProjectTableViewCell * projectCell = [tableView dequeueReusableCellWithIdentifier:PROJECTCELL];

        projectCell.selectionStyle = NO;
        return projectCell;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 ||section == 4 ||section == 5||section == 7) {
        return 0.001f;
    }
    return 45.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0 ||section == 4 ||section ==5||section == 7) {
            return nil;
    }
    _headerView =[[ShopPlanHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.headerNameLabel.text = self.headerNameAry[section];
    _headerView.headerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.headerImageViewAry[section]]];
    if (section == 6) {
        _headerView.lightView.backgroundColor = [UIColor clearColor];
    }
    
    return _headerView;

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (IS_IPHONE5) {
            
            return 489.f;
        }
        return kScreen_Height*990/1334;
    }else if (indexPath.section == 1){
        return kScreen_Height *272/1334;
    }else if (indexPath.section == 2){
        return kScreen_Height *412/1334;
    }else if (indexPath.section == 3){
        return kScreen_Height *714/1334;
    }else if (indexPath.section == 4){
        if (IS_IPHONE5) {
            
            return 475.f;
        }
        return kScreen_Height *1076/1334;
    }else if (indexPath.section == 5){
        if (IS_IPHONE5) {
            
            return 480.f;
        }
        return kScreen_Height *938/1334;
    }else if (indexPath.section == 6){
        return 400.f;//修改为动态高度
    }else if (indexPath.section == 7){
        return 360.f;//修改为动态高度
    }
    
    return 50.f;
}
//预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (IS_IPHONE5) {
            
            return 489.f;
        }
        return kScreen_Height*990/1334;
    }else if (indexPath.section == 1){
        return kScreen_Height *272/1334;
    }else if (indexPath.section == 2){
        return kScreen_Height *412/1334;
    }else if (indexPath.section == 3){
        return kScreen_Height *714/1334;
    }else if (indexPath.section == 4){
        if (IS_IPHONE5) {
            
            return 475.f;
        }
        return kScreen_Height *1076/1334;
    }else if (indexPath.section == 5){
        if (IS_IPHONE5) {
            
            return 480.f;
        }
        return kScreen_Height *938/1334;
    }else if (indexPath.section == 6){
        return 400.f;//修改为动态高度
    }else if (indexPath.section == 7){
        return 360.f;//修改为动态高度
    }
    
    return 50.f;

}
//缴纳
- (IBAction)toPayMoneyAction:(UIButton *)sender {
    SalesDetailViewController * salesVC = [[SalesDetailViewController alloc]init];
    [self.navigationController pushViewController:salesVC animated:YES];
}
//更多
- (IBAction)moreAction:(UIButton *)sender {
}
//竞拍
- (IBAction)autionAction:(UIButton *)sender {
}
//- (ShopPlanHeaderView*)headerView{
//    if (!_headerView) {
//        _headerView =[[ShopPlanHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
//        _headerView.backgroundColor = [UIColor whiteColor];
//        
//    }
//    return _headerView;
//}
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
