//
//  DetaliViewController.m
//  YuWa
//
//  Created by double on 2017/2/18.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "DetaliViewController.h"
#import "ChooseMovieController.h"
#import "LookAllViewController.h"
@interface DetaliViewController ()
@property (nonatomic,strong)UIScrollView * movieScrollView;
@property (nonatomic,strong)UIImageView * HPicImageView;
//@property (nonatomic,strong)UIButton * discount_buyTicket;
@property (nonatomic,strong)UIButton * look_more;
@property (nonatomic,strong)NSMutableArray * movieDataArray;
@property (nonatomic,strong)NSMutableArray * buyTicketData;

@end

@implementation DetaliViewController
- (NSMutableArray*)movieDataArray{
    if (!_movieDataArray) {
        _movieDataArray = [NSMutableArray array];
    }
    return _movieDataArray;
}
- (NSMutableArray*)buyTicketData{
    if (!_buyTicketData) {
        _buyTicketData = [NSMutableArray array];
    }
    return _buyTicketData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSLog(@"%ld",self.markTag);
    [self makeUI];
}
- (void)makeUI{
    _movieScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _movieScrollView.contentSize = CGSizeMake(kScreen_Width, kScreen_Height * 1.3f);
    [self.view addSubview:_movieScrollView];

    _HPicImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"baobaoBG1"]];
    _HPicImageView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height * 1.3f);
    _HPicImageView.userInteractionEnabled = YES;
    [_movieScrollView addSubview:_HPicImageView];
    
    for (int i = 0; i<2; i++) {
        UIImageView * movieImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, _HPicImageView.height*0.4f +(25 +kScreen_Height/4)*i, kScreen_Width-40, kScreen_Height/4)];

        movieImageView.image = [UIImage imageNamed:@"baobaoBG3"];
        movieImageView.userInteractionEnabled = YES;
        [_HPicImageView addSubview:movieImageView];
        
        UIButton * discount_buyTicket = [UIButton buttonWithType:UIButtonTypeCustom];
        discount_buyTicket.frame = CGRectMake(movieImageView.width * 0.6f, movieImageView.height*0.75f, movieImageView.width/3, movieImageView.height/5);
        discount_buyTicket.backgroundColor = RGBCOLOR(204, 32, 45, 1);
        discount_buyTicket.tag = 500+i;
        discount_buyTicket.layer.masksToBounds = YES;
        discount_buyTicket.layer.cornerRadius = 6;
        [discount_buyTicket addTarget:self action:@selector(discountBuyTickets:) forControlEvents:UIControlEventTouchUpInside];
        [movieImageView addSubview:discount_buyTicket];
        
    }
    
    _look_more = [UIButton buttonWithType:UIButtonTypeCustom];
    _look_more.frame = CGRectMake(_HPicImageView.width * 0.3f, _HPicImageView.height*0.9f, _HPicImageView.width/2, 30);
    _look_more.backgroundColor = RGBCOLOR(204, 32, 45, 1);
    _look_more.layer.masksToBounds = YES;
    _look_more.layer.cornerRadius = 6;
    [_look_more addTarget:self action:@selector(lookMoreMovie) forControlEvents:UIControlEventTouchUpInside];
    [_look_more setTitle:@"点击查看更多电影" forState:UIControlStateNormal];
    [_HPicImageView addSubview:_look_more];
    
    UIImageView * yuwaLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width/2, 45)];
    NSString * path1 = [[NSBundle mainBundle]pathForResource:@"yuwalogo" ofType:@"png"];
    yuwaLogo.image = [UIImage imageWithContentsOfFile:path1];
    yuwaLogo.center = CGPointMake(kScreen_Width/2, _HPicImageView.height*0.975f);
    [self.HPicImageView addSubview:yuwaLogo];
//    UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width * 0.3f, 25)];
//    title.textColor = [UIColor whiteColor];
//    title.text = @"雨娃电影";
//    title.center = CGPointMake(kScreen_Width/2+32, _HPicImageView.height*0.97f);
//    [self.HPicImageView addSubview:title];
}
- (void)lookMoreMovie{
    LookAllViewController * lookAllVC = [[LookAllViewController alloc]init];
    [self.navigationController pushViewController:lookAllVC animated:YES];
}
- (void)discountBuyTickets:(UIButton*)sender{
    if (sender.tag == 500) {
        
    }else{
        
    }
    ChooseMovieController * chooseVC = [[ChooseMovieController alloc]init];
    [self.navigationController pushViewController:chooseVC animated:YES];

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
