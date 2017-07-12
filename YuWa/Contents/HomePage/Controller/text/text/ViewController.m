//
//  ViewController.m
//  text
//
//  Created by double on 17/4/20.
//  Copyright © 2017年 double. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for(int i = 0;i<5; i++){
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(50,50+i*10, 10, 10);
        btn.backgroundColor = [UIColor redColor];
        
        [self.view addSubview:btn];
    }
//    UIButton *button1 = [UIButton buttonWithType:];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
