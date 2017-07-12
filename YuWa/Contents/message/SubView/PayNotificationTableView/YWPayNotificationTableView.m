//
//  YWPayNotificationTableView.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPayNotificationTableView.h"
#import "UIScrollView+JWGifRefresh.h"
#import "HttpObject.h"
#import "JWTools.h"
#import "YWdetailViewController.h"

#import "YWMessageNotificationCell.h"
#import "YWpayNotificationCell.h"
#import "OrderDetailViewController.h"

#define payNotificationCell @"YWpayNotificationCell"
@implementation YWPayNotificationTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.hidden = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self registerNib:[UINib nibWithNibName:payNotificationCell bundle:nil] forCellReuseIdentifier:payNotificationCell];
    self.dataSource = self;
    self.delegate = self;
    [self setupRefresh];
    [self creatWawaView];
    [self headerRereshing];
}

- (void)creatWawaView{
    
    _wawaView = [[UIView alloc]initWithFrame:CGRectMake(0, 32, kScreen_Width, kScreen_Height/2)];
    _wawaView.hidden = YES;
    [self addSubview:_wawaView];
    UIImageView * wawaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width/2, 100, kScreen_Width/3, kScreen_Width/3)];
    wawaImageView.centerX = kScreen_Width/2;
    wawaImageView.image = [UIImage imageNamed:@"娃娃"];
    [_wawaView addSubview:wawaImageView];
    
    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, wawaImageView.bottom, kScreen_Width/2, 40)];
    textLabel.centerX = kScreen_Width/2;
    textLabel.textAlignment = 1;
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = RGBCOLOR(123, 124, 124, 1);
    textLabel.text = @"暂无付款通知哦~";
    [_wawaView addSubview:textLabel];
    
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
    YWpayNotificationCell   * messageCell = [tableView dequeueReusableCellWithIdentifier:payNotificationCell];
    messageCell.model = self.dataArr[indexPath.row];
   
    return messageCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    OrderModel * model = self.maAllDatasModel[indexPath.row];
//    OrderDetailViewController * orderVC =[[OrderDetailViewController alloc]init];
//    orderVC.order_id = model.order_id;
//    [self.navigationController pushViewController:orderVC animated:YES];
      YWMessageNotificationModel* model  = self.dataArr[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil userInfo:@{@"order_id":model.order_id}];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
    self.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
    }];
}
- (void)footerRereshing{
    self.pages++;
    [self requestShopArrDataWithPages:self.pages];
}
- (void)headerRereshing{
    self.pages = 0;
    [self requestShopArrDataWithPages:0];
}
- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (isHeader) {
        [self.mj_header endRefreshing];
    }else{
        [self.mj_footer endRefreshing];
    }
}

#pragma mark - Http
- (void)requestShopArrDataWithPages:(NSInteger)page{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":self.pagens,@"pages":[NSString stringWithFormat:@"%zi",page]};
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
    });
    
    [[HttpObject manager]postNoHudWithType:YuWaType_NOTCCAFICATIONJ_PAY withPragram:pragram success:^(id responsObj) {
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
                NSDictionary * dic = dataArr[i];
                NSDictionary * dic1 = dic[@"order"];
                model.pay_money = dic1[@"pay_money"];
                model.status = @"1";
                [self.dataArr addObject:model];
            }
            [self reloadData];
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
