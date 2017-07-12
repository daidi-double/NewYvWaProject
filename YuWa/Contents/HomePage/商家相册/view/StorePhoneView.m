//
//  StorePhoneView.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/13.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "StorePhoneView.h"
#import "StorePhotoCollectionViewCell.h"

#import "StorePhotoModel.h"


#define CCELL0   @"StorePhotoCollectionViewCell"


@interface StorePhoneView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView*collectionView;
@property(nonatomic,strong)NSMutableArray*allDatas;   //所有数据
@end

@implementation StorePhoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        
        
        UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
        flowLayout.sectionInset=UIEdgeInsetsMake(18, 18, 18, 18);
        flowLayout.minimumInteritemSpacing=18;
        flowLayout.itemSize=CGSizeMake((kScreen_Width-3*18)/2, (kScreen_Width-3*18)/2);
        
       self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor=RGBCOLOR(240, 239, 237, 1);
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.alwaysBounceVertical=YES;
        [self addSubview:_collectionView];
        [_collectionView registerNib:[UINib nibWithNibName:@"StorePhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CCELL0];
        

        
        
        
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allDatas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:CCELL0 forIndexPath:indexPath];
    
    NSInteger number=indexPath.row;
    StorePhotoModel*model=self.allDatas[number];
    
    UIImageView*imageView=[cell viewWithTag:1];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    UILabel*label=[cell viewWithTag:3];
    label.text=model.title;
    
    
    return cell;
    
    
}


-(void)getData:(NSArray*)allDatas{
//    self.allDatas=allDatas;
    for (NSDictionary*dict in allDatas) {
       StorePhotoModel*model= [StorePhotoModel yy_modelWithDictionary:dict];
        [self.allDatas addObject:model];
    }
    
    
    [self.collectionView reloadData];
    
    
}


#pragma mark  --set
-(NSMutableArray *)allDatas{
    if (!_allDatas) {
        _allDatas=[NSMutableArray array];
    }
    return _allDatas;
}


@end
