//
//  YWOtherSeePersonCenterViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWOtherSeePersonCenterViewController.h"
#import "PersonCenterZeroCell.h"    //个性留言
#import "PCBottomTableViewCell.h"   //底部4种可能的cell
#import "RBHomeCollectionViewCell.h"
#import "CommentTableViewCell.h"//评论的cell

#import "OtherPersonCenterModel.h"   //一开始返回的数据
#import "RBHomeModel.h"                   //笔记
#import "RBCenterAlbumModel.h"           //专辑
#import "CommentModel.h"   //评论的model

#import "defineButton.h"      //关注那一块
#import "YJSegmentedControl.h" //笔记 专辑  评论 影评
#import "JWTools.h"

#import "YWFansViewController.h"   //粉丝
#import "MyAlbumViewController.h"
#import "RBNodeShowViewController.h"
#import "YWShoppingDetailViewController.h"
#import "YWmarkNameViewController.h"//备注


#define SECTION0CELL  @"cell"    //默认cell
#define CELL0         @"PersonCenterZeroCell"
#define HEADERVIEWHEIGHT   195     //头视图的高度

@interface YWOtherSeePersonCenterViewController ()<PCBottomTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate>
@property (nonatomic, copy) NSString *path;
@property(nonatomic,strong)UIView*belowImageViewView;   //图片下面的视图
@property(nonatomic,strong)UIView*headerView;   //头视图
@property(nonatomic,strong)UIButton*FriendButton;        //好友按钮
@property(nonatomic,strong)UIButton*followButton;        //关注按钮
@property (nonatomic,strong)RBHomeCollectionViewCell * heighCell;   //cell计算高度
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,assign)NSInteger whichShow;
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,strong) OtherPersonCenterModel*HeaderModel;   //这个model 用来给头赋值的
@property(nonatomic,strong)NSMutableArray * maMallDatas;
@property(nonatomic,assign)showViewCategory showWhichView;    //点击的是那个view
//背景图片
@property (nonatomic, strong) UIImageView *headerImageView;
//背景图片的frame
@property (nonatomic, assign) CGRect  headerImageFrame;
//姓名
@property (nonatomic, strong) UILabel * nameLabel;//个人用户名称

//修改后的昵称
@property (nonatomic,strong)NSString * nicknameStr;
@end

@implementation YWOtherSeePersonCenterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
        //只是为了得到cell 高度
    self.heighCell = [[[NSBundle mainBundle]loadNibNamed:@"RBHomeCollectionViewCell" owner:nil options:nil]firstObject];

    
    self.view.backgroundColor=[UIColor whiteColor];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SECTION0CELL];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    
    
    [self setUpMJRefresh];
    [self getDatas];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title=@"";
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];

}

-(void)viewWillDisappear:(BOOL)animated{
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    MyLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    CGFloat yoffset=scrollView.contentOffset.y;
    if (yoffset<0) {
        CGRect frame = self.headerImageView.frame;
        frame.origin.x = self.headerImageFrame.origin.x +yoffset/2;
        frame.origin.y=  yoffset ;
        frame.size.height = -yoffset+self.headerImageFrame.size.height;
        frame.size.width = self.headerImageFrame.size.width/self.headerImageFrame.size.height*frame.size.height;
        //改变头部视图的fram
        MyLog(@"~~~~~~!!!!!!!%@",NSStringFromCGRect(frame));
        self.headerImageView.frame= frame;
    }
    
    if (yoffset>=HEADERVIEWHEIGHT-64&&yoffset<=HEADERVIEWHEIGHT) {
        self.navigationItem.title=self.nickName;
        if ([JWTools isNumberWithStr:self.nickName]) {
            NSString * name = [self.nickName substringToIndex:7];
            self.navigationItem.title = [NSString stringWithFormat:@"%@****",name];
        }
        CGFloat alpha=(yoffset-(HEADERVIEWHEIGHT-64))/64;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];
        
        
    }else if (yoffset<HEADERVIEWHEIGHT-64){
        self.navigationItem.title=@"";
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
        
    }else{
        self.navigationItem.title=self.nickName;
        if ([JWTools isNumberWithStr:self.nickName]) {
            NSString * name = [self.nickName substringToIndex:7];
            self.navigationItem.title = [NSString stringWithFormat:@"%@****",name];
        }
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
        
    }
    
    
}


