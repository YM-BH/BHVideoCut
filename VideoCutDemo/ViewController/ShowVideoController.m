//
//  ShowVideoController.m
//  VideoCutDemo
//
//  Created by bh on 2017/11/17.
//  Copyright © 2017年 bh. All rights reserved.
//

#import "ShowVideoController.h"
#import "ShowVideoCell.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

static CGFloat const margin = 5;
static CGFloat const count = 4;

@interface ShowVideoController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ShowVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
}

#pragma mark - configUI

- (void)setupCollectionView
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat itemW = (ScreenW - margin * (count + 1)) / count;
    
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = 0.0f;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) collectionViewLayout:layout];
    collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ShowVideoCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ShowVideoCell class])];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
}


#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShowVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ShowVideoCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    
    return cell;
}

@end
