//
//  VIPPersonCenterViewController.m
//  NewVipxox
//
//  Created by 黄佳峰 on 16/9/7.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "VIPPersonCenterViewController.h"
#import "PersonCenterZeroCell.h"
#import "PersonCenterOneCell.h"
#import "PersonCenterHeadView.h"
#import "PCBottomTableViewCell.h"   //底部4种可能的cell
#import "YWBaoBaoViewController.h"
#import "ShopDetailViewController.h"   //店铺详情

#import "defineButton.h"
#import "imageDefineButton.h"
#import "YJSegmentedControl.h"
#import "JWTools.h"
#import "RBHomeModel.h"                   //笔记
#import "RBCenterAlbumModel.h"           //专辑   可能没用
#import "CommentModel.h"                //评论接口
#import "RBHomeModel.h"
#import "YWLoginViewController.h"

#import "RBHomeCollectionViewCell.h"

#import "CommentTableViewCell.h"//评论的cell
#import "CommitViewModel.h"   //评论的model





#import "YWOtherSeePersonCenterViewController.h"   //他人查看别人的个人中心
#import "YWFansViewController.h"      //粉丝 关注
#import "YWPersonInfoViewController.h"    //修改个人资料
#import "AccountSettingViewController.h"    //系统设置
#import "TZImagePickerController.h"  //照相机
#import "RBNodeShowViewController.h"  //小红书展示视图
#import "YWNodeAddAldumViewController.h"   //新建专辑 界面
#import "MyAlbumViewController.h"          //退出我的专辑页面



#import "PCPacketViewController.h"    //钱包
#import "CouponViewController.h"     //优惠券
#import "PCMyOrderViewController.h"    //我的订单
#import "MyFavouriteViewController.h"   //我的收藏
#import "PCPayRecordViewController.h"   //消费记录
#import "CommonUserViewController.h"    //非商务会员
#import "YWBusinessMemberViewController.h"   //商务会员
#import "YWMessageNotificationViewController.h"   //通知
//#import "YWInfoViewController.h"      //通知
#import "PCDetailMoneyViewController.h"

#define SECTION0CELL  @"cell"
#define CELL0         @"PersonCenterZeroCell"
#define CELL1         @"PersonCenterOneCell"


#define HEADERVIEWHEIGHT   195     //头视图的高度


@interface VIPPersonCenterViewController()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate,PCBottomTableViewCellDelegate,TZImagePickerControllerDelegate>

@property(nonatomic,strong)UIView*belowImageViewView;   //图片下面的视图
@property(nonatomic,strong)UIView*headerView;   //头视图
@property (nonatomic, strong) UIImageView *headerImageView;
@property(nonatomic,strong)YJSegmentedControl*segmentedControl;

@property(nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)RBHomeCollectionViewCell * heighCell;   //collectionView 的cell

@property (nonatomic,copy)NSString * newsToday_money;
@property(nonatomic,assign)NSInteger whichShow;   // 0笔记 1专辑 2评论
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,strong)NSMutableArray*maMallDatas;  //所有数据
@property (nonatomic, assign) CGRect headerViewFrame;

@end

@implementation VIPPersonCenterViewController

-(void)viewDidLoad{
    
    //
    self.showWhichView=showViewCategoryNotes;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    self.heighCell = [[[NSBundle mainBundle]loadNibNamed:@"RBHomeCollectionViewCell" owner:nil options:nil]firstObject];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SECTION0CELL];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    
    [self.tableView registerClass:[PersonCenterOneCell class] forCellReuseIdentifier:CELL1];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"";
    //    [self.navigationController setNavigationBarHidden:YES animated:YES]
    [UIView animateWithDuration:0.3 animations:^{
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    }];
    
    UIBarButtonItem*rightIte=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"center_set"] style:UIBarButtonItemStylePlain target:self action:@selector(touchRightItem)];
    self.navigationItem.rightBarButtonItem=rightIte;
    
    [self addHeaderView];
    [self setUpMJRefresh];
    [self getNewBaseInfo];
    //    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
}