#pragma mark  --UI
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:SECTION0CELL];
    if (indexPath.section==0&&indexPath.row==0) {
        //个性签名
        PersonCenterZeroCell*  cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        NSString*str=self.HeaderModel.mark;
        cell.titleString=str;
        cell.selectionStyle=NO;
        
        
        return cell;
    }else if (indexPath.section==1&&indexPath.row==0){
        //笔记的内容
        NSMutableArray*array=self.maMallDatas;
        PCBottomTableViewCell*cell;
        if (self.showWhichView<=1) {
            cell=[[PCBottomTableViewCell alloc]initWithOtherStyle:UITableViewCellStyleValue1 reuseIdentifier:nil andDatas:array andWhichCategory:self.showWhichView];
        }else{
            cell=[[PCBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil andDatas:array andWhichCategory:self.showWhichView];
        }
        cell.delegate = self;
        cell.selectionStyle=NO;
        return cell;

        
        
        
     
        
    }
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        NSString*str=@"查看他人的个人中心";
        
        return [PersonCenterZeroCell CalculateCellHeight:str];
        
    }else if (indexPath.section==1&&indexPath.row==0){
        //笔记  专辑 评论 影评
        //分所选的区域的
        //        return 1000;
        if (self.showWhichView==showViewCategoryNotes) {
            NSMutableArray*alldatas=self.maMallDatas;
            __block CGFloat rightRowHeight = 0.f;
            __block CGFloat leftRowHeight = 0.f;
            [alldatas enumerateObjectsUsingBlock:^(RBHomeModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (model.cellHeight < 10.f){
                    self.heighCell.model = model;
                    model.cellHeight = self.heighCell.cellHeight;
                }
                if (rightRowHeight < leftRowHeight) {
                    rightRowHeight += model.cellHeight + 10.f;
                }else{
                    leftRowHeight += model.cellHeight + 10.f;
                }
            }];
            
            return (rightRowHeight>leftRowHeight?rightRowHeight:leftRowHeight)+10.f;
            
        }else if (self.showWhichView==showViewCategoryAlbum){
            NSMutableArray*alldatas=self.maMallDatas;
            CGFloat height = 180.f - 55.25f + (kScreen_Width - 20.f - 75.f)/4;
            return (height+10)*alldatas.count +10.f;
            
            
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
            
        }
        

        
    }
    return 44;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        //4个按钮
    
        NSString*aa=[NSString stringWithFormat:@"笔记*%@",self.HeaderModel.note_nums];
        NSString*bb=[NSString stringWithFormat:@"专辑*%@",self.HeaderModel.album_nums];
        NSString*cc=[NSString stringWithFormat:@"评论*%@",self.HeaderModel.comment_nums];
        NSMutableArray*titleArray=[NSMutableArray array];
        [titleArray addObject:aa];
        [titleArray addObject:bb];
        [titleArray addObject:cc];

        YJSegmentedControl*view=[YJSegmentedControl segmentedControlFrame:CGRectMake(0, 0, kScreen_Width, 44) titleDataSource:titleArray backgroundColor:[UIColor whiteColor] titleColor:CsubtitleColor titleFont:[UIFont systemFontOfSize:14] selectColor:CNaviColor buttonDownColor:CNaviColor Delegate:self];
        return view;
        
        
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 44;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section==1?0.001f:10;
}

