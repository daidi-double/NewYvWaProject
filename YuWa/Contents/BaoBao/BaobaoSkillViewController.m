//
//  BaobaoSkillViewController.m
//  YuWa
//
//  Created by double on 17/3/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "BaobaoSkillViewController.h"
#import "IndroduceViewController.h"
#import "CatchViewController.h"
#import "AdressViewController.h"
@interface BaobaoSkillViewController ()

@end

@implementation BaobaoSkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   }
- (IBAction)toCatchBabyAction:(UIButton *)sender {
    CatchViewController * vc = [[CatchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)wawaActionDetail:(UIButton *)sender {
    AdressViewController * vc = [[AdressViewController alloc]init];
    vc.status = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toAwardAction:(UIButton *)sender {
    IndroduceViewController * vc = [[IndroduceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.f];
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
