//
//  AllPhotoViewController.m
//  YuWa
//
//  Created by double on 17/6/7.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AllPhotoViewController.h"
#import "FilmPhotoCollectionViewCell.h"
#import "PhotoScalView.h"


#define FILMPHOTOCELL @"FilmPhotoCollectionViewCell"
@interface AllPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (nonatomic,strong)UICollectionView* photoCollectView;
@property (nonatomic,strong)PhotoScalView* photoView;//放大图片view
@property (nonatomic,strong)NSMutableArray * imageViewAry;//存放图片
@end

@implementation AllPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}
-(void)makeUI{
    self.title = @"剧照";
    self.view.backgroundColor = [UIColor whiteColor];
     self.photoScrollView.backgroundColor = CNaviColor;
        CGFloat W = (kScreen_Width-16-8*2)/3;
    
        CGFloat H = kScreen_Height /5;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(W, H);
    self.photoCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(8, 16, kScreen_Width-16, kScreen_Height) collectionViewLayout:layout];
    self.photoCollectView.delegate = self;
    self.photoCollectView.dataSource = self;
    self.photoCollectView.backgroundColor = CNaviColor;
    [self.photoScrollView addSubview:self.photoCollectView];
    [self.photoCollectView registerNib:[UINib nibWithNibName:FILMPHOTOCELL bundle:nil] forCellWithReuseIdentifier:FILMPHOTOCELL];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageAry.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilmPhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:FILMPHOTOCELL forIndexPath:indexPath];
    cell.backgroundColor = CNaviColor;
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageAry[indexPath.item]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];

    [self.imageViewAry addObject:cell.photoImageView.image];

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.photoView.hidden = NO;
    self.photoView.currentNum = indexPath.item+1;
    self.photoView.totalNum = [NSString stringWithFormat:@"%ld",self.imageAry.count];
    self.photoView.imageAry = self.imageAry;
    self.photoView.dataAry = self.imageViewAry;
    self.photoView.imageUrl = self.imageAry[indexPath.item];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}
- (void)cancelBGView:(UITapGestureRecognizer*)tap{
    tap.view.hidden = YES;
    self.photoView.hidden = YES;
}
- (PhotoScalView*)photoView{
    if (!_photoView) {
        _photoView = [[PhotoScalView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height)];
        _photoView.hidden = YES;
        UITapGestureRecognizer * cancelTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBGView:)];
        cancelTap2.numberOfTapsRequired = 1;
        cancelTap2.numberOfTouchesRequired = 1;
        cancelTap2.delegate = self;
        [_photoView addGestureRecognizer:cancelTap2];
        [self.view addSubview:_photoView];
    }
    return _photoView;
}
- (NSMutableArray*)imageViewAry{
    if (!_imageViewAry) {
        _imageViewAry = [NSMutableArray array];
    }
    return _imageViewAry;
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
