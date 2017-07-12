//
//  MovieDetailViewController.m
//  YuWa
//
//  Created by double on 17/5/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "MovieCinemaViewController.h"
#import "CommentTableViewCell.h"
#import "CinemaCharacteristicTableViewCell.h"
#import "MovieDetailHeaderView.h"
//#import "CommentModel.h"
#import "ChooseMovieHeaderView.h"//第一区头部
#import "CommendViewController.h"
#import "FilmDetailTableViewCell.h"
#import "AllPhotoViewController.h"

#define FILMDETAILCELL @"FilmDetailTableViewCell"
//#define COMMENTCELl111 @"CommentTableViewCell"
#define CinemaCell123 @"CinemaCharacteristicTableViewCell"
@interface MovieDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MovieDetailHeaderViewDelegate,CinemaCharacteristicTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (nonatomic,strong) MovieDetailHeaderView * headerView;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (nonatomic,strong) ChooseMovieHeaderView* firstHeaderView;
@property (nonatomic,strong) CommentModel * model;
@property (nonatomic,strong) NSMutableArray * commentAry;
@property (nonatomic,strong)UILabel * textLabel;
@property (nonatomic,strong) UIButton * commentBtn;
@property (nonatomic,assign) BOOL isAllIntro;//是否展开介绍
@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self makeUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)makeUI{
    self.title = @"影片详情";
    [self.detailTableView registerNib:[UINib nibWithNibName:CinemaCell123 bundle:nil] forCellReuseIdentifier:CinemaCell123];
    
    [self.detailTableView registerNib:[UINib nibWithNibName:FILMDETAILCELL bundle:nil] forCellReuseIdentifier:FILMDETAILCELL];
    self.isAllIntro = 0;
}
//选座购票
- (IBAction)chooseSeatAction:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 40.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if (self.isAllIntro) {
            
            return [MovieDetailHeaderView getHeaderHeight:self.cinemaDetailModel.intro];
        }else{
            return 320;
        }
    }
    return kScreen_Height* 0.3f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {

        return kScreen_Height * 232/1334.f +20;
    }
    return 40.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        self.firstHeaderView.model = self.cinemaDetailModel;
        self.firstHeaderView.status = 1;
        self.firstHeaderView.rightImageView.hidden =YES;
        self.firstHeaderView.backgroundColor = [UIColor whiteColor];
        return self.firstHeaderView;
    }else{
        CGFloat height;
        if (self.isAllIntro) {
            
            height = [MovieDetailHeaderView getHeaderHeight:self.cinemaDetailModel.intro];
        }else{
            height = 320;
        }
        _headerView = [[MovieDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
        _headerView.delegate =self;
        _headerView.status = self.isAllIntro;
        _headerView.model = self.cinemaDetailModel;
        return _headerView;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        FilmDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:FILMDETAILCELL];
        cell.present_like = self.cinemaDetailModel.like_percent;
        cell.ctype = [self.cinemaDetailModel.ctype integerValue];
        cell.filmNo = self.cinemaDetailModel.code;
        cell.selectionStyle = NO;
      
        return cell;
    }else{
        CinemaCharacteristicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CinemaCell123];
        cell.delegate = self;
        NSArray * imageAry = [self.cinemaDetailModel.stills componentsSeparatedByString:@","];
        cell.imageAry = imageAry;
        return cell;

    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.detailTableView) {

        
        CGFloat height = scrollView.frame.size.height;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
        if (bottomOffset <= height)
        {
            //在最底部
           
        } else {
            
        }
        
    }

}
#pragma mark ---http
- (void)requestData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_MOVIEDETAIL];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"filmNo":self.filmCode,@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"参数%@~~~ %@",pragrams,urlStr);
        MyLog(@"影片详情%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            //头部影片数据
            [self.commentAry removeAllObjects];
                self.cinemaDetailModel = [CinemaAndBuyTicketModel yy_modelWithDictionary:data[@"data"][@"filmDetail"]];
        
            //评论部分数据

            
        }
        [self.detailTableView reloadData];
    }];

}
//去吐槽（还没用）
- (void)toComment{
//    CommendViewController * commendVC = [[CommendViewController alloc]init];
//    commendVC.film_code = self.filmCode;
//    commendVC.headerModel = self.cinemaDetailModel;
//    [self.navigationController pushViewController:commendVC animated:YES];
}
//查看剧照
- (void)seeAllPhoto{
    AllPhotoViewController * vc = [[AllPhotoViewController alloc]init];
    NSArray * imageAry = [self.cinemaDetailModel.stills componentsSeparatedByString:@","];
    vc.imageAry = imageAry;
    [self.navigationController pushViewController:vc animated:YES];
}
- (MovieDetailHeaderView*)headerView{
    if (!_headerView) {
        CGFloat height = [MovieDetailHeaderView getHeaderHeight:self.cinemaDetailModel.intro];
        _headerView = [[MovieDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
        _headerView.delegate =self;
    }
    return _headerView;
}
- (ChooseMovieHeaderView *)firstHeaderView{
    if (!_firstHeaderView) {
        _firstHeaderView = [[ChooseMovieHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height * 0.3f)];
        
    }
    return _firstHeaderView;
}
- (NSMutableArray *)commentAry{
    if (!_commentAry) {
        _commentAry = [NSMutableArray array];
    }
    return _commentAry;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toCommentScore{
    CommendViewController * commendVC = [[CommendViewController alloc]init];
    commendVC.headerModel = self.cinemaDetailModel;
//    commendVC.order_id = //在我的订单中评价才需要
    [self.navigationController pushViewController:commendVC animated:YES];
}
- (void)refreshUI:(NSInteger)status{
    self.isAllIntro= status;
//    NSIndexPath * path = [self.detailTableView ]
    [self.detailTableView reloadData];
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
