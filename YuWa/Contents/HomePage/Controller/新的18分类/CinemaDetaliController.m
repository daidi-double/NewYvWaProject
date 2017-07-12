//
//  CinemaDetaliController.m
//  YuWa
//
//  Created by double on 17/2/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CinemaDetaliController.h"
#import "MovieShopTableViewCell.h"
#import "CinemaCharacteristicTableViewCell.h"
#import "InfomationTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CinemaDetailModel.h"
#import "CinemaLabelModel.h"//标签model

#define COMMENTCELL00  @"CommentTableViewCell"
#define INFOCELL23  @"InfomationTableViewCell"
#define CharacteristicCell  @"CinemaCharacteristicTableViewCell"
#define MOVIECELL12 @"MovieShopTableViewCell"
@interface CinemaDetaliController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * cinemaTableView;
@property (nonatomic,strong)NSMutableArray * cellDataArr;
@property (nonatomic,strong)NSMutableArray * cellImageArr;
@property (nonatomic,strong)CinemaDetailModel * cinemaDetailModel;
@end

@implementation CinemaDetaliController
- (NSMutableArray*)cellDataArr{
    if (!_cellDataArr) {
        _cellDataArr = [NSMutableArray array];
    }
    return _cellDataArr;
}
- (NSMutableArray*)cellImageArr{
    if (!_cellImageArr) {
        _cellImageArr = [NSMutableArray array];
    }
    return _cellImageArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"影院详情";
    [self makeUI];
    [self requestCinemaDetail];
    // Do any additional setup after loading the view.
}
- (void)makeUI
{
    _cinemaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
    _cinemaTableView.delegate = self;
    _cinemaTableView.dataSource = self;
    
    [_cinemaTableView registerNib:[UINib nibWithNibName:MOVIECELL12 bundle:nil] forCellReuseIdentifier:MOVIECELL12];
    [_cinemaTableView registerNib:[UINib nibWithNibName:CharacteristicCell bundle:nil] forCellReuseIdentifier:CharacteristicCell];
    [_cinemaTableView registerNib:[UINib nibWithNibName:INFOCELL23 bundle:nil] forCellReuseIdentifier:INFOCELL23];
    [_cinemaTableView registerNib:[UINib nibWithNibName:COMMENTCELL00 bundle:nil] forCellReuseIdentifier:COMMENTCELL00];
    [self.view addSubview:_cinemaTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 2;
        
    }else{
        int a= 0;
        for (CinemaLabelModel * model in self.cellDataArr) {
            if ([model.status integerValue]== 1) {
                a++;
            }
        }
        return a;//修改
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 165.f;
    }else if (indexPath.section == 1){

        if (indexPath.row == 0) {
            return 25.f;
        }else if (indexPath.row == 1){
            if ([self.cinemaDetailModel.feature_img isEqualToString:@""] || [self.cinemaDetailModel.feature_img isKindOfClass:[NSNull class]] || self.cinemaDetailModel.feature_img == nil) {
                return 0.01f;
            }else{
                return 80.f;
            }
        }else {
            return 50.f;
        }
       
    }else if (indexPath.section == 2){
        CinemaLabelModel * model;
        if (self.cellDataArr.count>0) {
            
            model = self.cellDataArr[indexPath.row];
        }
        CGRect shopNameWidth;
        if ([model.status integerValue] == 1) {
          
           shopNameWidth = [model.introduce boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
            
        }

        if (shopNameWidth.size.height <= 50.f) {
            return 50.f;
        }

            return shopNameWidth.size.height;
      
    }
    return 50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0.01f;
    }
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 0.01f;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cinemaCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cinemaCell"];
    }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cinemaTableView.separatorStyle = NO;
    if (indexPath.section == 0) {
        MovieShopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MOVIECELL12];
        cell.cinemaDetailModel = self.cinemaDetailModel;
        return cell;
        
        
    }else if(indexPath.section ==1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"影院特色";
            cell.textLabel.textColor = RGBCOLOR(123, 124, 125, 1);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }else if(indexPath.row == 1) {
              if ([self.cinemaDetailModel.feature_img isEqualToString:@""] || [self.cinemaDetailModel.feature_img isKindOfClass:[NSNull class]]|| self.cinemaDetailModel.feature_img == nil) {
                return cell;
            }else{
                CinemaCharacteristicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CharacteristicCell];
                cell.imageAry = [self.cinemaDetailModel.feature_img componentsSeparatedByString:@","];
                return cell;
            }
        }
        }else{
            
                InfomationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:INFOCELL23];
                cell.selectionStyle = NO;
            if (self.cellDataArr.count > 0) {
                
                CinemaLabelModel * model = self.cellDataArr[indexPath.row];
                if ([model.status integerValue] == 1) {
                    cell.model = model;
                }
            }
            
                return cell;
//            if (indexPath.row == 0) {
//                cell.textLabel.text = @"网友点评";
//                cell.textLabel.textColor = RGBCOLOR(123, 124, 125, 1);
//                cell.textLabel.font = [UIFont systemFontOfSize:14];
//            }else{
//            CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:COMMENTCELL00];
//            for (UIView * view in cell.contentView.subviews) {
//                //            MyLog(@"%ld",(long)view.tag);
//                if ((2100>=view.tag&&view.tag >= 2000)||(1100>=view.tag&&view.tag >= 1000)) {
//                    [view removeFromSuperview];
//                }
//            }
//            cell.selectionStyle=NO;
//
//            return cell;
//            }
    }
    return cell;
}
- (void)iphoneNum{
    MyLog(@"拨打电话");
    NSString *allString;
    if (self.cinemaDetailModel.tel != nil || ![self.cinemaDetailModel.tel isKindOfClass:[NSNull class]]) {
        
        allString = [NSString stringWithFormat:@"tel:%@",self.cinemaDetailModel.tel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
    }else{
        [JRToast showWithText:@"暂无影院电话"];
    }
   

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)requestCinemaDetail{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CINEMADETAIL];
//https://www.yuwabao.cn/api.php/Movie/cinemaDetail/&device_id=7D8297C8-F723-4A97-9D4B-8A7F76224FCD&cinemaCode=01010071&token=d6edde1b02e675b82d83b63579efa556&user_id=12
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"cinemaCode":self.cinemaCode};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([UserSession instance].isLogin) {
        
        [dic setValue:[UserSession instance].token forKey:@"token"];
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
    }
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",dic);
        MyLog(@"影院详情%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.cellDataArr removeAllObjects];
            self.cinemaDetailModel = [CinemaDetailModel yy_modelWithDictionary:data[@"data"]];
            for (NSDictionary * dict in data[@"data"][@"feature"]) {
                CinemaLabelModel * model = [CinemaLabelModel yy_modelWithDictionary:dict];
                [self.cellDataArr addObject:model];//标签
            }
        }
        [self.cinemaTableView reloadData];
    }];
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

@end
