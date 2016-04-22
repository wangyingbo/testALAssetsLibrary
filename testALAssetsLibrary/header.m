//
//  header.m
//  testALAssetsLibrary
//
//  Created by 王迎博 on 16/4/21.
//  Copyright © 2016年 王迎博. All rights reserved.
//

#import "header.h"

@implementation header
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.headerLabel = [[UILabel alloc]initWithFrame:self.bounds];
        self.headerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.headerLabel];
        
    }
    return self;
}
@end
