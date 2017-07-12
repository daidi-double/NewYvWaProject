//
//  ProducePhotoTableViewCell.m
//  YuWa
//
//  Created by double on 17/6/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ProducePhotoTableViewCell.h"
#import "ProducePhotoCollectionViewCell.h"

#define PRODUCECOLLECTVIEWCELL @"ProducePhotoCollectionViewCell"
@implementation ProducePhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.produceCollectView];
    }
    return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 5, 15, 5);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProducePhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PRODUCECOLLECTVIEWCELL forIndexPath:indexPath];
    
    return cell;
}
- (UICollectionView *)produceCollectView{
    if (!_produceCollectView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake((kScreen_Width-115)/2, kScreen_Height *212/1334);
        _produceCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height *272/1334) collectionViewLayout:layout];
        _produceCollectView.contentSize = CGSizeMake(kScreen_Width *2, kScreen_Height *212/1334);
        _produceCollectView.delegate = self;
        _produceCollectView.dataSource = self;
        _produceCollectView.backgroundColor = [UIColor whiteColor];
        [_produceCollectView registerNib:[UINib nibWithNibName:PRODUCECOLLECTVIEWCELL bundle:nil] forCellWithReuseIdentifier:PRODUCECOLLECTVIEWCELL];
    }
    return _produceCollectView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
