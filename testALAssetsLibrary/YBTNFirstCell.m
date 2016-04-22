//
//  YBTNFirstCell.m
//  Kergou
//
//  Created by 王迎博 on 16/4/8.
//  Copyright © 2016年 张帅. All rights reserved.
//

#import "YBTNFirstCell.h"


#define button_W_H 20
#define YBBorderWidthConst 10

@implementation YBTNFirstCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;//边框与背景色保持一致
//        self.imageView.layer.borderWidth = YBBorderWidthConst;
        self.backgroundColor = [UIColor redColor];
        [self addSubview:_imageView];
        
        /**
         右上角按钮
         */
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - button_W_H, 0, button_W_H, button_W_H)];
        button.backgroundColor = [UIColor grayColor];
        button.layer.cornerRadius = button_W_H/2;
        [button setBackgroundImage:[UIImage imageNamed:@"writenote_shutdown"] forState:UIControlStateNormal];
        _button = button;
        //[self addSubview:button];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
 
}

- (void)setCellWithImage:(UIImage *)image
{
    self.imageView.image = image;
}


- (void)setImageName:(NSString *)imageName
{
    _imageName = [imageName copy];
    self.imageView.image = [UIImage imageNamed:_imageName];
}
@end
