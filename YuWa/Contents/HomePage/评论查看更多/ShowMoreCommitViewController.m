//
//  ShowMoreCommitViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ShowMoreCommitViewController.h"
#import "CommentTableViewCell.h"
#import "HUDFailureShowView.h"

//#import "HUDLoadingShowView.h"   //加载图
//#import "HUDFailureShowView.h"   //失败显示
#import "JWTools.h"

#import "CommentModel.h"


#define CELL0  @"CommentTableViewCell"


@interface ShowMoreCommitViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)HUDFailureShowView*failView;

@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,strong)NSMutableArray*maMallDatas;
@end

@implementation ShowMoreCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title=@"更多评论";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self setUpMJRefresh];
    
}

-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=0;
    self.maMallDatas=[NSMutableArray array];
    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.maMallDatas=[NSMutableArray array];
        [self getDatas];

    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas];
    }];
    
    //立即刷新
    [self.tableView.mj_header beginRefreshing];
    
    
    
}

-(void)getDatas{
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_MORECOMMIT];
    NSDictionary*params=@{@"shop_id":self.shop_id,@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    
    

    UIView*loadingView=[JWTools addLoadingViewWithframe:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64)];
    [self.view addSubview:loadingView];
    
    
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data[@"data"]);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                CommentModel*model=[CommentModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
                
            }
            [self.tableView reloadData];
            
            //如果没有数据
            if (self.maMallDatas.count<1) {
                [JRToast showWithText:@"没有更多评论了！" duration:3.5f];

//                [self.view addSubview:self.failView];
//                UIView*failView=[JWTools addFailViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64) withTouchBlock:^{
//                    [failView removeFromSuperview];
//                    [self.tableView.mj_header beginRefreshing];
//                    
//                }];
////                [self.view addSubview:failView];
//                [self.view insertSubview:failView belowSubview:loadingView];
                
            }

            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];    //移除

        });
              [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.maMallDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    
     CommentModel*model=self.maMallDatas[indexPath.section];
     [cell giveValueWithModel:model];
      return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentModel*model=self.maMallDatas[indexPath.section];
    return [CommentTableViewCell getCellHeight:model];


}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}



@end
