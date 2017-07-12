//
//  BusinessAgreementDetaliViewController.m
//  YuWa
//
//  Created by double on 17/3/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "BusinessAgreementDetaliViewController.h"
#import "HttpObject.h"
@interface BusinessAgreementDetaliViewController ()


@property (weak, nonatomic) IBOutlet UITextView *agreementTextView;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (nonatomic,assign)NSInteger faild;
@end

@implementation BusinessAgreementDetaliViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeUI];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
}
- (void)makeNavi{
    self.title = @"商务会员协议";
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"同意" style:UIBarButtonItemStylePlain target:self action:@selector(agreenment)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

- (void)makeUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.agreeBtn.layer.cornerRadius =  5.f;
    self.agreeBtn.layer.masksToBounds = YES;
    if ([UserSession instance].businessAgreement) {
        self.agreementTextView.text = [UserSession instance].businessAgreement;
        [self.agreementTextView setContentOffset:CGPointMake(0.f, 0.f)];
    }else{
        [self requestAgreeData];
    }
}

- (IBAction)agreeBtn:(UIButton *)sender{
    
    [self agreenment];
}


- (void)agreenment{
    self.agreeBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Http
//商务会员协议
- (void)requestAgreeData{
    
    [[HttpObject manager]postDataWithType:YuWaType_Business_VIP withPragram:nil success:^(id responsObj) {
        
        self.agreementTextView.text = responsObj[@"data"]?responsObj[@"data"]:@"";
        if (![self.agreementTextView.text isEqualToString:@""])[UserSession instance].businessAgreement = self.agreementTextView.text;
        [self.agreementTextView setContentOffset:CGPointMake(0.f, 0.f)];
    } failur:^(id responsObj, NSError *error) {
//        MyLog(@"Regieter Code error is %@",responsObj);
        self.faild++;
        if (self.faild<3)[self requestAgreeData];
    }];
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
