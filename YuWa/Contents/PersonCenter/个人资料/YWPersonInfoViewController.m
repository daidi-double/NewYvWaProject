//
//  YWPersonInfoViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonInfoViewController.h"
#import "InfoPhotoTableViewCell.h"
#import "InfoChooseTableViewCell.h"
#import "InfoSignatureTableViewCell.h"
#import "JWTools.h"
#import "ImageCache.h"


#import "ChangeNibNameViewController.h"     //修改昵称
#import "DatePickerView.h"                //修改时间
#import "YWChooseSexView.h"       //修改性别
#import "SignatureViewController.h"        //修改个性签名

#define CELL0   @"InfoPhotoTableViewCell"
#define CELL1   @"InfoChooseTableViewCell"
#define CELL2   @"InfoSignatureTableViewCell"

@interface YWPersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ChangeNibNameViewControllerDelegate,SignatureViewControllerDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)DatePickerView*datepicker;
@property(nonatomic,strong)YWChooseSexView*pickerView;
@end

@implementation YWPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人设置";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoChooseTableViewCell" bundle:nil] forCellReuseIdentifier:CELL1];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoSignatureTableViewCell" bundle:nil] forCellReuseIdentifier:CELL2];
    [self addHeader];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.datepicker removeFromSuperview];
    self.datepicker=nil;
    [self.pickerView removeFromSuperview];
    self.pickerView=nil;
}

-(void)addHeader{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    view.backgroundColor=RGBCOLOR(245, 248, 250, 1);
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreen_Width/2, 16)];
    [label setCenterY:20];
    label.font=[UIFont systemFontOfSize:14];
    label.text=@"个人资料";
    label.textColor=CsubtitleColor;
    [view addSubview:label];
    self.tableView.tableHeaderView=view;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.selectionStyle=NO;
        UIImageView*imageView=[cell viewWithTag:1];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        
