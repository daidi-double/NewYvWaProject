//
//  YWMessageNotificationViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageNotificationViewController.h"
#import "YWPayNotificationTableView.h"
#import "NSDictionary+Attributes.h"

#import "YWMessageNotificationCell.h"
#import "YWdetailViewController.h"
#import "OrderDetailViewController.h"
#import "YWdetailModel.h"

#define MESSAGENOTICELL @"YWMessageNotificationCell"
@interface YWMessageNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
//表示预约通知
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//付款通知
@property (nonatomic,strong)YWPayNotificationTableView * payTableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,strong)UIView * wawaView;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)UISegmentedControl * segmentedControl;
@property (nonatomic, strong) NSMutableArray *detailArray;

@end

@implementation YWMessageNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeUI];
    [self dataSet];
    [self creatWawaView];
    [self setupRefresh];
    [self headerRereshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didselectCell:) name:@"push" object:nil];
}
-(void)didselectCell:(NSNotification*)user{
    NSDictionary * dic =  user.userInfo;
    OrderDetailViewController * orderVC =[[UIStoryboard storyboardWithName:@"OrderDetailViewController" bundle:nil] instantiateInitialViewController];
        orderVC.order_id = dic[@"order_id"];
        [self.navigationController pushViewController:orderVC animated:YES];
}
- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:MESSAGENOTICELL bundle:nil] forCellReuseIdentifier:MESSAGENOTICELL];
}

- (void)makeUI{
    self.pagens = @"15";
    self.tableView.alwaysBounceVertical = YES;
    
    self.payTableView = [[YWPayNotificationTableView alloc]initWithFrame:CGRectMake(0.f, 64.f, kScreen_Width, kScreen_Height - 64.f) style:UITableViewStylePlain];
    self.payTableView.pagens = self.pagens;
    [self.payTableView dataSet];
    [self.view addSubview:self.payTableView];
}
- (void)makeNavi{
    self.segmentedControl = [self makeSegmentedControl];
    self.navigationItem.titleView = self.segmentedControl;
}
- (void)creatWawaView{
    
    _wawaView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height/2)];
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
    textLabel.text = @"暂无预约通知哦~";
    [_wawaView addSubview:textLabel];
    
}

- (UISegmentedControl *)makeSegmentedControl{
    UISegmentedControl * segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"预约通知",@"付款通知"]];
    segmentControl.frame = CGRectMake(0.f, 0.f, ACTUAL_WIDTH(180.f), 30.f);
    segmentControl.tintColor = [UIColor whiteColor];
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.layer.cornerRadius = 5.f;
    segmentControl.layer.masksToBounds = YES;
    segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
    segmentControl.layer.borderWidth = 2.f;
    [segmentControl setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    return segmentControl;
}

#pragma mark - Control Action
- (void)segmentControlAction:(UISegmentedControl *)sender{
    self.status = sender.selectedSegmentIndex;
    self.payTableView.hidden = sender.selectedSegmentIndex == 0?YES:NO;
    self.wawaView.hidden = sender.selectedSegmentIndex == 1?YES:NO;
    self.payTableView.wawaView.hidden = sender.selectedSegmentIndex == 0?YES:NO;
    if (sender.selectedSegmentIndex == 0) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self.payTableView.mj_header beginRefreshing];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArr.count <= 0) {
        self.wawaView.hidden = NO;
    }else{
        self.wawaView.hidden = YES;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWMessageNotificationCell * messageCell = [tableView dequeueReusableCellWithIdentifier:MESSAGENOTICELL];
    messageCell.model = self.dataArr[indexPath.row];
    return messageCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * SB = [UIStoryboard storyboardWithName:@"detail" bundle:nil];
    YWdetailViewController * vc = [SB instantiateInitialViewController];
    YWMessageNotificationModel * model = self.dataArr[indexPath.row];
    vc.status = [model.status integerValue];
    vc.model = self.detailArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.tableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
    }];
}
- (void)footerRereshing{

    self.pages++;
    [self requestShopArrDataWithPages:self.pages];
}
- (void)headerRereshing{
    if (_detailArray == nil) {
        [self getDatasWithIDD:nil];
    }
    self.pages = 0;
    [self requestShopArrDataWithPages:0];
}

- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (isHeader) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

-(void)getDatasWithIDD:(NSString*)idd{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_NOTCCAFICATIONJ_ORDER];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
//        // NSData转为NSString
//        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //        MyLog(@"Regieter Code pragram is %@",data);
        MyLog(@"通知 Regieter Code is %@",data);
        NSArray * dataArr = data[@"data"];
        if (self.detailArray.count == 0) {
            for (int i = 0; i<dataArr.count; i++) {
                NSDictionary * dic = dataArr[i];
//                NSDictionary * dic1 = dic[@"details"];
//                NSString * str = dic1[@"seller_message"];
                 YWdetailModel * model = [YWdetailModel yy_modelWithDictionary:dic[@"details"]];
                
                [self.detailArray addObject:model];
            }
        }
    }];
}

#pragma mark - Http
- (void)requestShopArrDataWithPages:(NSInteger)page{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":self.pagens,@"pages":[NSString stringWithFormat:@"%zi",page]};
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
    });
    
    [[HttpObject manager]postNoHudWithType:YuWaType_NOTCCAFICATIONJ_ORDER withPragram:pragram success:^(id responsObj) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responsObj options:NSJSONWritingPrettyPrinted error:nil];
            // NSData转为NSString
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",jsonStr);
        if (page==0){
            [self.dataArr removeAllObjects];
        }
        NSArray * dataArr = responsObj[@"data"];
        if (dataArr.count>0) {
            for (int i = 0; i<dataArr.count; i++) {
                YWMessageNotificationModel * model = [YWMessageNotificationModel yy_modelWithDictionary:dataArr[i]];

                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}
-(NSMutableArray *)detailArray{
    if (_detailArray  == nil) {
        _detailArray = [NSMutableArray array];
    }
    return _detailArray;
}

@end
