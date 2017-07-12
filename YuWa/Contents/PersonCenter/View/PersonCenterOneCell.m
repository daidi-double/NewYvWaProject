//
//  PersonCenterOneCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/20.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PersonCenterOneCell.h"
#import "imageDefineButton.h"

@implementation PersonCenterOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for (int i=0; i<8; i++) {
             imageDefineButton *button=[[imageDefineButton alloc]init];
            button.tag=i+200;

            CGFloat buttonWith=kScreen_Width/4;
            CGFloat buttonHeight=70;
            
            
            
            if (i<4) {
                [button setSize:CGSizeMake(buttonWith, buttonHeight)];
                [button setY:12];
                [button setX:buttonWith*i];
//
             
                
            }else{
                 [button setSize:CGSizeMake(buttonWith, buttonHeight)];
                [button setY:12+buttonHeight];
                [button setX:buttonWith*(i-4)];
               

                
                
            }
            
             [self.contentView addSubview:button];
            
            
            
        }
       
        
        
        
        
        
    }
    
    return self;
}
@end
