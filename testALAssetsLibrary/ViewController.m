//
//  ViewController.m
//  testALAssetsLibrary
//
//  Created by 王迎博 on 16/4/21.
//  Copyright © 2016年 王迎博. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "YBTNFirstCell.h"
#import "header.h"


#define TNFirstCell @"TNFirstCell"
#define headerId @"header"
//屏幕的宽和高
#define FULL_SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define FULL_SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
//定义AutoLayout布局约束的屏幕适配
#define Adopt_Device_iPhone6_Width ([UIScreen mainScreen].bounds.size.width/375)
#define Adopt_Device_iPhone6_Height ([UIScreen mainScreen].bounds.size.height/667)
#define VIEWLAYOUT_W  FULL_SCREEN_WIDTH/375
#define VIEWLAYOUT_H  FULL_SCREEN_HEIGHT/667
// 颜色
#define YBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//第一cell的item的列间距
#define firstCellInteritemSpacing 1
//第一个section距离顶部的距离
#define firstSectionToTopSpace 10


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
/**所有的相册*/
@property (nonatomic, strong) NSMutableArray *groupMutArr;
/**所有相册里的所有图片*/
@property (nonatomic, strong) NSMutableArray *imageArr;
/**ALAssetsLibrary*/
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSMutableArray *groupName;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置collectionView
    [self initCollectionView];
    
    self.navigationItem.title = @"testALAssetsLibrary";
    
    self.assetsLibrary = [[ALAssetsLibrary alloc]init];
    self.groupMutArr = [NSMutableArray array];
    self.imageArr = [NSMutableArray array];
    self.groupName = [NSMutableArray array];
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            //NSLog(@"*****相册个数***%@",self.groupMutArr);
            [self.groupMutArr addObject:group];
            //每个相册的名字
            NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
            [self.groupName addObject:groupName];
            
            for (ALAssetsGroup *_group in self.groupMutArr)
            {
                [_group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result)
                    {
                        [self.imageArr addObject:result];
                        //NSLog(@"*****所有相册里的所有图片****%@",self.imageArr);
                        //UIImage *image = [UIImage imageWithCGImage: result.thumbnail];
                        //NSString *type=[result valueForProperty:ALAssetPropertyType];
                    }
                }];
            }
        }
        
        [self.collectionView reloadData];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"获取相册失败");
    }];
    
}


/**
 *  设置collectionView
 */
- (void)initCollectionView
{
    //创建布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = firstSectionToTopSpace*VIEWLAYOUT_H;
    layout.minimumInteritemSpacing = firstSectionToTopSpace*VIEWLAYOUT_W;
    
    // 创建CollectionView
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = FULL_SCREEN_WIDTH;
    CGFloat h = FULL_SCREEN_HEIGHT;
    CGRect frame = CGRectMake(x, y, w, h);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = YBColor(235, 236, 237);
    // 解决CollectionView的内容小于它的高度不能滑动的问题
    collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView registerClass:[YBTNFirstCell class] forCellWithReuseIdentifier:TNFirstCell];
    [collectionView registerClass:[header class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
}




#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *testMutArr = [NSMutableArray array];
    ALAssetsGroup *testGroup = [self.groupMutArr objectAtIndex:section];
    [testGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result)
        {
            [testMutArr addObject:result];
        }
    }];
    
    return testMutArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.groupMutArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBTNFirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TNFirstCell forIndexPath:indexPath];
    
    NSMutableArray *mutArr = [NSMutableArray array];
    ALAssetsGroup *testGroup = [self.groupMutArr objectAtIndex:indexPath.section];
    [testGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result){
            [mutArr addObject:result];
        }}];
    
    ALAsset *result = [mutArr objectAtIndex:indexPath.item];
    UIImage *image = [UIImage imageWithCGImage: result.thumbnail];
    [cell setCellWithImage:image];
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    //添加headerView
    if (kind == UICollectionElementKindSectionHeader)
    {
        header *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        
//        ALAssetsGroup *group = [self.groupMutArr objectAtIndex:indexPath.section];
//        NSLog(@"在header里groupMutArr：%lu",(unsigned long)self.groupMutArr.count);
//        
//        NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
//        NSLog(@"在header里groupName：%lu",(unsigned long)self.groupName.count);
        
        headerView.headerLabel.text = [self.groupName objectAtIndex:indexPath.section];
        //NSLog(@"%@",self.groupName);
        
        headerView.backgroundColor = [UIColor lightGrayColor];//section的背景颜色
        reusableView = headerView;
    }
    
    return reusableView;
}


/**
 *  用代码实现header时，此方法必须要实现，不然显示不出来
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

    return CGSizeMake(0, 44);

    return CGSizeZero;
}

# pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((FULL_SCREEN_WIDTH-40)/3, (FULL_SCREEN_WIDTH-40)/3);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets;
    insets = UIEdgeInsetsMake(firstSectionToTopSpace, 5, 20, 10);
    return insets;
}
@end