-(void)addHeaderView{
    
    UIImageView*imageView=[[UIImageView alloc]init];
    imageView.image=[UIImage imageNamed:@"otherPersonImage"];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    
    
     imageView.frame=CGRectMake(0, 0, kScreen_Width, ACTUAL_HEIGHT(300));
    self.headerImageView = imageView;
    self.headerImageFrame = imageView.frame;
     self.belowImageViewView=[[UIView alloc]initWithFrame:CGRectMake(0, HEADERVIEWHEIGHT-ACTUAL_HEIGHT(300), kScreen_Width, ACTUAL_HEIGHT(300))];

    
    
    [self.belowImageViewView addSubview:imageView];
    
    
    self.headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, HEADERVIEWHEIGHT)];
    self.headerView.backgroundColor=[UIColor blackColor];
    
    [self.headerView addSubview:self.belowImageViewView];
    
    self.tableView.tableHeaderView=self.headerView;
    
    //图片界面装在 上面
    UIView*showView= [[NSBundle mainBundle]loadNibNamed:@"PersonCenterHeadView" owner:nil options:nil].firstObject;
    showView.frame=CGRectMake(0, 0, kScreen_Width, HEADERVIEWHEIGHT);
    showView.backgroundColor=[UIColor clearColor];
    [self.headerView addSubview:showView];
    
    
    UIImageView*headImageView=[showView viewWithTag:1];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.HeaderModel.header_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    //昵称
    UILabel*nameLabel=[showView viewWithTag:2];
    nameLabel.text=self.HeaderModel.nickname;
    
//    if ([JWTools isNumberWithStr:self.HeaderModel.nickname]) {
//        NSString * name = [self.HeaderModel.nickname substringToIndex:7];
//        nameLabel.text = [NSString stringWithFormat:@"%@****",name];
//    }
    self.nameLabel = nameLabel;
    // 地点
    UILabel*locateLabel=[showView viewWithTag:3];
    locateLabel.text=self.HeaderModel.address;
    // 备注按钮 默认是隐藏的
    UIButton*markBtn=[showView viewWithTag:80];
    [markBtn addTarget:self action:@selector(markBtn:) forControlEvents:UIControlEventTouchDown];
    markBtn.hidden = YES;
    
   //创建两个按钮 关注和加好友
    UIButton*PersonInfo=[showView viewWithTag:4]; //个人资料
    PersonInfo.hidden=YES;
    UIButton*follow=[showView viewWithTag:5];//取消关注 
    follow.hidden=NO;
    self.followButton=follow;
    UIButton*friend=[showView viewWithTag:6]; //加好友
    friend.hidden=NO;
    self.FriendButton=friend;

    [follow setTitle:@"关注" forState:UIControlStateNormal];
    [follow setTitle:@"取消关注" forState:UIControlStateSelected];
    //获取plist 文件中的好友名称l
    NSMutableArray * arr  =[[ NSMutableArray alloc]initWithContentsOfFile:self.path];
