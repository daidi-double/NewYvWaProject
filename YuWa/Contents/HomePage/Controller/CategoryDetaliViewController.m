//
//  CategoryDetaliViewController.m
//  YuWa
//
//  Created by double on 17/3/2.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CategoryDetaliViewController.h"

@interface CategoryDetaliViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView * btnCollectView;
@property (nonatomic,strong)NSMutableArray * titleDataAry;
@property (nonatomic,strong)NSMutableArray * subTitleAry;
@end

@implementation CategoryDetaliViewController
- (NSMutableArray*)titleDataAry{
    if (!_titleDataAry) {
        _titleDataAry = [NSMutableArray array];
    }
    return _titleDataAry;
}
- (NSMutableArray*)subTitleAry{
    if (!_subTitleAry) {
        _subTitleAry = [NSMutableArray array];
    }
    return _subTitleAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部分类";
    [self makeUI];
    self.view.backgroundColor = RGBCOLOR(241, 238, 245, 1);
    NSArray * titleAry = @[@"美食",@"电影",@"酒店",@"休闲娱乐",@"生活服务",@"丽人",@"购物",@"汽车服务",@"运动健身",@"母婴亲子",@"宠物",@"摄影写真",@"结婚",@"家装",@"学习培训",@"旅游"];
    [self.titleDataAry addObjectsFromArray:titleAry];
    NSArray * subAry = @[@[@"火锅",@"蛋糕",@"甜点饮品",@"小吃快餐",@"日韩料理",@"川湘菜",@"海鲜",@"素食",@"其他美食"],@[@""],@[@""],@[@"足疗按摩",@"KTV",@"酒吧",@"桌游/电玩",@"密室逃脱",@"点播电影",@"其他娱乐"],@[@"衣物/皮具洗护",@"配镜",@"鲜花",@"摄影写真",@"其他生活"],@[@"美发",@"美容美体",@"美甲美睫",@"瑜伽舞蹈",@"祛痘",@"纹身",@"其他丽人"],@[@"女装",@"男装",@"内衣",@"鞋靴",@"食品",@"家居日用",@"美妆",@"本地购物"],@[@"洗车",@"汽车美容",@"汽车改装",@"维修保养",@"租车",@"4S汽车店",@"更多汽车服务"],@[@"游泳/水上运动",@"健身房/体操房",@"羽毛球",@"台球",@"综合体育场馆",@"其他运动"],@[@"儿童乐园",@"婴儿游泳",@"儿童摄影",@"孕妇写真",@"母婴护理",@"幼儿教育",@"更多亲子服务"],@[@"宠物店",@"宠物医院"],@[@"婚纱摄影",@"亲子摄影",@"个性写真",@"其他摄影"],@[@"婚纱摄影",@"婚纱礼服",@"成衣定制",@"婚庆服务",@"婚车租赁",@"更多婚礼服务"],@[@"装修设计",@"厨房卫浴",@"家用电器",@"家装卖场",@"装修建材"],@[@"外语培训",@"音乐培训",@"美术培训",@"书法培训",@"驾校",@"职业技术",@"更多教育培训"],@[@"旅行社"]];
    [self.subTitleAry addObjectsFromArray:subAry];
    
    // Do any additional setup after loading the view.
}
- (void)makeUI{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    _btnCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, kScreen_Width-20, kScreen_Height) collectionViewLayout:layout];
    _btnCollectView.delegate = self;
    _btnCollectView.dataSource = self;
    _btnCollectView.backgroundColor = RGBCOLOR(241, 238, 245, 1);
    [_btnCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"btnCell"];
    [_btnCollectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"btnCellHeader"];
    [self.view addSubview:_btnCollectView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.titleDataAry.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableArray * itemNum = [NSMutableArray array];
    if (itemNum.count != 0) {
        [itemNum removeAllObjects];
    }
    [itemNum addObjectsFromArray:self.subTitleAry[section]];
    return itemNum.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreen_Width, 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreen_Width - 30)/4, 30);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"btnCellHeader" forIndexPath:indexPath];
//    [[UICollectionReusableView alloc]initWithFrame:CGRectMake(10, 0, kScreen_Width-20, 40)];
    if (!headerView) {
        headerView = [[UICollectionReusableView alloc]init];
    }
    for (UIImageView * view in headerView.subviews) {
        [view removeFromSuperview];
    }
    for (UILabel * label in headerView.subviews) {
        [label removeFromSuperview];
    }
    
    UIImageView * titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 25, 25)];
    NSString * path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",self.titleDataAry[indexPath.section]] ofType:@"png"];
    titleImageView.image = [UIImage imageWithContentsOfFile:path];
    [headerView addSubview:titleImageView];
    

    UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 15, headerView.width/4, 25)];

    if (titleLbl.text.length == 0) {
      titleLbl.text = self.titleDataAry[indexPath.section];
    }else{
        
    }

    [headerView addSubview:titleLbl];
    return headerView;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.5f;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"btnCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    for (UILabel * lbl in cell.contentView.subviews) {
        [lbl removeFromSuperview];
    }
    UILabel * subTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
    subTitle.textColor = CNaviColor;
    subTitle.font = [UIFont systemFontOfSize:15];
    subTitle.lineBreakMode = NSLineBreakByTruncatingMiddle;
    subTitle.textAlignment = 1;
    subTitle.text = self.subTitleAry[indexPath.section][indexPath.item];
    [cell.contentView addSubview:subTitle];
    
    return cell;
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