#pragma mark   --- 滚动视图
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yoffset=scrollView.contentOffset.y;
    if (yoffset<0) {
        CGRect frame = self.headerImageView.frame;
        frame.origin.x = self.headerViewFrame.origin.x +yoffset/2;
        frame.origin.y=  yoffset ;
        frame.size.height = -yoffset+self.headerViewFrame.size.height;
        frame.size.width = self.headerViewFrame.size.width/self.headerViewFrame.size.height*frame.size.height;
        //改变头部视图的fram
        //        MyLog(@"~~~~~~!!!!!!!%@",NSStringFromCGRect(frame));
        self.headerImageView.frame= frame;
    }
    
    //    MyLog(@"%@~~~~~~~~~~",NSStringFromCGPoint(scrollView.contentOffset));
    if (yoffset>=HEADERVIEWHEIGHT-64&&yoffset<=HEADERVIEWHEIGHT) {
        
        CGFloat alpha=(yoffset-(HEADERVIEWHEIGHT-64))/64;
        self.navigationItem.title=[UserSession instance].nickName;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];
        
        
    }else if (yoffset<HEADERVIEWHEIGHT-64){
        
        self.navigationItem.title=@"";
        //        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
        
    }else{
        self.navigationItem.title=[UserSession instance].nickName;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
        
    }
    
}



#pragma mark  --UI
-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=0;
    self.maMallDatas=[NSMutableArray array];
    WEAKSELF;
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        weakSelf.pages=0;
        weakSelf.maMallDatas=[NSMutableArray array];
        [weakSelf getBottomDatas];
        
    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        weakSelf.pages++;
        [weakSelf getBottomDatas];
        
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:SECTION0CELL];
    if (indexPath.section==0&&indexPath.row==0) {
        PersonCenterZeroCell*  cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.selectionStyle=NO;
        
        NSString*str=[UserSession instance].personality;
        
        cell.titleString=str;
        
        return cell;
    }else if (indexPath.section==1&&indexPath.row==0){
        //8个 按钮
        PersonCenterOneCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        cell.selectionStyle=NO;
        NSArray*array=@[@"钱包",@"优惠券",@"雨娃宝宝",@"商务会员",@"我的订单",@"收藏",@"收支明细",@"通知"];
        NSArray*imageArray=@[@"home_01",@"home_02",@"home_03",@"home_04",@"home_05",@"home_06",@"home_07",@"home_08"];
        
        
        for (int i=0; i<8; i++) {
            imageDefineButton*button=[cell viewWithTag:i+200];
            [button addTarget:self action:@selector(touchEightButton:) forControlEvents:UIControlEventTouchUpInside];
            button.topImageView.image=[UIImage imageNamed:imageArray[i]];
            button.bottomLabel.text=array[i];
            
            
        }
        
        
        
        return cell;
    }else if (indexPath.section==2&&indexPath.row==0){
        //笔记的内容
        NSMutableArray*array=self.maMallDatas;
        
        
        PCBottomTableViewCell*cell=[[PCBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil andDatas:array andWhichCategory:self.showWhichView];
        cell.delegate=self;
        cell.selectionStyle=NO;
        return cell;
        
        
    }
    
    
    
    cell.textLabel.text=@"6666";
    return cell;
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2) {
        //4个按钮
        NSString*aa=[NSString stringWithFormat:@"笔记*%@",[UserSession instance].note_nums];
        NSString*bb=[NSString stringWithFormat:@"专辑*%@",[UserSession instance].album_nums];
        NSString*cc=[NSString stringWithFormat:@"评论*%@",[UserSession instance].comment_nums];
        
        NSArray*titleArray=@[aa,bb,cc];
        
        if (!self.segmentedControl) {
            
            self.segmentedControl=[YJSegmentedControl segmentedControlFrame:CGRectMake(0, 0, kScreen_Width, 44) titleDataSource:titleArray backgroundColor:[UIColor whiteColor] titleColor:CsubtitleColor titleFont:[UIFont systemFontOfSize:14] selectColor:CNaviColor buttonDownColor:CNaviColor Delegate:self];
            
            
        }
        
        [self.segmentedControl changeButtonName:titleArray];
        
        return self.segmentedControl;
        
        
    }
    return nil;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        NSString*str=[UserSession instance].personality;
        
        return [PersonCenterZeroCell CalculateCellHeight:str];
        
    }else if (indexPath.section==1&&indexPath.row==0){
        return 157;
    }else if (indexPath.section==2&&indexPath.row==0){
        //分所选的区域的
        //        return 1000;
        if (self.showWhichView==showViewCategoryNotes) {
            //            NSMutableArray*alldatas=[self getBottomDatas];
            NSMutableArray*alldatas=self.maMallDatas;
            __block CGFloat rightRowHeight = 0.f;
            __block CGFloat leftRowHeight = ACTUAL_HEIGHT(170);
            [alldatas enumerateObjectsUsingBlock:^(RBHomeModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (model.cellHeight < 10.f){
                    self.heighCell.model = model;
                    model.cellHeight = self.heighCell.cellHeight;
                }
                if (rightRowHeight<leftRowHeight) {
                    rightRowHeight += model.cellHeight + 10.f;
                }else{
                    leftRowHeight += model.cellHeight + 10.f;
                }
            }];
            
            return rightRowHeight>leftRowHeight?rightRowHeight:leftRowHeight;
            
            //            return 1000;
            
        }else if (self.showWhichView==showViewCategoryAlbum){
            //            NSMutableArray*alldatas=[self getBottomDatas];
            NSMutableArray*alldatas=self.maMallDatas;
            CGFloat height = 180.f - 55.25f + (kScreen_Width - 20.f - 75.f)/4;
            return (height+10)*(alldatas.count+1);
            
            
        }else if (self.showWhichView==showViewCategoryCommit){
            //评论
            CGFloat cellHeight=0.f;
            //            NSMutableArray*alldatas=[self getBottomDatas];
            NSMutableArray*alldatas=self.maMallDatas;
            
            for (int i=0; i<alldatas.count; i++) {
                CommentModel*model=alldatas[i];
                
                cellHeight=cellHeight+10+60+ [CommentTableViewCell getCellHeight:model];
            }
            
            return cellHeight;
            
            //            return 2000;
            
        }
        
        
        
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==2) {
        return 44;
    }
    return 0.01;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(NSArray*)animationImages{
    
    NSMutableArray*imageArrays=[NSMutableArray array];
    for (int i=0; i<60; i++) {
        NSString*imageName=[NSString stringWithFormat:@"波浪个人_000%d",i];
        NSBundle*bundle=[NSBundle mainBundle];
        NSString*path=[bundle pathForResource:imageName ofType:@"png"];
        UIImage*image=[UIImage imageWithContentsOfFile:path];
        [imageArrays addObject:image];
    }
    return imageArrays;
}