//        UILabel*subLabel=[cell viewWithTag:2];
  

        
        
        return cell;
    }else if (indexPath.row>0&&indexPath.row<8-1){
        cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        cell.selectionStyle=NO;
        
        UILabel*mainLabel=[cell viewWithTag:1];
        UILabel*subLabel=[cell viewWithTag:2];
        
        switch (indexPath.row) {
            case 1:
                mainLabel.text=@"昵称";
                subLabel.text=[UserSession instance].nickName;
                break;
            case 2:{
                mainLabel.text=@"雨娃ID";
                subLabel.text=[UserSession instance].inviteID;
                UIImageView*imageView=[cell viewWithTag:3];
                imageView.hidden=YES;}
                break;
            case 3:{
                mainLabel.text = @"邀请码";
                subLabel.text = [UserSession instance].invite_code;
            }
                break;
            case 4:{
                
                mainLabel.text=@"性别";
                subLabel.text=[UserSession instance].sex;
                break;}
            case 5:
                mainLabel.text=@"常住地";
                subLabel.text=[UserSession instance].local;
                break;
            case 6:
                mainLabel.text=@"生日";
                subLabel.text=[JWTools getTime:[UserSession instance].birthDay];
                break;
    
            default:
                break;
        }
        
        
        return cell;
    }else if (indexPath.row==8-1){
        cell=[tableView dequeueReusableCellWithIdentifier:CELL2];
        cell.selectionStyle=NO;
        
        UILabel*mainLabel=[cell viewWithTag:1];
        mainLabel.text = @"个性签名:";
        UILabel*subLabel=[cell viewWithTag:2];
        subLabel.text=[UserSession instance].personality;

        
        
        return cell;
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        //选择头像
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController*imagePicker=[[UIImagePickerController alloc]init];
            imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.allowsEditing=YES;
            imagePicker.delegate=self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
            
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController*imagePicker=[[UIImagePickerController alloc]init];
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing=YES;
            imagePicker.delegate=self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
       
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }else if (indexPath.row==1){
        //昵称
        ChangeNibNameViewController *vc=[[ChangeNibNameViewController alloc]initWithNibName:@"ChangeNibNameViewController" bundle:nil];
        vc.delegate=self;
        vc.type=TouchTypeNickName;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.row==2){
        //雨娃id  不可修改
        
        
    }else if(indexPath.row == 3){
        
    }else if (indexPath.row==4){
        //性别
       __block YWChooseSexView*pickView=[[YWChooseSexView alloc]initWithCustomeHeight:215];
        self.pickerView=pickView;
        pickView.touchConfirmBlock=^(NSString*value){
            
            //接口
            int xx;
            if ([value isEqualToString:@"男"]) {
                xx=1;
            }else if ([value isEqualToString:@"女"]){
                xx=2;
            }else if ([value isEqualToString:@"未知"]){
                xx=3;
            }
            NSDictionary*dict=@{@"sex":@(xx)};
//            NSDictionary*dict=@{@"sex":value};
            [self changePersonInfoWithDic:dict];

            
            
            InfoChooseTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            UILabel*subLabel=[cell viewWithTag:2];
            subLabel.text=value;

            
        };
        
        pickView.touchCancelBlock=^{
            [pickView removeFromSuperview];
            pickView=nil;

        };
        
        UIWindow*window=[UIApplication sharedApplication].keyWindow;
        pickView.frame=CGRectMake(0, kScreen_Height-215, kScreen_Width, 215);
        [window addSubview:pickView];

      
    }else if (indexPath.row==5){
        //常住地
        ChangeNibNameViewController *vc=[[ChangeNibNameViewController alloc]initWithNibName:@"ChangeNibNameViewController" bundle:nil];
        vc.delegate=self;
        vc.type=TouchTypeCity;
        [self.navigationController pushViewController:vc animated:YES];

        
        
    }else if (indexPath.row==6){
        //生日
      __block  DatePickerView*datePicker=[[DatePickerView alloc]initWithCustomeHeight:215];
        self.datepicker=datePicker;
       
        datePicker.confirmBlock= ^(NSString *choseDate, NSString *restDate) {
            //如果日期大于现在  return  提醒不能大于现在
            NSString*str1=choseDate;
            NSString*str2=[self getNowTime];
           int aa= [self compareDate:str1 withDate:str2];
            if (aa!=1) {
                [JRToast showWithText:@"请正确选择您的生日"];
                return ;
            }
            
            
            //接口
            NSDictionary*dict=@{@"birthday":choseDate};
            [self changePersonInfoWithDic:dict];

            
            
            
            InfoChooseTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
            UILabel*subLabel=[cell viewWithTag:2];
            subLabel.text=choseDate;

            
            
        };
        
        datePicker.cannelBlock = ^(){
            [datePicker removeFromSuperview];
            datePicker=nil;
          
            
        };
        
        UIWindow*window=[UIApplication sharedApplication].keyWindow;
        datePicker.frame=CGRectMake(0, kScreen_Height-215, kScreen_Width, 215);
        [window addSubview:datePicker];

        
    }else if (indexPath.row==7){
        //个性签名
        SignatureViewController*vc=[[SignatureViewController alloc]initWithNibName:@"SignatureViewController" bundle:nil];
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 94;
    }else if (indexPath.row==7-1){
        return 88;
    }
    
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  --  改变参数
-(void)changePersonInfoWithDic:(NSDictionary*)dict{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_CHANGEINFO];
    NSMutableDictionary*params=[NSMutableDictionary dictionary];
    [params setObject:[JWTools getUUID] forKey:@"device_id"];
    [params setObject:[UserSession instance].token forKey:@"token"];
    [params setObject:@([UserSession instance].uid) forKey:@"user_id"];
    
    //6种可能  如果是修改图片那么另一个发送方式
    if ([[dict.allKeys firstObject] isEqualToString:@"header_img"]) {
        NSData *fileData = [NSData dataWithContentsOfFile:dict.allValues.firstObject];
        
        NSString*postImageUrl=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_IMG_UP];
         HttpManager*manager=[[HttpManager alloc]init];
        [manager postUpdatePohotoWithUrl:postImageUrl withParams:nil withPhoto:fileData compliation:^(id data, NSError *error) {
            MyLog(@"%@",data);
            NSNumber*number=data[@"errorCode"];
            NSString*errorCode=[NSString stringWithFormat:@"%@",number];
            if ([errorCode isEqualToString:@"0"]) {
                
                //改变
                NSDictionary*dict=@{@"header_img":data[@"data"]};
                [params setObject:dict.allValues.firstObject forKey:dict.allKeys.firstObject];
                [manager postUpdatePohotoWithUrl:urlStr withParams:params withPhoto:fileData compliation:^(id data, NSError *error) {
                    MyLog(@"%@",data);
                    NSNumber*number=data[@"errorCode"];
                    NSString*errorCode=[NSString stringWithFormat:@"%@",number];
                    if ([errorCode isEqualToString:@"0"]) {
                        [UserSession instance].logo=dict[@"header_img"];
                    }else{
                        [JRToast showWithText:data[@"errorMessage"]];
                    }
                }];
            }else{
                [JRToast showWithText:data[@"errorMessage"]];
            }
        }];
        return;
    }
    
    
    
    //  其他的5种可能吊用
