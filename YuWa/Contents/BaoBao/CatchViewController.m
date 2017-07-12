//
//  CatchViewController.m
//  YuWa
//
//  Created by double on 17/3/1.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CatchViewController.h"
#import "AdressViewController.h"
#import "SweepViewController.h"
@interface CatchViewController ()

@end

@implementation CatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.f];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.f];
}
- (void)makeUI{
    UIImageView * freeCatch = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    freeCatch.image = [UIImage imageNamed:@"freecatch"];
    [self.view addSubview:freeCatch];
    freeCatch.userInteractionEnabled = YES;
    CGFloat btnWidth = (kScreen_Width - 10 - 40)/2;
    NSArray * btnImageArr = @[@"扫码抓娃娃",@"娃娃机分布"];
    for (int i = 0; i<2; i++) {
        UIButton * touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = CGRectMake(20 + (btnWidth + 10)* i, kScreen_Height * 0.85f, btnWidth, btnWidth/2);
        [touchBtn setImage:[UIImage imageNamed:btnImageArr[i] ] forState:UIControlStateNormal];
        touchBtn.tag = i + 1;
        [touchBtn addTarget:self action:@selector(touchCatch:) forControlEvents:UIControlEventTouchUpInside];
        [freeCatch addSubview:touchBtn];
    }
    
}
- (void)touchCatch:(UIButton*)sender{
    switch (sender.tag) {
        case 1: //扫码夹娃娃
        {
            SweepViewController * sweepVC = [[SweepViewController alloc]init];
            [self.navigationController pushViewController:sweepVC animated:YES];

        }
            break;
            
        default://娃娃机分布
        {
            AdressViewController * adressVC = [[AdressViewController alloc]init];
            [self.navigationController pushViewController:adressVC animated:YES];

        }
            break;
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