-(void)addHeaderView{
    
    UIImageView*imageView=[[UIImageView alloc]init];
    //    imageView.image=[UIImage imageNamed:@"backImage"];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.animationImages=[self animationImages];
    imageView.animationDuration=3;
    imageView.animationRepeatCount=0;
    [imageView startAnimating];
    self.headerImageView = imageView;
    
    //超出的图片的高度
    //    CGFloat OTHERHEADER = ((kScreen_Width * imageView.image.size.height / imageView.image.size.width)-195);
    //HEADERVIEWHEIGHT+OTHERHEADER
    imageView.frame=CGRectMake(0, 0, kScreen_Width, ACTUAL_HEIGHT(300));
    self.headerViewFrame = self.headerImageView.frame;
    
    
    
    //    self.belowImageViewView=[[UIView alloc]initWithFrame:CGRectMake(0, -OTHERHEADER, kScreen_Width, HEADERVIEWHEIGHT+OTHERHEADER)];
    self.belowImageViewView=[[UIView alloc]initWithFrame:CGRectMake(0, HEADERVIEWHEIGHT-ACTUAL_HEIGHT(300), kScreen_Width, ACTUAL_HEIGHT(300))];
    
    
    [self.belowImageViewView addSubview:imageView];
    
    
    self.headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, HEADERVIEWHEIGHT)];
    self.headerView.backgroundColor=[UIColor blackColor];
    
    [self.headerView addSubview:self.belowImageViewView];
    
    self.tableView.tableHeaderView=self.headerView;
    
    
    //图片界面装在 上面
    PersonCenterHeadView*showView= [[NSBundle mainBundle]loadNibNamed:@"PersonCenterHeadView" owner:nil options:nil].firstObject;
    //隐藏掉备注
    UIButton * reMark = [showView viewWithTag:80];
    reMark.hidden = YES;
    showView.frame=CGRectMake(0, 0, kScreen_Width, HEADERVIEWHEIGHT);
    showView.backgroundColor=[UIColor clearColor];
    [self.headerView addSubview:showView];
    
    UIImageView*headImageView=[showView viewWithTag:1];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    showView.touchImageBlock=^{
        //        MyLog(@"点击图片放大");
        [self touchPersonInfo];
        
        
    };
    
    UIButton*PersonInfo=[showView viewWithTag:4];
    PersonInfo.hidden=NO;
    NSString* str=[NSString stringWithFormat:@"今日收益:￥%@",self.newsToday_money];
    if (self.newsToday_money == nil) {
        str = @"今日收益:￥0.00";
    }
    
    [PersonInfo setTitle:str forState:UIControlStateNormal];
    
    UIButton*follow=[showView viewWithTag:5];
    follow.hidden=YES;
    UIButton*friend=[showView viewWithTag:6];
    friend.hidden=YES;
    
    
    NSMutableArray*fourArray=[NSMutableArray array];
    if ([UserSession instance].attentionCount == nil) {
        [UserSession instance].attentionCount = @"0";
    }
    if ([UserSession instance].fans == nil) {
        [UserSession instance].fans = @"0";
    }
    if ([UserSession instance].praised == nil) {
        [UserSession instance].praised = @"0";
    }
    if ([UserSession instance].collected == nil) {
        [UserSession instance].collected = @"0";
    }
    
    [fourArray addObject:@[@"关注",[UserSession instance].attentionCount]];
    [fourArray addObject:@[@"粉丝",[UserSession instance].fans]];
    [fourArray addObject:@[@"被赞",[UserSession instance].praised]];
    [fourArray addObject:@[@"被收藏",[UserSession instance].collected]];
    
    
    for (int i=0; i<4; i++) {
        defineButton*button=[showView viewWithTag:11+i];
        [button addTarget:self action:@selector(touchFourButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.topLabel.text=fourArray[i][0];
        button.bottomLabel.text=fourArray[i][1];
        
        
        
        if (i==3) {
            button.VlineView.hidden=YES;
        }
        
        
    }
    
    //昵称
    UILabel*nameLabel=[showView viewWithTag:2];
    nameLabel.text=[UserSession instance].nickName;
    
    
    // 地点
    UILabel*locateLabel=[showView viewWithTag:3];
    locateLabel.text=[UserSession instance].local;
    
    
}



#pragma mark  --touch

-(void)touchFourButton:(UIButton*)sender{
    NSInteger number =sender.tag-11;
    //    MyLog(@"%lu",number);
    if (number==0) {
        
        // 关注
        YWFansViewController*vc=[[YWFansViewController alloc]init];
        vc.whichFriend=TheFirendsAbount;
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }else if (number==1){
        //粉丝
        YWFansViewController*vc=[[YWFansViewController alloc]init];
        vc.whichFriend=TheFirendsFans;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (number==2){
        
        //被赞
        YWFansViewController*vc=[[YWFansViewController alloc]init];
        vc.whichFriend=TheFriendsBePraise;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (number==3){
        //被收藏
        YWFansViewController*vc=[[YWFansViewController alloc]init];
        vc.whichFriend=TheFriendsBeCollected;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



-(void)touchRightItem{
    AccountSettingViewController*vc=[[AccountSettingViewController
                                      alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

//点击个人信息
-(void)touchPersonInfo{
    self.navigationController.navigationBarHidden = NO;
    YWPersonInfoViewController*vc=[[YWPersonInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//八个按钮
-(void)touchEightButton:(imageDefineButton*)sender{
    NSInteger number=sender.tag-200;
    self.navigationController.navigationBarHidden = NO;
    //    MyLog(@"%lu",number);
    switch (number) {
        case 0:{
            //钱包
            PCPacketViewController*vc=[[PCPacketViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
            break;}
        case 1:{
            //优惠券
            CouponViewController*vc=[[CouponViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;}
            
        case 2:{
            //雨娃宝宝
            YWBaoBaoViewController * vc = [[YWBaoBaoViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;}
        case 3:{
            //商务会员
            if ([[UserSession instance].isVIP isEqualToNumber:@(2)]) {
                //商务会员
                YWBusinessMemberViewController*vc=[[YWBusinessMemberViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([[UserSession instance].isVIP isEqualToNumber:@(1)]){
                CommonUserViewController*vc=[[CommonUserViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                //商务会员   3的情况也弄商务会员吧
                YWBusinessMemberViewController*vc=[[YWBusinessMemberViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
            break;}
            
        case 4:{
            //我的订单
            PCMyOrderViewController*vc=[[PCMyOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;}
            
        case 5:{
            //收藏
            MyFavouriteViewController*vc=[[MyFavouriteViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;}
            
        case 6:{
            //消费记录
            PCDetailMoneyViewController*vc=[[PCDetailMoneyViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;}
            
        case 7:{
            //通知
            YWMessageNotificationViewController *vc=[[YWMessageNotificationViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;}
            
            
        default:
            break;
    }
    
    
}

#pragma mark  --delegate
//第几个选项卡
-(void)segumentSelectionChange:(NSInteger)selection{
    //    MyLog(@"%ld",(long)selection);
    self.whichShow=selection;
    
    self.showWhichView=selection;
    [self.tableView.mj_header beginRefreshing];
    
    //    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
    
}

//笔记界面的点击方法   -1 为发布笔记
-(void)DelegateForNote:(NSInteger)number{
    if (number==-1) {
        //发布笔记
        TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        imagePickerVC.allowPickingVideo = NO;
        [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray * photos , NSArray * assets,BOOL isSelectOriginalPhoto){
            
        }];
        
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
        
    }else{
        
        RBNodeShowViewController * vc = [[RBNodeShowViewController alloc]init];
        vc.model = self.maMallDatas[number];
        [self.navigationController pushViewController:vc animated:NO];
        
        
        
        
    }
    
}


-(void)DelegateForAlbum:(NSInteger)number andMax:(NSInteger)maxNumber{
    if (number==maxNumber) {
        //专辑
        //        MyLog(@"创建专辑");
        YWNodeAddAldumViewController*vc=[[YWNodeAddAldumViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        //        MyLog(@"点击某个专辑%lu",(long)number);
        MyAlbumViewController*vc=[[MyAlbumViewController alloc]init];
        RBCenterAlbumModel * model = self.maMallDatas[number];
        vc.albumDetail = model.aldumID;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}



//需要跳转到店铺
-(void)DelegateForToShopDetail:(NSString*)shopid{
    ShopDetailViewController*vc=[[ShopDetailViewController alloc]init];
    vc.shop_id=shopid;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark  --  getDatas
//得到底部的数据
- (NSMutableArray*)getBottomDatas{
    
    //
    switch (self.whichShow) {
        case 0:{
            //笔记
            [self getMyNotes];
            break;}
        case 1:{
            //专辑
            [self getMyAlbum];
            break;}
        case 2:{
            //评论
            [self getMyCommit];
            break;}
            
        default:
            break;
    }
    
    
    
    
    return nil;
}


//底部的数据   笔记
-(void)getMyNotes{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETNOTES];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                
                NSMutableDictionary * dataDic = [RBHomeModel dataDicSetWithDic:dict];
                [self.maMallDatas addObject:[RBHomeModel yy_modelWithDictionary:dataDic]];
                
                [UserSession instance].note_nums =data[@"total_nums"];
            }
            
            [self.tableView reloadData];
            
        }else if([errorCode isEqualToString:@"9"]){
            [JRToast showWithText:@"您的身份已过期，请重新登入" duration:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                YWLoginViewController * loginVC = [[YWLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            });
            
        }else{
            
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
}

//得到专辑的内容
-(void)getMyAlbum{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETALBUMS];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                RBCenterAlbumModel*model=[RBCenterAlbumModel yy_modelWithDictionary:dict];
                model.user = [[RBHomeUserModel alloc]init];
                model.user.nickname = [UserSession instance].nickName;
                model.user.images = [UserSession instance].logo;
                [self.maMallDatas addObject:model];
                
                //有多少内容
                [UserSession instance].album_nums=data[@"total_nums"];
            }
            //            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
            
        }else if([errorCode isEqualToString:@"9"]){
            [JRToast showWithText:@"您的身份已过期，请重新登入" duration:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                YWLoginViewController * loginVC = [[YWLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            });
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
    
    
}


//得到我的评论
-(void)getMyCommit{
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETCOMMIT];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                
                
                CommentModel*model=[CommentModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
                
                
            }
            
            [UserSession instance].comment_nums=data[@"total_nums"];
            //            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
            
            
        }else if([errorCode isEqualToString:@"9"]){
            [JRToast showWithText:@"您的身份已过期，请重新登入" duration:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                YWLoginViewController * loginVC = [[YWLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            });
            
        }else {
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
    
}
//获取今日收益数据
-(void)getNewBaseInfo{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_GETNEWBASINFO];
    NSDictionary * prams = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:prams compliation:^(id data, NSError *error) {
        MyLog(@"信息 %@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            self.newsToday_money = data[@"data"][@"money"];
            [UserSession instance].personality = data[@"data"][@"mark"];
        }
        [self.tableView reloadData];
    }];
}


#pragma mark  --set get
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
    
}
@end
