//
//  PostCommitViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/18.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PostCommitViewController.h"
#import "PostCommitTextTableViewCell.h"
#import "PostCommitImageTableViewCell.h"
#import "TZImagePickerController.h"
#import "ImageCache.h"
#import "JWTools.h"
#import "YWShoppingDetailViewController.h"
#define CELL0   @"PostCommitTextTableViewCell"
#define CELL1   @"PostCommitImageTableViewCell"

@interface PostCommitViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,TZImagePickerControllerDelegate,PostCommitImageTableViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UILabel*showNumberLabel; //展示还剩多少个字的label

@property(nonatomic,strong)NSMutableArray*saveAllButtons;  //保存所有的button
@property(nonatomic,assign)BOOL canSave;  //能够被提交
@property(nonatomic,assign)NSInteger commitStar;  //评了多少颗星
@property(nonatomic,assign)NSInteger numberInputWord; //总共输入了多少个字
@property(nonatomic,strong)NSString*saveCommitContent;  //保存评论的内容
@property(nonatomic,strong)NSMutableArray*saveAllImage;  //保存所有的图片
@end

@implementation PostCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"发布评价";
    self.saveAllImage=[NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
//    [self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
    [self.tableView registerClass:[PostCommitImageTableViewCell class] forCellReuseIdentifier:CELL1];
    
    UIButton*rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton addTarget:self action:@selector(touchPost) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"发表" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    rightButton.backgroundColor=RGBCOLOR(252, 103, 61, 1);
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=item;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section==0) {
        PostCommitTextTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.selectionStyle=NO;
        
        cell.samTextView.placeholder=[NSString stringWithFormat:@"亲，请留下您宝贵的建议"];
        cell.samTextView.delegate=self;
        
        
        self.showNumberLabel=cell.ShowLabel;
        
        return cell;
    }
    
   
    if (indexPath.section==1) {
       PostCommitImageTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        cell.selectionStyle=NO;
        cell.delegate=self;
        
        
        [cell getDataImage:self.saveAllImage];
        
         return cell;
    }
    
    
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView*backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 72)];
        backgroundView.backgroundColor=[UIColor whiteColor];
        
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 21, 40, 30)];
        titleLabel.text=@"评分";
        titleLabel.font=[UIFont systemFontOfSize:17];
        [backgroundView addSubview:titleLabel];
        
        self.saveAllButtons=[NSMutableArray array];
        CGFloat leftValue=60;
        CGFloat withAndHeight=30;
        CGFloat jianju=10;
        
        for (int i=0; i<5; i++) {
            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(leftValue+(withAndHeight+jianju)*i, 0, withAndHeight, withAndHeight)];
            [button setCenterY:36];
            button.tag=100+i;
            [button setBackgroundImage:[UIImage imageNamed:@"home_grayStar"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_lightStar"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(touchSelectStar:) forControlEvents:UIControlEventTouchUpInside];
            [backgroundView addSubview:button];
            
            [self.saveAllButtons addObject:button];
            
        }
        
        
        return backgroundView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 72;
    }
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 200;
    }else{
//#warning 这里的告诉要根据图片的多少来的
        PostCommitImageTableViewCell*cell=[[PostCommitImageTableViewCell alloc]init];
        return [cell getCellHeightWith:self.saveAllImage];
    }
    
    
}

#pragma  mark  -- delegate
- (void)textViewDidChange:(UITextView *)textView{
    self.numberInputWord=textView.text.length;
    self.saveCommitContent=textView.text;
    MyLog(@"%@",textView.text);
    
    NSInteger chaNumber=1-self.numberInputWord;
    if (chaNumber>0) {
//        self.showNumberLabel.text=[NSString stringWithFormat:@"加油，还剩%ld个字！",(long)chaNumber];
        self.showNumberLabel.text = @"加油，还剩1个字哦！";

    }else{
        self.showNumberLabel.text=[NSString stringWithFormat:@"感谢您的指导！"];

    }
    
    
}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    
    //吊接口  照片
