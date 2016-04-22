//
//  YBTNFirstCell.h
//  Kergou
//
//  Created by 王迎博 on 16/4/8.
//  Copyright © 2016年 张帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBTNFirstCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) UIButton *button;


- (void)setCellWithImage:(UIImage *)image;
@end
