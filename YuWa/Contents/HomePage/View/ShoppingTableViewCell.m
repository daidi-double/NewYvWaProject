//
//  ShoppingTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ShoppingTableViewCell.h"
#import "ShoppingCollectionViewCell.h"

#import "HPTopShopModel.h"

#define CCELL0   @"ShoppingCollectionViewCell"

@interface ShoppingTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView*collectionView;
@end

@implementation ShoppingTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        titleLabel.centerY = self.centerY;
        titleLabel.centerX = kScreen_Width/2+10;
        titleLabel.font=[UIFont systemFontOfSize:15];
//        titleLabel.textColor=CpriceColor;
        titleLabel.textColor = RGBCOLOR(255, 161, 73, 1);
        titleLabel.text=@"——      名店折扣 ——";
        
        UIImageView * zhuanshiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width/2 - 33, 0, 17, 10)];
        zhuanshiImageView.image = [UIImage imageNamed:@"砖石"];
        zhuanshiImageView.centerY = self.centerY;
        
        [self addSubview:zhuanshiImageView];
        
        UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];

        flowLayout.sectionInset=UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.itemSize=CGSizeMake((kScreen_Width-40)/3, 156);
        flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;

        
        self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 200) collectionViewLayout:flowLayout];
        [self.collectionView registerNib:[UINib nibWithNibName:CCELL0 bundle:nil] forCellWithReuseIdentifier:CCELL0];
        
        [self addSubview:self.collectionView];
        self.collectionView.backgroundColor=[UIColor whiteColor];
        self.collectionView.showsHorizontalScrollIndicator=NO;
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.alwaysBounceHorizontal=YES;
        
        //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top).offset(44);
            make.right.mas_equalTo(self.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
            
            
        }];
        
    }
    
    return self;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allDatas.count;
 
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:CCELL0 forIndexPath:indexPath];
    
    NSInteger number=indexPath.row;
    HPTopShopModel*model=self.allDatas[number];
    
 
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.company_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
 

    cell.titleLabel.text=model.company_name;

    
    
    return cell;
    
}





-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger number=indexPath.row;
    
    
    if (self.touchCollectionViewBlock) {
        self.touchCollectionViewBlock(number);
    }
    
}




#pragma mark  --set



-(void)setAllDatas:(NSMutableArray *)allDatas{
    
    _allDatas=allDatas;
    
    [self.collectionView reloadData];

    
}

@end
