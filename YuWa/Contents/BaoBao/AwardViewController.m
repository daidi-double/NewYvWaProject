//
//  AwardViewController.m
//  YuWa
//
//  Created by double on 17/3/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AwardViewController.h"
#import "YWWinnersCollectionViewCell.h"
#import "WinnerModel.h"
#import "YWGetMyAwardViewController.h"
#define WINNERCELL  @"YWWinnersCollectionViewCell"
@interface AwardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YWWinnersCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *winnersCollectionView;
@property(nonatomic,assign)NSInteger is_Kind;
@property (nonatomic,strong)NSMutableArray * dataAry;
@property (nonatomic ,assign)NSInteger ID;
@end

@implementation AwardViewController
- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)setUI{
    [self.winnersCollectionView registerNib:[UINib nibWithNibName:WINNERCELL bundle:nil] forCellWithReuseIdentifier:WINNERCELL];
    [self requestWinnerData];
    self.winnersCollectionView.layer.cornerRadius = 5;
    self.winnersCollectionView.layer.masksToBounds = YES;
    self.winnersCollectionView.userInteractionEnabled = YES;
    
}
- (void)pushToGetAward:(NSInteger)btnTag{
    WinnerModel * model = self.dataAry[btnTag -1000];
    self.is_Kind = [model.is_kind integerValue];
    if (self.is_Kind == 1) {
        YWGetMyAwardViewController * vc = [[YWGetMyAwardViewController alloc]init];
        vc.ID = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self upRequestData];
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.winnersCollectionView.width, 44);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
     return 10;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   YWWinnersCollectionViewCell *  cell = (YWWinnersCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:WINNERCELL forIndexPath:indexPath];
    cell.delegate = self;
    if (self.dataAry.count > 0) {
        WinnerModel * model = self.dataAry[indexPath.item];
        NSString * uid = [NSString stringWithFormat:@"%ld",[UserSession instance].uid];
        if ([model.user_id isEqualToString:uid]) {
            cell.getAwardBtn.hidden = NO;
            cell.winLabel.textColor = [UIColor redColor];
            cell.phoneNumberLabel.textColor = [UIColor redColor];
            cell.codeLabel.textColor = [UIColor redColor];
            cell.nameLabel.textColor = [UIColor redColor];
            if ([model.is_exchange isEqualToString:@"1"]) {
                cell.getAwardBtn.hidden = YES;
                
            }
        }
        
        cell.getAwardBtn.tag = indexPath.row +1000;
        cell.winLabel.text = model.win_info;
        cell.phoneNumberLabel.text = model.username;
        cell.codeLabel.text = model.code;
        cell.nameLabel.text = model.nickname;
        if (model.nickname.length >= 11) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@****%@",[model.nickname substringToIndex:3],[model.nickname substringFromIndex:model.nickname.length-4]];
        }
        
    }
    
    return cell;
}

-(void)requestWinnerData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_WINNERSLIST];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        [self.dataAry removeAllObjects];
        if (number == 0) {
            NSArray * dataAry = data[@"data"];
            MyLog(@"%@",dataAry);
            for (NSDictionary * dict in dataAry) {
                WinnerModel * model = [WinnerModel yy_modelWithDictionary:dict];
                [self.dataAry addObject:model];
                
            }
            [self.winnersCollectionView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
        
    }];
}
- (void)upRequestData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_EXCHANGE];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"s_id":@(self.ID)};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSInteger number = [data[@"errorCode"]integerValue];
        if (number == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
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