//    [params setDictionary:dict];
    [params setObject:dict.allValues.firstObject forKey:dict.allKeys.firstObject];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            if ([dict.allKeys.firstObject isEqualToString:@"nickname"]) {
                [UserSession instance].nickName=dict[@"nickname"];
            }else if ([dict.allKeys.firstObject isEqualToString:@"address"]){
                [UserSession instance].local=dict[@"address"];
            }else if ([dict.allKeys.firstObject isEqualToString:@"birthday"]){
                [UserSession instance].birthDay=dict[@"birthday"];
            }else if ([dict.allKeys.firstObject isEqualToString:@"mark"]){
                [UserSession instance].personality=dict[@"mark"];
            }else if ([dict.allKeys.firstObject isEqualToString:@"sex"]){
                NSNumber*number=dict[@"sex"];
                int aaa=[number intValue];
                NSString*strNum;
                if (aaa==3) {
                    strNum=@"未知";
                }else if (aaa==1){
                    strNum=@"男";
                }else if (aaa==2){
                    strNum=@"女";
                }
                
                [UserSession instance].sex=strNum;
            }
            
            
        }else{
            [self.tableView reloadData];
        }
        
    }];
    
    
}



#pragma mark  --delegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
   
    
    //吊接口  照片
       NSString *str = [ImageCache headImagePath:newPhoto];
    NSDictionary*dict=@{@"header_img":str};
    [self changePersonInfoWithDic:dict];
    
    
    InfoPhotoTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIImageView*imageView=[cell viewWithTag:1];
    imageView.image=newPhoto;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
       [self dismissViewControllerAnimated:YES completion:nil];
}

//修改昵称
-(void)DelegateToChangeNibName:(NSString*)name andTouchType:(TouchType)type{
//    MyLog(@"%@",name);
    if (type==TouchTypeNickName) {
        //接口
        NSDictionary*dict=@{@"nickname":name};
        [self changePersonInfoWithDic:dict];
        
        
        //昵称
        InfoChooseTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UILabel*subLabel=[cell viewWithTag:2];
        subLabel.text=name;

    }else{
        //居住地
        //接口
        NSDictionary*dict=@{@"address":name};
        [self changePersonInfoWithDic:dict];

        
        
        InfoChooseTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        UILabel*subLabel=[cell viewWithTag:2];
        subLabel.text=name;

        
        
    }
    
    
}

//修改signature
-(void)DelegateForGetSignature:(NSString *)string{
//    MyLog(@"%@",string);
    //接口
    NSDictionary*dict=@{@"mark":string};
    [self changePersonInfoWithDic:dict];

    
    InfoSignatureTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    UILabel*label=[cell viewWithTag:2];
    label.text=string;
}


#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}



#pragma mark  -- 处理
-(NSString*)getNowTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
//    NSLog(@"dateString:%@",dateString);
    
    return dateString;
}


-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}


@end
