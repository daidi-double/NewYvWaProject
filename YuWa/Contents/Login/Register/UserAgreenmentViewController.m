//
//  UserAgreenmentViewController.m
//  YuWa
//
//  Created by double on 17/3/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "UserAgreenmentViewController.h"
#import "HttpObject.h"
@interface UserAgreenmentViewController ()


@property (weak, nonatomic) IBOutlet UIButton *agreenBtn;
@property (weak, nonatomic) IBOutlet UITextView *agreenmentTextView;
@property (nonatomic,assign)NSInteger faild;
@end

@implementation UserAgreenmentViewController

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
    self.title = @"用户协议";
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"同意" style:UIBarButtonItemStylePlain target:self action:@selector(agreenmentAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;

}

- (void)makeUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.agreenBtn.layer.cornerRadius =  5.f;
    self.agreenBtn.layer.masksToBounds = YES;
    if ([UserSession instance].agreement) {
        self.agreenmentTextView.text = [UserSession instance].agreement;
        [self.agreenmentTextView setContentOffset:CGPointMake(0.f, 0.f)];
    }else{
        [self requestAgreeData];
    }
}

- (IBAction)agreeBtnAction:(id)sender {
    [self agreenmentAction];
}

- (void)agreenmentAction{
    if (self.staus == 0) {
        
    }else{
        self.agreeBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Http
- (void)requestAgreeData{
    
    [[HttpObject manager]postDataWithType:YuWaType_argeenment withPragram:nil success:^(id responsObj) {
        MyLog(@"Regieter Code is %@",responsObj);
        self.agreenmentTextView.text = responsObj[@"data"]?responsObj[@"data"]:@"";
        if (![self.agreenmentTextView.text isEqualToString:@""])[UserSession instance].agreement = self.agreenmentTextView.text;
        [self.agreenmentTextView setContentOffset:CGPointMake(0.f, 0.f)];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code error is %@",responsObj);
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
