//
//  CommendViewController.m
//  YuWa
//
//  Created by double on 17/2/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CommendViewController.h"
#import "ChooseMovieHeaderView.h"
#import "MovieAddComment.h"//评分
#import "CinemaAndBuyTicketModel.h"
#import "MovieDetailViewController.h"
@interface CommendViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIGestureRecognizerDelegate,MovieAddCommentDelegate>
{
    UITextView * textCommendView;
}
@property (nonatomic,strong) UITableView * commendTableView;
@property (nonatomic,assign)NSInteger movieScore;//电影评分
@end

@implementation CommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发影评";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * issuBtn = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(addGrade)];
    self.navigationItem.rightBarButtonItem = issuBtn;
    [self makeUI];
    if (self.status == 1) {
        [self requestMovieData];
    }
    // Do any additional setup after loading the view.
}
- (void)addGrade{
    NSLog(@"发布影评");
    [self requestData];
}
- (void)makeUI{
    self.view.backgroundColor = RGBCOLOR(244, 245, 246, 1);
    _commendTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*0.4) style:UITableViewStyleGrouped];
    
    _commendTableView.delegate = self;
    _commendTableView.dataSource = self;
    
    [self.view addSubview:_commendTableView];
    
    MovieAddComment * addComent = [[MovieAddComment alloc]initWithFrame:CGRectMake(15, _commendTableView.bottom, kScreen_Width-30, 88)];
    addComent.layer.cornerRadius = 10;
    addComent.layer.masksToBounds = YES;
    addComent.delegate = self;

    [self.view addSubview:addComent];
    
    
    textCommendView = [[UITextView alloc]initWithFrame:CGRectMake(15,addComent.bottom+20, kScreen_Width-30, 88)];
    textCommendView.delegate = self;
    textCommendView.layer.cornerRadius = 10;
    textCommendView.layer.masksToBounds = YES;
    textCommendView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textCommendView];
    
    self.comLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreen_Width/5, 20)];
    _comLabel.text = @"写下你影评";
    _comLabel.textColor = [UIColor lightGrayColor];
    _comLabel.font = [UIFont systemFontOfSize:10];
    [textCommendView addSubview:_comLabel];

}


#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        ChooseMovieHeaderView * movieView = [[ChooseMovieHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*0.25f)];
        movieView.model = self.headerModel;
        if (self.headerModel.image == nil) {
            
            [movieView.posterImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.headerModel.poster]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }
        movieView.backgroundColor = [UIColor darkGrayColor];
        UITapGestureRecognizer * tapTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(movieDetailAction)];
        tapTouch.delegate = self;
        tapTouch.numberOfTapsRequired = 1;
        tapTouch.numberOfTouchesRequired = 1;
        [movieView addGestureRecognizer:tapTouch];
        [movieView.PrivateLetterTap removeTarget:self action:@selector(tapAvatarView)];
        [movieView.wantSeeBtn removeFromSuperview];
        [movieView.gradeBtn removeFromSuperview];
        [movieView addGestureRecognizer:tapTouch];
        return movieView;
    }else{
        return nil;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kScreen_Height * 0.25f;
        
    }else{
        return 0.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }

    return cell;
}
//设置textView的placeholder
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (textCommendView.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            self.comLabel.hidden=NO;//隐藏文字
        }else{
            self.comLabel.hidden=YES;
        }
    }else{//textview长度不为0
        if (textCommendView.text.length>=1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                self.comLabel.hidden=NO;
            }else{//不是删除
                _comLabel.hidden=YES;
            }
        }else{//长度不为1时候
            self.comLabel.hidden=YES;
        }
    }

    return YES;
    
}
- (void)tapAvatarView{
    
  
}
//进入电影详情
-(void)movieDetailAction{
    MovieDetailViewController * vc = [[MovieDetailViewController alloc]init];
    vc.filmCode = self.film_code;

    [self.navigationController pushViewController:vc animated:YES];

}
//代理
-(void)movieAddCommentAndScore:(NSInteger)score{
    self.movieScore = score;
}

//判断是否登入
- (BOOL)judgeLogin{
    
    return [UserSession instance].isLogin;
}
#pragma mark - requestData
- (void)requestData{
    if (self.movieScore == 0) {
        [JRToast showWithText:@"请滑动星星评分" duration:1];
        return;
    }else if (textCommendView.text == nil || [textCommendView.text isEqualToString:@""]){
        [JRToast showWithText:@"请留下您的宝贵意见" duration:1];
        return;
    }
    self.film_code = self.headerModel.code;

    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_COMMENTSCORE];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"customer_content":textCommendView.text,@"score":@(self.movieScore),@"film_id":self.film_code};
    if (self.status != 0) {
        pragrams = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"order_id":self.order_id,@"customer_content":textCommendView.text,@"score":@(self.movieScore),@"film_id":self.film_code};
    }
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"影评%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            [JRToast showWithText:@"网络超时，请检查网络" duration:1];
        }
     
    }];

    
}
- (void)requestMovieData{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CINEMAANDBUYTICKET];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"filmCode":self.film_code};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([self judgeLogin]) {
        
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
        [dic setValue:[UserSession instance].token forKey:@"token"];
    }
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"电影信息%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            for (NSDictionary * dict in data[@"data"][@"filmsInfo"]) {
                
                self.headerModel = [CinemaAndBuyTicketModel yy_modelWithDictionary:dict];
            }
            
        }else{
            [JRToast showWithText:@"网络超时，请检查网络" duration:1];
        }
        [self.commendTableView reloadData];
    }];
    //    [self.movieTableView.mj_header endRefreshing];
    //    [self.movieTableView.mj_footer endRefreshing];
    
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
