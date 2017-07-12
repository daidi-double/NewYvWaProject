//
//  CommonUserViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CommonUserViewController.h"

#import "IntroduceMoneyViewController.h"   //展示 介绍分红的 界面
#import "OpenBusinessViewController.h"    //开通商务会员

@interface CommonUserViewController ()

@property(nonatomic,strong)UIScrollView*showScorllView;
@property(nonatomic,strong)UIButton*enterButton;
@end

@implementation CommonUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"非商务会员";
    self.automaticallyAdjustsScrollViewInsets=NO;

    NSString *is =[KUSERDEFAULT valueForKey:SHOWBUSINESS];
    
    if (![is  isEqualToString:@"1"]) {
    //显示轮播图
        [self addScrollView];
        [KUSERDEFAULT setObject:@"1" forKey:SHOWBUSINESS];
    }else{
    
    [self addHeader];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
}


//这个是轮播图
-(void)addScrollView{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"商务会员_750x7220" ofType:@"jpg"];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    UIScrollView*scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64)];
    scrollView.contentSize=CGSizeMake(kScreen_Width, kScreen_Width * image.size.height/image.size.width + 100);
//    scrollView.contentSize=CGSizeMake(kScreen_Width, ACTUAL_HEIGHT(7220));
    [self.view addSubview:scrollView];
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width * image.size.height/image.size.width)];
    imageView.image = image;
//    imageView.image=[UIImage imageNamed:@"商务会员_750x7220.jpg"];
    [scrollView addSubview:imageView];
    self.showScorllView=scrollView;
    
    UIButton*showButton=[[UIButton alloc]initWithFrame:CGRectMake(40, kScreen_Height-80, kScreen_Width-80, 40)];
    [showButton setTitle:@"我知道" forState:UIControlStateNormal];
    [showButton setBackgroundColor:CNaviColor];
    showButton.layer.masksToBounds = YES;
    showButton.layer.cornerRadius = 5;
    [showButton addTarget:self action:@selector(touchIntoMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
    self.enterButton=showButton;
    
}

-(void)touchIntoMain{
    [self.showScorllView removeFromSuperview];
    [self.enterButton removeFromSuperview];
    
    [self addHeader];
    
}



//这个是 主界面
-(void)addHeader{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-84)];
    NSString * path = [[NSBundle mainBundle]pathForResource:@"商务会员_show" ofType:@"jpg"];
    imageView.image= [UIImage imageWithContentsOfFile:path];
    imageView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTap)];
    [imageView addGestureRecognizer:tap];
    
    [self.view addSubview:imageView];
    
    UIButton*openBusnessBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, kScreen_Height - 35,kScreen_Width - 40, 30)];
    [openBusnessBtn setTitle:@"开通商务会员" forState:UIControlStateNormal];
    openBusnessBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [openBusnessBtn setBackgroundColor:CNaviColor];
    openBusnessBtn.layer.masksToBounds = YES;
    openBusnessBtn.layer.cornerRadius = 5;
    [openBusnessBtn addTarget:self action:@selector(openBusnessBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openBusnessBtn];
    
    //这里 要有个 查看自己分红的界面
//    UIBarButtonItem*rightItem=[[UIBarButtonItem alloc]initWithImage: [UIImage imageNamed:@"商务会员_rightTop"] style:UIBarButtonItemStylePlain target:self action:@selector(touchMyIncome)];
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,100, 30)];
    [button setTitle:@"我的介绍分红" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(touchMyIncome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)touchMyIncome{
    IntroduceMoneyViewController*vc=[[IntroduceMoneyViewController alloc]init];
    vc.introduceType=IntroduceTypeUser;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)openBusnessBtn{
    OpenBusinessViewController*vc=[[OpenBusinessViewController alloc]initWithNibName:@"OpenBusinessViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)touchTap{
    OpenBusinessViewController*vc=[[OpenBusinessViewController alloc]initWithNibName:@"OpenBusinessViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
   
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
