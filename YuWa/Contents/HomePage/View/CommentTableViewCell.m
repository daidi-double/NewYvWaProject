//
//  CommentTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "JWTools.h"
#import "MyLabel.h"
@interface CommentTableViewCell()
@property(nonatomic,strong)NSMutableArray*maSaveImageView;

@property(nonatomic,strong)UIView*lineView;
@property(nonatomic,strong)UIImageView*messageImageView;
//@property(nonatomic,strong)MyLable*sellerShowLabel;
@property(nonatomic,strong)NSMutableArray * allRep_contents;
@property(nonatomic,strong)NSMutableArray * rep_contents;
@property(nonatomic,strong)NSMutableArray * labelHeight;

@end
@implementation CommentTableViewCell


-(void)giveValueWithModel:(CommentModel *)model{
    
    //默认的数据
    UIImageView*imageView=[self viewWithTag:1];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.customer_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    UILabel*nameLabel=[self viewWithTag:2];
    nameLabel.text=model.customer_name;
    //判断是否为手机号码，是就隐藏一部分
    if ([JWTools isNumberWithStr:model.customer_name]) {
        nameLabel.text = [NSString stringWithFormat:@"%@****",[model.customer_name substringToIndex:model.customer_name.length - 4]];
    }
    
    UILabel*timeLabel=[self viewWithTag:3];
    timeLabel.text=[JWTools getTime:model.ctime];
    
    //星星数量 -------------------------------------------------------
    CGFloat realZhengshu;
    CGFloat realXiaoshu;
    
    NSString*starNmuber=model.score;
    
    if (self.status == 1) {
        NSString * starNmuber1 = model.score;
        CGFloat totalScroe = [starNmuber1 floatValue]/2;
        NSString *starNmuber = [NSString stringWithFormat:@"%.2f",totalScroe];
        NSString*zhengshu=[starNmuber substringToIndex:1];
        realZhengshu=[zhengshu floatValue];
        NSString*xiaoshu=[starNmuber substringFromIndex:1];
        CGFloat CGxiaoshu=[xiaoshu floatValue];
        
        if (CGxiaoshu>=0.75) {
            realXiaoshu=0;
            realZhengshu= realZhengshu+1;
        }else if (CGxiaoshu>0&&CGxiaoshu<0.25){
            realXiaoshu=0;
        }else{
            realXiaoshu=0.5;
            
        }
        
        for (int i=30; i<35; i++) {
            UIImageView*startImageView=[self viewWithTag:i];;
            startImageView.tag = 30 +i;
            if (startImageView.tag-30<realZhengshu) {
                //亮
                startImageView.image=[UIImage imageNamed:@"home_lightStar"];
            }else if (startImageView.tag-30==realZhengshu&&realXiaoshu<0.75 && realXiaoshu >=0.25){
                //半亮
                startImageView.image=[UIImage imageNamed:@"home_halfStar"];
                
            }else{
                //不亮
                startImageView.image=[UIImage imageNamed:@"home_grayStar"];
            }
            
            
            [self addSubview:startImageView];
        }
  
    }else{
        NSString*zhengshu=[starNmuber substringToIndex:1];
        realZhengshu=[zhengshu floatValue];
        NSString*xiaoshu=[starNmuber substringFromIndex:1];
        CGFloat CGxiaoshu=[xiaoshu floatValue];
        
        if (CGxiaoshu>0.5) {
            realXiaoshu=0;
            realZhengshu= realZhengshu+1;
        }else if (CGxiaoshu>0&&CGxiaoshu<=0.5){
            realXiaoshu=0.5;
        }else{
            realXiaoshu=0;
            
        }
        
        for (int i=30; i<35; i++) {
            UIImageView*imageView=[self viewWithTag:i];
            if (imageView.tag-30<realZhengshu) {
                //亮
                imageView.image=[UIImage imageNamed:@"home_lightStar"];
            }else if (imageView.tag-30==realZhengshu&&realXiaoshu!=0){
                //半亮
                imageView.image=[UIImage imageNamed:@"home_halfStar"];
                
            }else{
                //不亮
                imageView.image=[UIImage imageNamed:@"home_grayStar"];
            }
            
            
        }
    }
    // --------------------------------------------------------
    
#pragma  50 的地方
    NSString*detailStr=model.customer_content;
    MyLable*detailLabel=[self viewWithTag:112];
    if (!detailLabel) {
        detailLabel=[[MyLable alloc]initWithFrame:CGRectMake(65, 50, kScreen_Width-65-50, 0)];
        detailLabel.font=FONT_CN_24;
        detailLabel.numberOfLines=0;
        detailLabel.tag=112;
        [detailLabel setVerticalAlignment:VerticalAlignmentTop];
        [self.contentView addSubview:detailLabel];
    }
    
    detailLabel.text=detailStr;
    CGFloat strHeight=[detailStr boundingRectWithSize:CGSizeMake(kScreen_Width-65-50, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    detailLabel.height=strHeight;
    
    
    
    NSArray*imageArray=model.img_url;
    CGFloat Top=detailLabel.bottom+10;
    CGFloat Left=65;
    CGFloat HJianju=10;
    CGFloat VJianJu=10;
    CGFloat With=(kScreen_Width-65-30-2*HJianju)/3;
    CGFloat Height=With;
    
    for (UIView*view in self.maSaveImageView) {
        [view removeFromSuperview];
    }
    _maSaveImageView=[NSMutableArray array];
    for (int i=0; i<imageArray.count; i++) {
        int HNmuber=i%3;
        int VNumber=i/3;
        
        
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(Left+(With+HJianju)*HNmuber, Top+(Height+VJianJu)*VNumber, With, Height)];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        [self.contentView addSubview:imageView];
        [_maSaveImageView addObject:imageView];
        
    }
    
    //图片的底部
    CGFloat imageVHeight;
    if (imageArray.count>0) {
        NSUInteger VNumber=(imageArray.count-1)/3;
        imageVHeight =Height+(Height+VJianJu)*VNumber+10;
        
    }else{
        imageVHeight=0;
    }
    CGFloat realImageViewBottom=Top+imageVHeight;
    
    
    [self.lineView removeFromSuperview];
    [self.messageImageView removeFromSuperview];
//    [self.sellerShowLabel removeFromSuperview];
//    self.sellerShowLabel=nil;
    
    if (model.rep_list.count == 0) {
        return;
    }
    
    self.lineView=[[UIView alloc]initWithFrame:CGRectMake(65, realImageViewBottom, kScreen_Width-65, 1)];
    self.lineView.backgroundColor=RGBCOLOR(226, 226, 226, 1);
    [self.contentView addSubview:self.lineView];
    
    MyLable * seller_contentLabel;
    [seller_contentLabel removeFromSuperview];

    for (MyLable * viewLabel in self.contentView.subviews) {
        if (viewLabel.tag > 1000) {
            [viewLabel removeFromSuperview];
        }
    }

    CGFloat repLabelHeight = 0.0;
    if (self.rep_contents.count != 0) {
        [self.rep_contents removeAllObjects];
    }
    if (self.allRep_contents.count != 0) {
        [self.allRep_contents removeAllObjects];
    }
    if (self.labelHeight.count != 0) {
        [self.labelHeight removeAllObjects];
    }
    [self.labelHeight addObject:@(0)];
    for (NSDictionary * contentDic in model.rep_list) {
        NSString * rep = contentDic[@"content"];
        [self.rep_contents addObject:rep];
        repLabelHeight=[rep boundingRectWithSize:CGSizeMake(kScreen_Width-65-30-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        [self.labelHeight addObject:@(repLabelHeight)];
    }
    
    [self.allRep_contents addObject:self.rep_contents];
    [self.allRep_contents addObject:self.labelHeight];
    [self.messageImageView removeFromSuperview];
    [seller_contentLabel removeFromSuperview];
    for (int i = 0; i < model.rep_list.count; i ++) {
        self.messageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65, self.lineView.bottom + strHeight+ ([_allRep_contents[1][i] floatValue] +5)*i - 10, 20, 20)];
        self.messageImageView.tag = 1001+i;
        seller_contentLabel = [[MyLable alloc]initWithFrame:CGRectMake(95, self.lineView.bottom+ strHeight+ ([_allRep_contents[1][i] floatValue] +5)*i -10 , kScreen_Width - 65 -30 -20, [_allRep_contents[1][i] floatValue] +5)];
        seller_contentLabel.tag = 2000 +i;
        self.messageImageView.image=[UIImage imageNamed:@"messageImage"];
        [self.contentView addSubview:self.messageImageView];
        seller_contentLabel.font = [UIFont systemFontOfSize:14];
        seller_contentLabel.numberOfLines = 0;
        seller_contentLabel.text = _allRep_contents[0][i];
        seller_contentLabel.height =[_allRep_contents[1][i+1] floatValue];
        [self.contentView addSubview:seller_contentLabel];
        
    }

}

+(CGFloat)getCellHeight:(CommentModel*)model{
    
    NSString*detailStr=model.customer_content;
    CGFloat strHeight=[detailStr boundingRectWithSize:CGSizeMake(kScreen_Width-65-50, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    CGFloat imageTop =50+strHeight+10;
    
    NSArray*imageArray=model.img_url;
    //    CGFloat Top=imageTop;
    //    CGFloat Left=65;
    CGFloat HJianju=10;
    CGFloat VJianJu=10;
    CGFloat With=(kScreen_Width-65-30-2*HJianju)/3;
    CGFloat Height=With;
    //    for (int i=0; i<imageArray.count; i++) {
    //        int HNmuber=i%3;
    //        int VNumber=i/3;
    //    }
    CGFloat imageBottom;
    
    if (imageArray.count>0) {
        NSUInteger VNumber=(imageArray.count-1)/3;
        CGFloat imageVHeight=Height+(Height+VJianJu)*VNumber+10;
        imageBottom=imageTop+imageVHeight;
        
    }else{
        imageBottom=imageTop;
    }
    
    
    if (model.rep_list.count==0) {
        return imageBottom;
    }
    
    
    CGFloat repLabelHeight = 0.0;
    NSString * rep = nil;
    NSMutableArray * rep_contentArr;
    if (rep_contentArr) {
        [rep_contentArr removeAllObjects];
    }
    rep_contentArr = [NSMutableArray array];
    CGFloat labelHeight = 0.0 ;
    for (NSDictionary * contentDic in model.rep_list) {
        
        rep = contentDic[@"content"];
        [rep_contentArr addObject:rep];
        repLabelHeight=[rep boundingRectWithSize:CGSizeMake(kScreen_Width-65-30-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height + 5;
        labelHeight = labelHeight + repLabelHeight;
    }
    
    
    
    
    return imageBottom+10+labelHeight+10;
}


- (NSMutableArray *)rep_contents{
    if (!_rep_contents) {
        _rep_contents = [NSMutableArray array];
    }
    return _rep_contents;
}
- (NSMutableArray *)allRep_contents{
    if (!_allRep_contents) {
        _allRep_contents = [NSMutableArray array];
    }
    return _allRep_contents;
}
-(NSMutableArray * )labelHeight{
    if (!_labelHeight) {
        _labelHeight = [NSMutableArray array];
    }
    return _labelHeight;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
