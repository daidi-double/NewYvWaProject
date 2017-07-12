//
//  BeginSalesViewController.m
//  YuWa
//
//  Created by double on 17/7/4.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "BeginSalesViewController.h"
#import "SalesShopTableViewCell.h"
#import "SalesPriceCollectionViewCell.h"

#define SALEPRICECELL @"SalesPriceCollectionViewCell"
#define SALESSHOPCELL @"SalesShopTableViewCell"
@interface BeginSalesViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *salesTableView;
@property (nonatomic,strong)UICollectionView * priceCollectionView;
@end

@implementation BeginSalesViewController
//-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开始竞拍";
    [self makeUI];
    
}
- (void)makeUI{
    [self.salesTableView registerNib:[UINib nibWithNibName:SALESSHOPCELL bundle:nil] forCellReuseIdentifier:SALESSHOPCELL];
    self.salesTableView.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.itemSize = CGSizeMake((self.delegateBGView.width - 54)/3, 36);
    self.priceCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(25, self.line.bottom+31, self.delegateBGView.width - 50, 72) collectionViewLayout:layout];
    _priceCollectionView.centerX = self.delegateBGView.width/2;
    _priceCollectionView.delegate = self;
    _priceCollectionView.dataSource = self;
    [self.delegateBGView addSubview:_priceCollectionView];
    _priceCollectionView.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    _priceCollectionView.layer.borderWidth = 0.3f;
    _priceCollectionView.backgroundColor = [UIColor whiteColor];
    [_priceCollectionView registerNib:[UINib nibWithNibName:SALEPRICECELL bundle:nil] forCellWithReuseIdentifier:SALEPRICECELL];
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SalesPriceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SALEPRICECELL forIndexPath:indexPath];
    cell.layer.borderColor = RGBCOLOR(234, 235, 236, 1).CGColor;
    cell.layer.borderWidth = 0.3f;
    NSArray * titleAry = @[@"起拍价",@"加价幅度",@"买家佣金"];
    if (indexPath.item<3) {
        cell.backgroundColor = [UIColor colorWithHexString:@"#edecec"];
        cell.contentLabel.text = titleAry[indexPath.item];
        
    }else{
        cell.contentLabel.font = [UIFont systemFontOfSize:13];
        cell.contentLabel.text = @"1000";
    }
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 3;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SalesShopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SALESSHOPCELL];
        cell.selectionStyle = NO;
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"beginCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"beginCell"];
            
        }
        cell.selectionStyle = NO;
        cell.textLabel.textColor = LightColor;
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"Coconut商务股权";
            cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium"size:16];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"24小时无间断提供甜品，帮助泉州30万甜品爱好者解决吃不到正宗烘焙甜品的难题；让消费者随时保持年轻的心态";
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:13];
        }else{
            cell.textLabel.text = @"当前价:￥6800";
            cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium"size:25];
        }
        
        
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        
        UIView * lightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
        lightView.backgroundColor = RGBCOLOR(234, 235, 236, 1);
        return lightView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            
            return [self getCellHeightStr:@"24小时无间断提供甜品，帮助泉州30万甜品爱好者解决吃不到正宗烘焙甜品的难题；让消费者随时保持年轻的心态" contentOfFont:13];
        }else if (indexPath.row == 2){
            return 60.f;
        }else{
            return 44.f;
        }
    }else{
        
        if (IS_IPHONE_5) {
            
            return 240.f;
        }
        return kScreen_Height*454/1334;
        
    }
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
