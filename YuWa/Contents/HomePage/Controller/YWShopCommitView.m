//
//  YWShopCommitView.m
//  YuWa
//
//  Created by double on 17/4/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShopCommitView.h"
#import "YWShopScoreTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#define COMMENTCELl @"CommentTableViewCell"
#define SCORECELL  @"YWShopScoreTableViewCell"
@interface YWShopCommitView ()<UITableViewDelegate,UITableViewDataSource>

{
    UIButton * markBtn;
}
@property(nonatomic,strong)HUDFailureShowView*failView;
@property (nonatomic,strong)UIView * bgview;
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,strong)NSMutableArray*maMallDatas;
@property (nonatomic,copy)NSString *type;
@end
@implementation YWShopCommitView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shopCommitTableView];
        self.shopCommitTableView.backgroundColor = RGBCOLOR(240, 240, 240, 1);
        self.type = @"1";
        [self setUpMJRefresh];
    }
    return self;
}
-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=0;
    self.maMallDatas=[NSMutableArray array];
    
    self.shopCommitTableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.maMallDatas=[NSMutableArray array];
        [self getDatas:self.type];
        
    }];
    
    //上拉刷新
    self.shopCommitTableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas:self.type];
    }];
    
    //立即刷新
    [self.shopCommitTableView.mj_header beginRefreshing];
    
    
    
}

- (UITableView*)shopCommitTableView{
    if (!_shopCommitTableView) {
        _shopCommitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _shopCommitTableView.delegate = self;
        _shopCommitTableView.dataSource = self;
        self.shopCommitTableView.backgroundColor = RGBCOLOR(240, 240, 240, 1);
        [_shopCommitTableView registerNib:[UINib nibWithNibName:SCORECELL bundle:nil] forCellReuseIdentifier:SCORECELL];
        [_shopCommitTableView registerNib:[UINib nibWithNibName:COMMENTCELl bundle:nil] forCellReuseIdentifier:COMMENTCELl];
    }
    return _shopCommitTableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 1;
    }
    return self.maMallDatas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 45.f;
    }
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.bgview;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return 88.f;
    }
    CommentModel*model=self.maMallDatas[indexPath.row];

    return [CommentTableViewCell getCellHeight:model];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YWShopScoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SCORECELL];
        cell.selectionStyle = NO;
        cell.totalScore = self.totalScore;
        return cell;
    }else{
        CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:COMMENTCELl];
        for (UIView * view in cell.contentView.subviews) {
//            MyLog(@"%ld",(long)view.tag);
            if ((2100>=view.tag&&view.tag >= 2000)||(1100>=view.tag&&view.tag >= 1000)) {
                [view removeFromSuperview];
            }
        }
        cell.selectionStyle=NO;
        
        CommentModel*model=self.maMallDatas[indexPath.row];
        [cell giveValueWithModel:model];
        return cell;
    }
}

-(void)getDatas:(NSString *)type{

    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_SHOPDETAILCOMMENT];
    NSDictionary*params=@{@"shop_id":self.shop_id,@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"type":type};
    HttpManager*manager=[[HttpManager alloc]init];
    
    
    
    UIView*loadingView=[JWTools addLoadingViewWithframe:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64)];
    [self addSubview:loadingView];
    
    
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
            // NSData转为NSString
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        MyLog(@"评价data = %@",jsonStr);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [self.maMallDatas removeAllObjects];
            for (NSDictionary*dict in data[@"comment"]) {
                CommentModel*model=[CommentModel yy_modelWithDictionary:dict];
                //商家评论数据
                NSMutableArray * arr = dict[@"rep_list"];
                if (arr.count) {
                    for (NSDictionary * dic in arr) {
                        [model.shangJiaRep addObject:dic[@"content"]];
                    }
                }
                [self.maMallDatas addObject:model];
            }
            [self.shopCommitTableView reloadData];
            
            //如果没有数据
            if (self.maMallDatas.count<1) {
                [JRToast showWithText:@"没有更多评论了！" duration:3.5f];
                
            }
            
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];    //移除
            
        });
        [self.shopCommitTableView.mj_header endRefreshing];
        [self.shopCommitTableView.mj_footer endRefreshing];
        
    }];
    
}

- (void)seeOtherComment:(UIButton*)sender{
    if (sender.selected == YES) {
        return;
    }
    sender.selected = YES;
    markBtn.selected = NO;
    markBtn = sender;
    self.type = [NSString stringWithFormat:@"%ld",sender.tag];
    [self getDatas:[NSString stringWithFormat:@"%ld",sender.tag -999]];
}
- (UIView*)bgview{
    if (!_bgview) {
        _bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 45)];
        _bgview.backgroundColor = RGBCOLOR(240, 240, 240, 1);
        UIView * bgViewT = [[UIView alloc]initWithFrame:CGRectMake(0, 5, kScreen_Width, 35)];
        bgViewT.backgroundColor = [UIColor whiteColor];
        [_bgview addSubview:bgViewT];
        
        NSArray * titleAry = @[@"全部评论",@"好评",@"中差评"];
        CGFloat btnWidth = (kScreen_Width -2)/3;
        for (int i = 0; i <3;  i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((btnWidth +1) * i, 0, btnWidth, 35);
            [btn setTitle:titleAry[i] forState:UIControlStateNormal];
            btn.centerY = bgViewT.frame.size.height/2;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:CNaviColor forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            if (i == 0 ) {
                btn.selected = YES;
                markBtn.selected = NO;
                markBtn = btn;
            }
            btn.tag = 1000 +i;
            [btn addTarget:self action:@selector(seeOtherComment:) forControlEvents:UIControlEventTouchUpInside];
            [bgViewT addSubview:btn];
            
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(btnWidth +(1+btnWidth)*i, 8, 1, 19)];
            line.backgroundColor = [UIColor lightGrayColor];
            
            [bgViewT addSubview:line];
        }

    }
    return _bgview;
}
@end
