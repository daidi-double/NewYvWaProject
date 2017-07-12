//
//  ScheduleViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/18.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleTableViewCell.h"
#import "scheduleTwoTableViewCell.h"
#import "ScheduleTextFieldTableViewCell.h"
#import "PickerChoiceView.h"  //人数选择
#import "MHDatePicker.h"    //时间选择
#import "JWTools.h"

#define CELL0   @"ScheduleTableViewCell"
#define CELL1   @"scheduleTwoTableViewCell"
#define CELL2   @"ScheduleTextFieldTableViewCell"


@interface ScheduleViewController ()<UITableViewDelegate,UITableViewDataSource,TFPickerDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property (strong, nonatomic) MHDatePicker *selectTimePicker;

@property(nonatomic,strong)NSString*personNumber;
@property(nonatomic,strong)NSString*scheduleTime;
@property(nonatomic,strong)NSString*scheduleSex;

@property(nonatomic,strong)NSString*scheduleName;
@property(nonatomic,strong)UITextField*scheduleNameLabel; //预订人的名字

@property(nonatomic,strong)NSString*schedulePhone;
@property(nonatomic,strong)UITextField*schedulePhoneLabel;//预订人的电话

@property(nonatomic,strong)NSString*scheduleContent;
@property(nonatomic,strong)UITextField*scheduleContentLabel;//预订人的内容

@property(nonatomic,assign)BOOL canSave;
@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.title=@"预约";
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else if (section==1){
        return 2;
    }else{
        return 1;
    }
  }

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=NO;
    
    if (indexPath.section==0&&indexPath.row==0) {
        //人数
       ScheduleTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
          cell.selectionStyle=NO;
        cell.titleLabel.text=@"人数";
        cell.detailLabel.text=@"";
        
        return cell;
    }else if (indexPath.section==0&&indexPath.row==1){
        //时间
       ScheduleTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.selectionStyle=NO;
        cell.titleLabel.text=@"时间";
        cell.detailLabel.text=@"";
        
        return cell;

    }else if (indexPath.section==1&&indexPath.row==0){
        //姓名选择
       scheduleTwoTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        cell.selectionStyle=NO;
        
        self.scheduleNameLabel=cell.nameTextfield;
        
       cell.nameTextfield.placeholder=@"您的姓名";
        cell.touchSelectedSexBlock=^(NSString*str){
//            MyLog(@"11%@",str);
            self.scheduleSex=str;
        };
        
        return cell;
    }else if (indexPath.section==1&&indexPath.row==1){
        //手机号
       ScheduleTextFieldTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:CELL2];
        cell.selectionStyle=NO;
        
        cell.textField.placeholder=@"请输入预订人手机号";
        self.schedulePhoneLabel=cell.textField;
        
        return cell;
    }else if (indexPath.section==2&&indexPath.row==0){
        //留言内容
       ScheduleTextFieldTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:CELL2];
        cell.selectionStyle=NO;
        
        cell.textField.placeholder=@"如有附加要求，可填写，我们会尽量安排";
        self.scheduleContentLabel=cell.textField;
        return cell;
        
    }
    
    cell.textLabel.text=@"6666";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        //选择人数
         PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
         picker.delegate = self;
        picker.arrayType = PersonNumberArray;
        [self.view addSubview:picker];
        
        
        
    }else if (indexPath.section==0&&indexPath.row==1){
         //时间
        _selectTimePicker = [[MHDatePicker alloc] init];
        __weak typeof(self) weakSelf = self;
        [_selectTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
            
        NSString*str = [weakSelf dateStringWithDate:selectedDate DateFormat:@"MM月dd日 HH:mm"];
        weakSelf.scheduleTime=str;
            ScheduleTableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
            cell.detailLabel.text=weakSelf.scheduleTime;
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return 0.01;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 60;
    }
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==2) {
        UIView*backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
        backView.backgroundColor=[UIColor clearColor];
        
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(15, 10, kScreen_Width-30, 40)];
        [button setTitle:@"提交预定" forState:UIControlStateNormal];
        button.backgroundColor=CNaviColor;
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(touchButton) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        return backView;
    }
    return nil;
}



#pragma mark  -- touch
-(void)touchButton{
    _canSave=YES;
    NSString*str=[self judgeSave];
    if (!_canSave) {
        [JRToast showWithText:str];
        return;
    }
    //接口
    self.scheduleName=self.scheduleNameLabel.text;
    self.schedulePhone=self.schedulePhoneLabel.text;
    self.scheduleContent=self.scheduleContentLabel.text;
    NSInteger sexNum;
    if ([self.scheduleSex isEqualToString:@"先生"]) {
        sexNum=1;
    }else{
        sexNum=2;
    }
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_SCHEDULE];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"shop_id":self.shopid,@"customer_phone":self.schedulePhone,@"customer_num":self.personNumber,@"customer_message":self.scheduleContent,@"customer_time":self.scheduleTime,@"push_title":@"预定消息",@"push_content":@"新的预定信息",@"customer_name":self.scheduleName,@"customer_sex":@(sexNum)};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        // json数据或者NSDictionary转为NSData，responseObject为json数据或者NSDictionary
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"!!!!!!!%@", jsonStr);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [JRToast showWithText:data[@"msg"]];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
    }];
}

-(NSString*)judgeSave{
    if (!self.personNumber) {
        _canSave=NO;
        return @"请选择人数";
    }else if (!self.scheduleTime){
        _canSave=NO;
        return @"请选择时间";
        
    }else if (!self.scheduleSex){
        _canSave=NO;
        return @"请选择性别";
    }else if (self.scheduleNameLabel.text.length<1){
        _canSave=NO;
        return @"请输入姓名";
    }else if (self.schedulePhoneLabel.text.length!=11){
        _canSave=NO;
        return @"请正确填写你的手机号";
    }else if (self.scheduleContentLabel.text.length<1){
        _canSave=NO;
        return @"请输入留言";
    }
    
    return @"";
}

#pragma mark  --delegate
- (void)PickerSelectorIndixString:(NSString *)str{
    ScheduleTableViewCell* cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.personNumber=str;
    cell.detailLabel.text=str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  -- tools
- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

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
#pragma mark  -- set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
        [_tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
        [_tableView registerNib:[UINib nibWithNibName:CELL2 bundle:nil] forCellReuseIdentifier:CELL2];
    }
    return _tableView;
}
-(void)dealloc{
    
}
@end
