//
//  YWChooseSexView.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWChooseSexView.h"

@interface YWChooseSexView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)NSString*selectedStr;

@end
@implementation YWChooseSexView

-(YWChooseSexView*)initWithCustomeHeight:(CGFloat)height{
    self=[super initWithFrame:CGRectMake(0, 0, kScreen_Width, height=height<200?200:height)];
    if (self) {
        self.selectedStr=@"男";
        
        self.backgroundColor=[UIColor whiteColor];
        self.layer.borderWidth=1;
        self.layer.borderColor=[UIColor colorWithWhite:0 alpha:0.05].CGColor;
        
        //创建按钮
        UIButton*cannel=[UIButton buttonWithType:UIButtonTypeCustom];
        cannel.frame=CGRectMake(20, 0, 50, 40);
        [cannel setTitle:@"取消" forState:UIControlStateNormal];
        [cannel setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:0];
        cannel.tag=1;
        [cannel addTarget:self action:@selector(cannelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cannel];
        
        UIButton*confirm=[UIButton buttonWithType:UIButtonTypeCustom];
        confirm.frame=CGRectMake(kScreen_Width-70, 0, 50, 40);
        [confirm setTitle:@"确定" forState:0];
        [confirm setTitleColor:[UIColor colorWithRed:0 green:183/255.0 blue:231/255.0 alpha:1] forState:0];
        confirm.tag=2;
        [confirm addTarget:self action:@selector(cannelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirm];
        
        _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kScreen_Width, height-40)];
        _pickerView.backgroundColor=[UIColor whiteColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:_pickerView];
        
    }
    
    return self;
}


-(void)cannelOrConfirm:(UIButton*)sender{
    if (sender.tag==1) {
        self.touchCancelBlock();
        
    }else{
        self.touchConfirmBlock(self.selectedStr);
         self.touchCancelBlock();
    }
    
    
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray*array=@[@"男",@"女",@"未知"];
    return array[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
     NSArray*array=@[@"男",@"女",@"未知"];
    self.selectedStr=array[row];
    
}

@end