//    判断是否是好友
    
    if ([arr containsObject:self.HeaderModel.nickname]) {
        //表示是好友，所以添加好友按钮要隐藏掉
        friend.hidden = YES;
        //是好友，就显示可备注好友的按钮
        markBtn.hidden = NO;
    }
    [friend setTitle:@"加好友" forState:UIControlStateNormal];
    [friend setTitle:@"等待验证" forState:UIControlStateSelected];
    

    [follow addTarget:self action:@selector(addGuanzhu:) forControlEvents:UIControlEventTouchUpInside];
    
    [friend addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    //一开始没有关注
    if ([self.HeaderModel.is_fans isEqualToString:@"0"]) {
        //没有关注的  显示关注
        follow.selected=NO;
    }else{
        follow.selected=YES;
    }
    
   

    
    NSMutableArray*fourArray=[NSMutableArray array];
      [fourArray addObject:@[@"关注",self.HeaderModel.attentioncount]];
    [fourArray addObject:@[@"粉丝",self.HeaderModel.fans]];
    [fourArray addObject:@[@"被赞",self.HeaderModel.praised]];
    [fourArray addObject:@[@"被收藏",self.HeaderModel.collected]];

    for (int i=0; i<4; i++) {
        defineButton*button=[showView viewWithTag:11+i];
        [button addTarget:self action:@selector(touchFourButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.topLabel.text=fourArray[i][0];
        button.bottomLabel.text=fourArray[i][1];
        
        
        
        if (i==3) {
            button.VlineView.hidden=YES;
        }
        
        
    }
    
    
}

#pragma mark  --delegate
-(void)DelegateForNote:(NSInteger)number{
    number++;
    RBNodeShowViewController * vc = [[RBNodeShowViewController alloc]init];
    vc.model = self.maMallDatas[number];
    [self.navigationController pushViewController:vc animated:NO];
    
}

//备注按钮触发
#pragma mark ---- 备注按钮触发
-(void)markBtn:(UIButton * )btn{
    YWmarkNameViewController * vc = [[UIStoryboard storyboardWithName:@"YWmarkNameViewController" bundle:nil]instantiateInitialViewController] ;
    [self.navigationController pushViewController: vc animated:YES];
    //修改备注回调昵称
    WEAKSELF;
    vc.nickName = ^(NSString * nickName ){
        [weakSelf chanegMarkName:nickName];
        weakSelf.nicknameStr = nickName;
    };
}
-(void)chanegMarkName:(NSString *)name{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SEEOTHEREMARKNAME];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_uid":self.uid,@"user_type":@(1),@"friend_remark":name};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"！！！！%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            NSDictionary*dict=data[@"data"];
            self.nameLabel.text = dict[@"nickname"];
            [JRToast showWithText:@"备注修改成功"];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
    }];
}

-(void)DelegateForAlbum:(NSInteger)number andMax:(NSInteger)maxNumber{
    MyAlbumViewController*vc=[[MyAlbumViewController alloc]init];
    vc.otherUserID = self.uid;
    vc.otherUserIcon = self.otherIcon;
    vc.otherUserName = self.nickName;
    RBCenterAlbumModel * model = self.maMallDatas[number];
    vc.albumDetail = model.aldumID;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)segumentSelectionChange:(NSInteger)selection{
//    MyLog(@"%ld",(long)selection);
    self.whichShow=selection;
    
    self.showWhichView=selection;
    [self.tableView.mj_header beginRefreshing];
}
- (void)DelegateForToShopDetail:(NSString *)shopid{
    YWShoppingDetailViewController * vc = [[YWShoppingDetailViewController alloc]init];
    vc.shop_id = shopid;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  --touch

-(void)touchFourButton:(UIButton*)sender{
    NSInteger number =sender.tag-11;
//    MyLog(@"%lu",number);
    switch (number) {
        case 0:{
            //关注
            YWFansViewController*vc=[[YWFansViewController alloc]init];
            vc.whichFriend=TheFirendsTaAbount;
            vc.other_uid = [self.uid integerValue];
            [self.navigationController pushViewController:vc animated:YES];
     
            break;}
        case 1:{
            //粉丝
            YWFansViewController*vc=[[YWFansViewController alloc]init];
            vc.whichFriend=TheFirendsTaFans;
            vc.other_uid = [self.uid integerValue];
            [self.navigationController pushViewController:vc animated:YES];
            break;}
        case 2:{
            //无
            
            break;}
        case 3:{
            //无
            
            break;}
    
        default:
            break;
    }
}
-(void)addGuanzhu:(UIButton*)sender{
    //加关注
  
    if (sender.selected) {
        //取消关注接口
        [self ButtonCancelAbount];
    }else{
        //加上关注接口
        [self ButtonAddAbount];
    }
}
-(void)addFriend:(UIButton*)sender{
    //加好友
    if (sender.selected) {
        return;
    }else{
        sender.selected=YES;
        EMError *error = [[EMClient sharedClient].contactManager addContact:self.HeaderModel.username message:@"我想加您为好友"];
        if (!error) {
            MyLog(@"添加成功");
        }else{
            sender.selected=NO;
        }
    }
    
}
//个人资料设置
-(void)touchPersonInfo{
}
-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=0;
    self.maMallDatas=[NSMutableArray array];
    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.maMallDatas=[NSMutableArray array];
        [self getBottomDatas];
        
    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getBottomDatas];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
    
}
#pragma mark  --  getDatas

