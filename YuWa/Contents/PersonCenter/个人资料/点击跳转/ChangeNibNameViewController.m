//
//  ChangeNibNameViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChangeNibNameViewController.h"

@interface ChangeNibNameViewController ()

@end

@implementation ChangeNibNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(touchComplete)];
    self.navigationItem.rightBarButtonItem=item;
    
    if (self.type==TouchTypeNickName) {
        UILabel*label=[self.view viewWithTag:1];
        label.text=@"使用中英文、数字和下划线，昵称一个月只能申请修改一次";
        
    }else{
        UILabel*label=[self.view viewWithTag:1];
        label.text=@"请输入您所在的城市";
        
    }
    
    
}

-(void)touchComplete{
    if ([self.delegate respondsToSelector:@selector(DelegateToChangeNibName:andTouchType:)]) {
        UITextField*textField=[self.view viewWithTag:2];
        NSString*name=textField.text;
        [self.delegate DelegateToChangeNibName:name andTouchType:self.type];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
//隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

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
