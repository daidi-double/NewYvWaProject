//
//  SignatureViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SignatureViewController.h"

@interface SignatureViewController ()<UITextViewDelegate>

@property(nonatomic,assign)NSInteger textNumber;
@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.textNumber=80;
    self.title=@"个性签名";
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(touchComplete)];
    self.navigationItem.rightBarButtonItem=item;
    
    
    UITextView*textView=[self.view viewWithTag:2];
    textView.delegate=self;
//    textView.text=@"sfsj";
    
    NSInteger number=self.textNumber-textView.text.length;
    UILabel*numberLabel=[self.view viewWithTag:3];
    numberLabel.text=[NSString stringWithFormat:@"%ld",(long)number];

    

    
}



- (void)textViewDidChange:(UITextView *)textView
{
    
    
    if (textView.text.length > 80) {
        textView.text = [textView.text substringToIndex:80];
    }
    
    NSInteger number=self.textNumber-textView.text.length;
    UILabel*numberLabel=[self.view viewWithTag:3];
    numberLabel.text=[NSString stringWithFormat:@"%ld",(long)number];

}


-(void)touchComplete{
    if ([self.delegate respondsToSelector:@selector(DelegateForGetSignature:)]) {
        UITextView*textView=[self.view viewWithTag:2];
        [self.delegate DelegateForGetSignature:textView.text];
        [UserSession instance].personality = textView.text;
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
