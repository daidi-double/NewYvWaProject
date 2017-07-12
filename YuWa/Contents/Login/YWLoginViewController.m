//
//  YWLoginViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/19.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWLoginViewController.h"
#import "YWRegisterViewController.h"
#import "YWForgetPassWordViewController.h"
#import "YJSegmentedControl.h"
#import "JPUSHService.h"

@interface YWLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordtextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *hiddenPasswordBtn;

//@property (nonatomic,strong)YJSegmentedControl * segmentControl;
@property (nonatomic,strong)UIView * segmentLineView;
@property (nonatomic,assign)BOOL isHiddenPassword;

@property (weak, nonatomic) IBOutlet UIView *quickLoginView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *secuirtyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *secuirtyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *quickLoginBtn;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger time;
@property (nonatomic,assign)NSInteger state;

@end

@implementation YWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeUI];
    self.time = 60;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    if (self.state == 0) {
//        [self.accountTextField becomeFirstResponder];
    }else{
//        [self.mobileTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer=nil;
}

- (void)makeNavi{
    self.title = @"登录";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImageName:@"NaviBack" withSelectImage:@"NaviBack" withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTarget:self action:@selector(backBarAction) forControlEvents:UIControlEventTouchUpInside withSize:CGSizeMake(25.f, 25.f)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}
//第三方登录
- (IBAction)QQLoginAction:(UIButton *)sender {
    
}
- (IBAction)weiXLoginAction:(UIButton *)sender {
    
}
- (IBAction)weiboLoginAction:(UIButton *)sender {
    
}