-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SEEOTHERCENTER];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_uid":self.uid,@"user_type":@(1),@"auser_type":self.user_type};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"！！！！%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            NSDictionary*dict=data[@"data"];
            self.HeaderModel=[OtherPersonCenterModel yy_modelWithDictionary:dict];
          
//            [self.tableView.tableHeaderView reloadInputViews];
            [self addHeaderView];

            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
}


#pragma mark  -- 其他接口
//得到底部的数据
- (NSMutableArray*)getBottomDatas{
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
            [self getCommit];
            break;}
            
        default:
            break;
    }
    
    
    
    
    return nil;
}


//底部的数据   笔记
-(void)getMyNotes{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([self.uid integerValue]),@"pagen":[NSString stringWithFormat:@"%d",self.pagen],@"pages":[NSString stringWithFormat:@"%d",self.pages],@"user_type":@(1)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Other_Node withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        for (NSDictionary*dict in responsObj[@"data"]) {
            NSMutableDictionary * dataDic = [RBHomeModel dataDicSetWithDic:dict];
            [self.maMallDatas addObject:[RBHomeModel yy_modelWithDictionary:dataDic]];
        }
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [JRToast showWithText:responsObj[@"errorMessage"]];
    }];
}

//得到专辑的内容
-(void)getMyAlbum{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([self.uid integerValue]),@"pagen":[NSString stringWithFormat:@"%d",self.pagen],@"pages":[NSString stringWithFormat:@"%d",self.pages]};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Other_Aldum withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        for (NSDictionary*dict in responsObj[@"data"]) {
            RBCenterAlbumModel*model=[RBCenterAlbumModel yy_modelWithDictionary:dict];
            model.user = [[RBHomeUserModel alloc]init];
            model.user.nickname = self.nickName?self.nickName:dict[@"user_name"];
            model.desc = dict[@"info"];
            [self.maMallDatas addObject:model];
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [JRToast showWithText:responsObj[@"errorMessage"]];
    }];
}


//得到专辑的内容
-(void)getCommit{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETCOMMIT];
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([self.uid integerValue]),@"pagen":[NSString stringWithFormat:@"%d",self.pagen],@"pages":[NSString stringWithFormat:@"%d",self.pages]};

    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragram compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                
                
                CommentModel*model=[CommentModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
                
                
            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];

            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
    
    

}



#pragma mark  -- 加关注和  取消关注
-(void)ButtonCancelAbount{

    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_DELABOUT];

    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_uid":self.uid,@"user_type":@(1),@"auser_type":self.user_type};

    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"取消关注%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [JRToast showWithText:data[@"msg"]];
            self.followButton.selected = NO;
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            [self getDatas];
        }
        
        
    }];
    
    
    
    
}


-(void)ButtonAddAbount{
      //变成加为关注
  
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ADDABOUT];
    
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"attention_id":self.uid,@"user_type":@(1),@"auser_type":self.user_type};

    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"添加关注%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        [JRToast showWithText:data[@"msg"]];
        if ([errorCode isEqualToString:@"0"]) {
         
            [JRToast showWithText:data[@"msg"]];
              self.followButton.selected=YES;
            //关注好友成功之后，自动添加对方好友
            [self addFriend:self.FriendButton];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
             [self getDatas];
        }
        
        
    }];
    
    
    
    
}






#pragma mark  --set get
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
    
}
-(NSString *)path{
    if (!_path) {
        _path  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        _path = [_path stringByAppendingPathComponent:@"isFriends.plist"];
    }
    return _path;
}

@end
