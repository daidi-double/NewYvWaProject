//
//  YWSiftCollectionViewCell.m
//  YuWa
//
//  Created by double on 17/6/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWSiftCollectionViewCell.h"

@implementation YWSiftCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor=[UIColor colorWithHexString:@"#ffffff"].CGColor;
        self.layer.borderWidth=0.3;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textAlignment = 1;
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}
@end
