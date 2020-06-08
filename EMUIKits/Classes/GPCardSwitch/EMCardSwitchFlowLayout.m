//
//  EMCardSwitchFlowLayout.m
//  EMCardSwitchDemo
//
//

#import "EMCardSwitchFlowLayout.h"

//居中卡片宽度与据屏幕宽度比例
static float CardWidthScale = 0.2f;
static float CardHeightScale = 0.8f;

@implementation EMCardSwitchFlowLayout

//初始化方法
- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake([self insetY], [self insetX], [self insetY], [self insetX]);
    self.itemSize = CGSizeMake([self itemWidth], [self itemHeight]);
    self.minimumLineSpacing = 5;
}

#pragma mark -
#pragma mark 配置方法
//卡片宽度
- (CGFloat)itemWidth {
    return self.collectionView.bounds.size.width * CardWidthScale;
}

- (CGFloat)itemHeight {
    return self.collectionView.bounds.size.height * CardHeightScale;
}

//设置左右缩进
- (CGFloat)insetX {
    CGFloat insetX = (self.collectionView.bounds.size.width - [self itemWidth])/2.0f;
    return insetX;
}

- (CGFloat)insetY {
    CGFloat insetY = (self.collectionView.bounds.size.height - [self itemHeight])/2.0f;
    return insetY;
}

//是否实时刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}

@end
