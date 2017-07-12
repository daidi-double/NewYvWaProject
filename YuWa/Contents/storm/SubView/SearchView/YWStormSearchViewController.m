//
//  YWStormSearchViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/26.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWStormSearchViewController.h"
#import "YWShoppingDetailViewController.h"

@interface YWStormSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *shopTextField;
@property (weak, nonatomic) IBOutlet UIView *shopTextSearchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * hotDataArr;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;

@property (nonatomic,strong)UIView * headerView;

@end

@implementation YWStormSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    [self makeUI];
    [self setupRefresh];
    [self dataSet];
    [self requestHotShopArrData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
}
- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.hotDataArr = [NSMutableArray arrayWithCapacity:0];
    self.pagens = @"15";
}

- (void)makeUI{
    self.shopTextSearchView.layer.cornerRadius = 5.f;
    self.shopTextSearchView.layer.masksToBounds = YES;
}

- (void)searchWithKey:(NSString *)searchKey{
    MyLog(@"%@",searchKey);
    NSString * searchID = self.hotDataArr[0]?self.hotDataArr[0][@"shopID"]:@"";
    for (int i = 0; i<self.dataArr.count; i++) {
        NSDictionary * dataDic = self.dataArr[i];
        if ([dataDic[@"name"] isEqualToString:searchKey]) {
            searchID = dataDic[@"shopID"];
            break;
        }
    }
    if ([searchID isEqualToString:@""])return;
    
    YWShoppingDetailViewController * vc = [[YWShoppingDetailViewController alloc]init];
        vc.shop_id = searchID;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchWithID:(NSString *)searchID{
    MyLog(@"%@",searchID);
    YWShoppingDetailViewController * vc = [[YWShoppingDetailViewController alloc]init];
        vc.shop_id = searchID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self.shopTextField.text isEqualToString:@""]?40.f:0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (![self.shopTextField.text isEqualToString:@""])return nil;
    if (!self.headerView) {
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 40.f)];
        self.headerView.backgroundColor = [UIColor colorWithHexString:@"#f5f8fa"];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15.f, 0.f, kScreen_Width - 30.f, 40.f)];
        label.text = @"热门搜索";
        label.font = [UIFont systemFontOfSize:15.f];
        label.textColor = CsubtitleColor;
        [self.headerView addSubview:label];
    }
    return self.headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.shopTextField.text isEqualToString:@""]) {
        [self searchWithID:self.hotDataArr[indexPath.row][@"shopID"]];
    }else{
        [self searchWithID:self.dataArr[indexPath.row][@"shopID"]];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.shopTextField.text isEqualToString:@""]?self.hotDataArr.count:self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * shopCell = [tableView dequeueReusableCellWithIdentifier:@"shopCell"];
    if (!shopCell){
        shopCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"shopCell"];
    }
    shopCell.selectionStyle = UITableViewCellSelectionStyleNone;
    shopCell.textLabel.textColor = CtitleColor;
    shopCell.textLabel.font = [UIFont systemFontOfSize:15.f];
    if (![shopCell viewWithTag:10086]) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15.f, 39.f, kScreen_Width - 30.f, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        lineView.tag = 10086;
        [shopCell addSubview:lineView];
    }
    if ([self.shopTextField.text isEqualToString:@""]) {
        shopCell.textLabel.text = self.hotDataArr[indexPath.row][@"name"];
    }else{
        shopCell.textLabel.text = self.dataArr[indexPath.row][@"name"];
    }
    return shopCell;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pages = 0;
        [self.tableView scrollsToTop];
        [self requestShopArrDataWithPages:0];
    });
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text isEqualToString:@""])return NO;
    [self searchWithKey:textField.text];
    return YES;
}

#pragma mark - TableView Refresh
- (void)setupRefresh{
    WEAKSELF;
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [weakSelf footerRereshing];
    }];
}
- (void)footerRereshing{
    self.pages++;
    [self requestShopArrDataWithPages:self.pages];
}

- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (isHeader) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Http
- (void)requestHotShopArrData{
    NSDictionary * pragram = @{};
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:NO];
    });
    
    [[HttpObject manager]getNoHudWithType:YuWaType_STORM_SEARCH_HOT withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSArray * dataArr = responsObj[@"data"];
        for (int i = 0; i < dataArr.count; i++) {
            NSDictionary * dataDic = dataArr[i];
            if (dataDic[@"title"]&&dataDic[@"url"]) {
                [self.hotDataArr addObject:@{@"name":dataDic[@"title"],@"shopID":dataDic[@"url"]}];
            }
        }
        
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}
- (void)requestShopArrDataWithPages:(NSInteger)page{
    NSDictionary * pragram = @{@"keyword":self.shopTextField.text,@"pagen":self.pagens,@"pages":[NSString stringWithFormat:@"%zi",page]};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_STORM_SEARCH withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if (page==0){
            [self.dataArr removeAllObjects];
        }
        NSArray * dataArr = responsObj[@"data"];
        for (int i = 0; i < dataArr.count; i++) {
            NSDictionary * dataDic = dataArr[i];
            if (dataDic[@"id"]&&dataDic[@"company_name"]) {
                [self.dataArr addObject:@{@"name":dataDic[@"company_name"],@"shopID":dataDic[@"id"]}];
            }
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        self.pages--;
    }];
}

@end
