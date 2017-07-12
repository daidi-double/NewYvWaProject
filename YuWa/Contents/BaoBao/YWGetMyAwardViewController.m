//
//  YWGetMyAwardViewController.m
//  YuWa
//
//  Created by double on 17/3/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWGetMyAwardViewController.h"

@interface YWGetMyAwardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *NameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *shiTF;
@property (weak, nonatomic) IBOutlet UITextField *zhenTF;
@property (weak, nonatomic) IBOutlet UITextField *jiedaoTF;
@property (weak, nonatomic) IBOutlet UITextField *otherTF;


@end

@implementation YWGetMyAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MyLog(@"%ld",self.ID);
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)upDateBtn:(UIButton *)sender {
     if ([_NameTF.text isEqualToString:@""]){
        [JRToast showWithText:@"请输入姓名" duration:1];
        return;
    }else if ([_phoneTF.text isEqualToString:@""]){
        [JRToast showWithText:@"请输入电话" duration:1];
        return;
    }else if ([_addressTF.text isEqualToString:@""]){
        [JRToast showWithText:@"请输入省份" duration:1];
        return;
    }else if ([_shiTF.text isEqualToString:@""]){
        [JRToast showWithText:@"请输入市" duration:1];
        return;
    }else if ([_zhenTF.text isEqualToString:@""]){
        [JRToast showWithText:@"请输入区/县" duration:1];
        return;
    }else if ([_jiedaoTF.text isEqualToString:@""]){
        [JRToast showWithText:@"请输入街道/镇" duration:1];
        return;
    }else if ([_otherTF.text isEqualToString:@""]) {
        [JRToast showWithText:@"请输入详细街道" duration:1];
        return;
    }
    [self upRequestData];

}
- (void)upRequestData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_EXCHANGE];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"name":_NameTF.text,@"phone":_phoneTF.text,@"shi":_shiTF.text,@"shen":_addressTF.text,@"qu":_zhenTF.text,@"jiedao":_jiedaoTF.text,@"xiangxi":_otherTF.text,@"s_id":@(self.ID)};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSInteger number = [data[@"errorCode"]integerValue];
        if (number == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
       [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing: YES];
    
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
