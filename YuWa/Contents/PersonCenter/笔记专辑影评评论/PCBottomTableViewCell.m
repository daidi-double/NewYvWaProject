//
//  PCBottomTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PCBottomTableViewCell.h"
#import "PCNoteView.h"
#import "AlbumView.h"
//#import "FilmView.h"
#import "CommitView.h"

@interface PCBottomTableViewCell()<CommitViewDelegate>

@end


@implementation PCBottomTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDatas:(NSMutableArray*)allDatas andWhichCategory:(showViewCategory)number{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        WEAKSELF;
        switch (number) {
            case showViewCategoryNotes:{
               
                PCNoteView*view=[[PCNoteView alloc]initWithFrame:self.frame andArray:allDatas];
                [self addSubview:view];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(weakSelf);
                    
                    
                }];
                
                //代理回控制器 来控制跳转
                view.touchCellBlock=^(NSInteger number){
                    if ([weakSelf.delegate respondsToSelector:@selector(DelegateForNote:)]) {
                        [weakSelf.delegate DelegateForNote:number];
                    }
            
                };
                
                break;}
            case showViewCategoryAlbum:{
            
                AlbumView*view=[[AlbumView alloc]initWithFrame:self.frame andArray:allDatas];
                [self addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(weakSelf);
                }];
                view.touchCellBlock=^(NSInteger number,NSInteger maxNumber){
                    if ([weakSelf.delegate respondsToSelector:@selector(DelegateForAlbum:andMax:)]) {
                        [weakSelf.delegate DelegateForAlbum:number andMax:maxNumber];
                    }
                    
                    
                };
                
                
                break;}
            case showViewCategoryCommit:{
                self.backgroundColor=[UIColor blueColor];
                CommitView*view=[[CommitView alloc]initWithFrame:self.frame andArray:allDatas];
                view.delegate=self;
                [self addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(weakSelf);
                }];
                
                break;
            }


            default:
                break;
        }
        
        
        
        
    }
    
    return self;
    
}

-(instancetype)initWithOtherStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDatas:(NSMutableArray*)allDatas andWhichCategory:(showViewCategory)number{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        WEAKSELF;
        switch (number) {
            case showViewCategoryNotes:{
                
                PCNoteView*view=[[PCNoteView alloc]initWithFrame:self.frame andArray:allDatas withIsOther:YES];
                [self addSubview:view];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(weakSelf);
                    
                    
                }];
                
                //代理回控制器 来控制跳转
                view.touchCellBlock=^(NSInteger number){
                    if ([weakSelf.delegate respondsToSelector:@selector(DelegateForNote:)]) {
                        [weakSelf.delegate DelegateForNote:number];
                    }
                    
                };
                
                break;}
            case showViewCategoryAlbum:{
                
                AlbumView*view=[[AlbumView alloc]initWithFrame:self.frame andArray:allDatas withIsOther:YES];
                [self addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(weakSelf);
                }];
                view.touchCellBlock=^(NSInteger number,NSInteger maxNumber){
                    if ([weakSelf.delegate respondsToSelector:@selector(DelegateForAlbum:andMax:)]) {
                        [weakSelf.delegate DelegateForAlbum:number andMax:maxNumber];
                    }
                    
                    
                };
                
                
                break;}
            case showViewCategoryCommit:{
                self.backgroundColor=[UIColor blueColor];
                CommitView*view=[[CommitView alloc]initWithFrame:self.frame andArray:allDatas];
                view.delegate=self;
                [self addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(weakSelf);
                }];
                
                break;}
                //            case showViewCategoryFilm:{
                ////                self.backgroundColor=[UIColor greenColor];
                //                FilmView*view=[[FilmView alloc]initWithFrame:self.frame andArray:allDatas];
                //                [self addSubview:view];
                //                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                ////                    make.edges.mas_equalTo(self);
                //                    make.top.mas_equalTo(self.mas_top);
                //                    make.left.mas_equalTo(self.mas_left);
                //                    make.right.mas_equalTo(self.mas_right);
                //                    make.bottom.mas_equalTo(self.mas_bottom);
                //                }];
                //
                //                
                //                break;}
                
            default:
                break;
        }
        
        
        
        
    }
    
    return self;
    
}

//-(void)DelegateForSelectedChange:(NSInteger)selection{
//    if ([self.delegate respondsToSelector:@selector(DelegateForSelectedWhichButton:)]) {
//        [self.delegate DelegateForSelectedWhichButton:selection];
//    }
//    
//}

//跳转到店铺的  转代理
-(void)DelegateToShop:(NSString*)shopid{
    if ([self.delegate respondsToSelector:@selector(DelegateForToShopDetail:)]) {
        [self.delegate DelegateForToShopDetail:shopid];
    }
    
}

@end
