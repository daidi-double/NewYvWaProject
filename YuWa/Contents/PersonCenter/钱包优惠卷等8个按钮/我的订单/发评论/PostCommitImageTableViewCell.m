//
//  PostCommitImageTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/18.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PostCommitImageTableViewCell.h"

@interface PostCommitImageTableViewCell()
@property(nonatomic,strong)NSMutableArray*saveAllButtons;

@end

@implementation PostCommitImageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _saveAllButtons=[NSMutableArray array];
        
    }
    return self;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)getDataImage:(NSArray*)allDatas{
    for (UIButton*button in self.saveAllButtons) {
        [button removeFromSuperview];
       
    }
    
    
    
    CGFloat leftValue=15;
    CGFloat jianju=10;
    CGFloat withAndHeight=(kScreen_Width-30-30)/4;
    CGFloat topValue=10;
    
    for (int i=0; i<allDatas.count+1; i++) {
        int hang =i/4;
        int lie  =i%4;
        
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(leftValue+(withAndHeight+jianju)*lie, topValue+(topValue+withAndHeight)*hang, withAndHeight, withAndHeight)];
        button.tag=100+i;
          [self addSubview:button];
        [self.saveAllButtons addObject:button];
        
        if (i==allDatas.count) {
            [button setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            [button removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(touchChooseImage) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            [button setBackgroundImage:allDatas[i] forState:UIControlStateNormal];
            [button removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(touchDeleteImage:) forControlEvents:UIControlEventTouchUpInside];

        }

        
        
     
      
        
        
      
        
        
    }
    
   
    
}


-(CGFloat)getCellHeightWith:(NSArray*)array{
//    CGFloat leftValue=15;
//    CGFloat jianju=10;
    CGFloat withAndHeight=(kScreen_Width-30-30)/4;
    CGFloat topValue=10;

    
    NSInteger number=array.count+1;
      int hang =(short)number/4;
      int lie =   number%4;
    
    CGFloat cellHeight;
    if (lie==0) {
         cellHeight=topValue+(topValue+withAndHeight)*(hang);
    }else{
         cellHeight=topValue+(topValue+withAndHeight)*(hang+1);
    }
    
 
    
    return cellHeight;
}


//跳选择图片
-(void)touchChooseImage{

    if ([self.delegate respondsToSelector:@selector(delegateForTouchAddImage)]) {
        [self.delegate delegateForTouchAddImage];
    }
    
}

//跳删除图片
-(void)touchDeleteImage:(UIButton*)sender{
    NSInteger number=sender.tag-100;
    
    if ([self.delegate respondsToSelector:@selector(delegateForTouchDeleteImageWithTag:)]) {
        [self.delegate delegateForTouchDeleteImageWithTag:number];
    }

}



//-(void)setAllDatas:(NSArray *)allDatas{
//    self.allDatas=allDatas;
//    
//    
//    
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
