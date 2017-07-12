//
//  WillPlayMovieCell.h
//  YuWa
//
//  Created by double on 2017/2/18.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol WillPlayMovieCellDelegate <NSObject>
//
//- (void)pushToSellPage;
//
//@end
@interface WillPlayMovieCell : UITableViewCell

@property (nonatomic,strong) UIImageView * movieImageView;
@property (nonatomic,strong) UILabel * title;
@property (nonatomic,strong) UILabel * introduce;//简介
@property (nonatomic,strong) UILabel * playTime;//上映时间
@property (nonatomic,strong) UILabel * wantLook;//想看人数
//@property (nonatomic,strong) UIButton * sellBtn;//预售/想看

//@property (nonatomic,assign) id<WillPlayMovieCellDelegate>delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDataAry:(NSMutableArray*)dataAry;

@end