- (void)makeUI{
    self.accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.mobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.secuirtyCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.passwordtextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.passwordtextField.secureTextEntry = YES;
    self.secuirtyCodeBtn.layer.cornerRadius = 10.f;
    self.secuirtyCodeBtn.layer.masksToBounds = YES;
    self.secuirtyCodeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.secuirtyCodeBtn.layer.borderWidth = 1;
    NSArray * titleAry = @[@"账号密码登入",@"手机号快速登入"];
    for (int i = 0; i<2; i++) {
        UIButton * segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        segmentBtn.frame = CGRectMake(kScreen_Width/2*i, NavigationHeight, kScreen_Width/2, 39.f);
        [segmentBtn setTitle:titleAry[i] forState:UIControlStateNormal];
        [segmentBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [segmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        segmentBtn.tag = 222 + i;
        [segmentBtn addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:segmentBtn];
        
    }
    self.segmentLineView = [[UIView alloc]initWithFrame:CGRectMake(0, NavigationHeight+39, kScreen_Width/2, 1.f)];
    self.segmentLineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentLineView];
}

#pragma mark - ButtonAction
- (void)registerAction{
    YWRegisterViewController * vc = [[YWRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backBarAction{
    [self.navigationController popViewControllerAnimated:YES];
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hiddenPasswordBtnAction:(id)sender {
    self.passwordtextField.secureTextEntry = self.isHiddenPassword;
    [self.hiddenPasswordBtn setBackgroundImage:[UIImage imageNamed:self.isHiddenPassword == NO?@"showPassword":@"hiddenPassword"] forState:UIControlStateNormal];
    self.isHiddenPassword = !self.isHiddenPassword;
}

- (IBAction)loginBtnAction:(id)sender {
    if ([self canSendRequset]) {
        [self requestLoginWithAccount:self.accountTextField.text withPassword:self.passwordtextField.text];
    }
}

- (IBAction)forgetPasswordBtnAction:(id)sender {
    YWForgetPassWordViewController * vc = [[YWForgetPassWordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)canSendRequset{
    if (![JWTools checkTelNumber:self.accountTextField.text]) {
        [self showHUDWithStr:@"请输入11位手机号" withSuccess:NO];
        return NO;
    }else if (![JWTools isRightPassWordWithStr:self.passwordtextField.text]){
        [self showHUDWithStr:@"请输入6-16位密码" withSuccess:NO];
        return NO;
    }
    return YES;
}

- (IBAction)secuirtyCodeBtnAction:(id)sender {
    if (![JWTools checkTelNumber:self.mobileTextField.text]) {
        [self showHUDWithStr:@"请输入11位手机号" withSuccess:NO];
        return ;
    }
    [self requestQuickLoginCode];
}
- (IBAction)quickLoginBtnAction:(id)sender {
    if ([self canQuickSendRequset]) {
        [self requestLoginWithMobile:self.mobileTextField.text withSecuirtyCode:self.secuirtyCodeTextField.text];
    }
}
- (BOOL)canQuickSendRequset{
    if (![JWTools checkTelNumber:self.mobileTextField.text]) {
        [self showHUDWithStr:@"请输入11位手机号" withSuccess:NO];
        return NO;
    }else if ([self.secuirtyCodeTextField.text isEqualToString:@""]){
        [self showHUDWithStr:@"请输入验证码" withSuccess:NO];
        return NO;
    }
    return YES;
}

//重置文字
- (void)securityCodeBtnTextSet{
    if (self.time <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        [self.secuirtyCodeBtn setTitle:[NSString stringWithFormat:@"重获验证码"] forState:UIControlStateNormal];
        [self.secuirtyCodeBtn setUserInteractionEnabled:YES];
        return;
    }
    [self.secuirtyCodeBtn setTitle:[NSString stringWithFormat:@"获取中(%zi)s",self.time] forState:UIControlStateNormal];
    self.time--;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 1) {//passwordTextField
        if ([self canSendRequset]) {
            [textField resignFirstResponder];
            [self requestLoginWithAccount:self.accountTextField.text withPassword:self.passwordtextField.text];
        }
    }else{//secuirtyCodeTextField
        if ([self canQuickSendRequset]) {
            [textField resignFirstResponder];
            [self requestLoginWithMobile:self.mobileTextField.text withSecuirtyCode:self.secuirtyCodeTextField.text];
        }
    }
    return YES;
}


- (void)segmentAction:(UIButton*)sender{
    self.state = sender.tag - 222;
    self.segmentLineView.centerX = sender.centerX;
    switch (sender.tag) {
        case 222:
            self.quickLoginView.hidden = YES;
            break;
            
        default:
            self.quickLoginView.hidden = NO;
            break;
    }
}

#pragma mark - Http
- (void)requestLoginWithAccount:(NSString *)account withPassword:(NSString *)password{
    NSDictionary * pragram = @{@"phone":account,@"password":password};
    [[HttpObject manager]postDataWithType:YuWaType_Logion withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [UserSession saveUserLoginWithAccount:account withPassword:password];
        [UserSession saveUserInfoWithDic:responsObj[@"data"]];
        [self showHUDWithStr:@"登录成功" withSuccess:YES];
        EMError *errorLog = [[EMClient sharedClient] loginWithUsername:account password:[UserSession instance].hxPassword];
        if (!errorLog){
            [[EMClient sharedClient].options setIsAutoLogin:NO];
            MyLog(@"环信登录成功");
            MyLog(@"%@",[EMClient sharedClient].version);

            [UserSession instance].isLoginHX = YES;
        }else{
            [UserSession instance].isLoginHX = NO;
            //如果登录失败，重新登录一次
            EMError *errorLog = [[EMClient sharedClient] loginWithUsername:account password:[UserSession instance].hxPassword];
            if (!errorLog){
                [[EMClient sharedClient].options setIsAutoLogin:NO];
                MyLog(@"环信登录成功");
                [UserSession instance].isLoginHX = YES;
            }else{
                [UserSession instance].isLoginHX = NO;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JPUSHService setAlias:[UserSession instance].account callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            if (self.status == 1) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } failur:^(id responsObj, NSError *error) {
        NSInteger errorCode = [responsObj[@"errorCode"] integerValue];
        MyLog(@"errorCode = %ld",errorCode);
        if (errorCode == 1) {
            [JRToast showWithText:@"账号或密码错误" duration:2];
        }
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
//        [self showHUDWithStr:responsObj[@"errorMessage"] withSuccess:NO];
    }];
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
  NSLog(@"起别名 :      rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
- (void)requestLoginWithMobile:(NSString *)account withSecuirtyCode:(NSString *)secuirty{
    
    NSDictionary * pragram = @{@"phone":account,@"code":secuirty};
    [[HttpObject manager]postDataWithType:YuWaType_Logion_Quick withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        
        [UserSession saveUserInfoWithDic:responsObj[@"data"]];
        [self showHUDWithStr:@"登录成功" withSuccess:YES];
        
        [UserSession saveUserLoginWithAccount:account withPassword:[UserSession instance].password];
        EMError *errorLog = [[EMClient sharedClient] loginWithUsername:account password:[UserSession instance].hxPassword];
        if (!errorLog){
            [[EMClient sharedClient].options setIsAutoLogin:NO];
            MyLog(@"环信登录成功");
            [UserSession instance].isLoginHX = YES;
        }else{
            [UserSession instance].isLoginHX = NO;
            //登录失败，就重新在登录一次
            EMError *errorLog = [[EMClient sharedClient] loginWithUsername:account password:[UserSession instance].hxPassword];
            if (!errorLog){
                [[EMClient sharedClient].options setIsAutoLogin:NO];
                MyLog(@"环信登录成功");
                [UserSession instance].isLoginHX = YES;
            }else{
                [UserSession instance].isLoginHX = NO;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JPUSHService setAlias:[UserSession instance].account callbackSelector:nil object:nil];
            [self.navigationController popViewControllerAnimated:YES];
             [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
             [self dismissViewControllerAnimated:YES completion:nil];
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:responsObj[@"errorMessage"] withSuccess:NO];
        
        self.time = 0;//失败后重置验证码
        [self securityCodeBtnTextSet];
    }];
}

- (void)requestQuickLoginCode{
    NSDictionary * pragram = @{@"phone":self.mobileTextField.text,@"tpl_id":@22073};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Logion_Code withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.secuirtyCodeBtn setUserInteractionEnabled:NO];
//        self.secuirtyCodeBtn.backgroundColor = CNaviColor;
        [self securityCodeBtnTextSet];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(securityCodeBtnTextSet) userInfo:nil repeats:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}


//隐藏键盘
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
//}
//
////touch began
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
//}


- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

@end