//    NSString *str = [ImageCache headImagePath:newPhoto];
    
    if (self.saveAllImage.count>=9) {
        [JRToast showWithText:@"最多只能传9张照片"];
        return;
    }
    [self.saveAllImage addObject:newPhoto];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    
//    NSDictionary*dict=@{@"header_img":str};
//    [self changePersonInfoWithDic:dict];
//    InfoPhotoTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    UIImageView*imageView=[cell viewWithTag:1];
//    imageView.image=newPhoto;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)delegateForTouchAddImage{


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
    
    
}

-(void)delegateForTouchDeleteImageWithTag:(NSInteger)tag{
    [self.saveAllImage removeObjectAtIndex:tag];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];

    
    
    
}


#pragma mark  --touch

-(void)touchSelectStar:(UIButton*)sender{
    NSInteger number=sender.tag;
    self.commitStar=number-99;   //多少颗星
    
    for (UIButton*button in self.saveAllButtons) {
        if (button.tag<=number) {
            [button setSelected:YES];
            
        }else{
             [button setSelected:NO];
        }
        
    }
    
    
}

-(void)touchPost{
    _canSave=YES;
    NSString*str=[self judgeCanSave];
    
    if (_canSave==NO) {
        [JRToast showWithText:str];
        return;
    }
    
    
    //如果没有图片的时候也能吊接口成功
    if (_saveAllImage.count<1) {
        [self postCommitWitharray:nil];
    }else{
    
    
    
    NSMutableArray*saveImageUrl=[NSMutableArray array];
    //接口
    for (int i=0; i<_saveAllImage.count; i++) {
        UIImage*image=self.saveAllImage[i];
        NSData*data=UIImageJPEGRepresentation(image, 1.0);
        
        NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_IMG_UP];
        HttpManager*manager=[[HttpManager alloc]init];
        [manager postUpdatePohotoWithUrl:urlStr withParams:nil withPhoto:data compliation:^(id data, NSError *error) {
            MyLog(@"%@",data);
            NSNumber*number=data[@"errorCode"];
            NSString*errorCode=[NSString stringWithFormat:@"%@",number];
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary*dict=@{@"url":data[@"data"]};
                
                [saveImageUrl addObject:dict];
                
            }else{
                [JRToast showWithText:data[@"errorMessage"]];
            }
            
            if (saveImageUrl.count==_saveAllImage.count) {
                [self postCommitWitharray:saveImageUrl];
            }
            
        }];
    
    }

    
    }
    
}

//发送评论的接口
-(void)postCommitWitharray:(NSMutableArray*)array{
    //,@"img_url":jsonStr   self.shop_id
//    CGFloat shopidFloat=[self.shop_id floatValue];
//    NSNumber*shopid=@(shopidFloat);
    NSDictionary*dictt=@{@"shop_id":self.shop_id,@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"customer_content":self.saveCommitContent  ,@"score":@(self.commitStar),@"order_id":self.order_id};
    NSMutableDictionary*params=[NSMutableDictionary dictionaryWithDictionary:dictt];
    
    if (array.count>0&&array.count==_saveAllImage.count) {
        NSData*data= [self toJSONData:array];
        NSString*jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [params setObject:jsonStr forKey:@"img_url"];

    }
    
  
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_POSTCOMMIT];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [JRToast showWithText:data[@"msg"]];

            if (self.stauts != 1) {
               [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];

            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
    }];

    
    
}

// 将字典或者数组转化为JSON串
-(NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}


-(NSString*)judgeCanSave{
    if (_commitStar==0) {
        _canSave=NO;
        return @"请选择评分";
    }else if (_numberInputWord<1){
        _canSave=NO;
        return @"您评论的字数不够";
    }
    
    return @"xxx";
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.alwaysBounceVertical=YES;
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end
