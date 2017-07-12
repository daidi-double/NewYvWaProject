//
//  AdressViewController.m
//  YuWa
//
//  Created by double on 17/3/1.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AdressViewController.h"
#import "CatchViewController.h"
#import "IndroduceViewController.h"
@interface AdressViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *adressScrollView;

@end

@implementation AdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeBtn];
}
- (void)makeBtn{
    UIImage * image;
    if (self.status == 1) {
        image = [UIImage imageNamed:@"actionintroduce"];
    }else{
        NSString * path = [[NSBundle mainBundle]pathForResource:@"adress" ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:path];
    }
    UIScrollView*scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    scrollView.contentSize=CGSizeMake(kScreen_Width, kScreen_Width * image.size.height/image.size.width);
    
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width * image.size.height/image.size.width)];
    imageView.image = image;
    
    [scrollView addSubview:imageView];
    self.adressScrollView=scrollView;
    if (self.status == 1) {
        CGFloat btnWidth = (kScreen_Width - 10 - 40)/2;
        NSArray * btnImageArr = @[@"catch2",@"prize"];
        for (int i = 0; i<2; i++) {
            UIButton * touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            touchBtn.frame = CGRectMake(20 + (btnWidth + 10)* i, kScreen_Width * image.size.height/image.size.width* 0.9f, btnWidth, btnWidth/2.5);
            [touchBtn setImage:[UIImage imageNamed:btnImageArr[i] ] forState:UIControlStateNormal];
            touchBtn.tag = i + 1;
            [touchBtn addTarget:self action:@selector(touchCatch:) forControlEvents:UIControlEventTouchUpInside];
            [self.adressScrollView addSubview:touchBtn];
        }
        
        
    }
    
}
- (void)touchCatch:(UIButton*)sender{
    switch (sender.tag) {
        case 1:
        {
            CatchViewController * catch = [[CatchViewController alloc]init];
            
            [self.navigationController pushViewController:catch animated:YES];
        }
            
            break;
        default:
        {
            IndroduceViewController * inVC = [[IndroduceViewController alloc]init];
            [self.navigationController pushViewController:inVC animated:YES];
        }
            break;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

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
