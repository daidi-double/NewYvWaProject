//
//  YWmarkNameViewController.m
//  YuWa
//
//  Created by L灰灰Y on 2017/6/12.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWmarkNameViewController.h"

@interface YWmarkNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textfileName;

@end

@implementation YWmarkNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton * bnt = [[UIButton alloc]init];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:bnt];
    [bnt setTitle:@"完成" forState:UIControlStateNormal];
    bnt.frame = CGRectMake(0, 0, 50, 30);
    [bnt addTarget:self action:@selector(rightBarButton:) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = barBtn;
}
-(void)rightBarButton:(UIButton *)btn{
    if (self.textfileName.text.length>0) {
        if (self.nickName) {
            self.nickName(self.textfileName.text);
        }
    }else{
        //
         [JRToast showWithText:@"请输备注名称"];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
@end
