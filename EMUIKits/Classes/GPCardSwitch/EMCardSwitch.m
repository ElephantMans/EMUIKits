//
//  EMCardSwitch.m
//  EMCardSwitchDemo
//

#import "EMCardSwitch.h"
#import "EMCardSwitchFlowLayout.h"
#import "EMCardCell.h"

@interface EMCardSwitch ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isSelectMode;

@end

@implementation EMCardSwitch

- (instancetype)init {
    if (self = [super init]) {
        [self buildUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addCollectionView];
    _selectedIndex = 0;
    _isSelectMode = NO;
}

- (void)addCollectionView {
    //避免UINavigation对UIScrollView产生的偏移问题
    [self addSubview:[UIView new]];
    EMCardSwitchFlowLayout *flowLayout = [[EMCardSwitchFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[EMCardCell class] forCellWithReuseIdentifier:@"EMCardCell"];
    self.collectionView.userInteractionEnabled = true;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark -
#pragma mark Setter
- (void)setModels:(NSArray<EMCardModel *> *)models {
    _models = models;
    [self.collectionView reloadData];
    if(_models.count > 0) {
        _models[_selectedIndex].selected = YES;
    }
    [self switchToIndex:self.selectedIndex animated:false];
}

#pragma mark -
#pragma mark CollectionDelegate

//滚动到中间
- (void)scrollToCenterAnimated:(BOOL)animated {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isSelectMode = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.isSelectMode) {
        return;
    }
    CGFloat scrollPosition = scrollView.contentOffset.x+(self.collectionView.bounds.size.width - 75)/2;
    for(UICollectionViewCell * cell in self.collectionView.visibleCells) {
        CGFloat cellLeft = cell.frame.origin.x;
        CGFloat cellRight = cell.frame.origin.x + cell.frame.size.width;
        NSIndexPath *currentIndex = [self.collectionView indexPathForCell:cell];
        if(scrollPosition >= cellLeft && scrollPosition <= cellRight) {
            if(currentIndex.row != self.selectedIndex) {
                NSLog(@"collectionView scroll select %ld", currentIndex.row);
                [self collectionView:self.collectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
                [self collectionView:self.collectionView didSelectItemAtIndexPath:currentIndex];
            }
        }
    }

}

//点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"collectionView select %ld", indexPath.row);
    self.isSelectMode = YES;
    [self switchToIndex:indexPath.row animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"collectionView deselect %ld", indexPath.row);
    self.models[indexPath.row].selected = NO;
    EMCardCell *card = (EMCardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [card switchToDeselecteState];
}

#pragma mark -
#pragma mark CollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"EMCardCell";
    EMCardCell* card = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    card.model = self.models[indexPath.row];
    return  card;
}

#pragma mark -
#pragma mark 功能方法
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self switchToIndex:selectedIndex animated:false];
}

- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated {
    [self collectionView:self.collectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
     _selectedIndex = index;
     self.models[_selectedIndex].selected = YES;
     [self scrollToCenterAnimated:YES];
     [self performClickDelegateMethod];
    EMCardCell *card = (EMCardCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
     [card switchToSelectedState];
}

- (void)switchNext {
    if(self.selectedIndex == self.models.count - 1) {
        return;
    }
    NSInteger nextIndex = self.selectedIndex + 1;
    [self switchToIndex:nextIndex animated:YES];
}

-(void)switchPrevious {
    if(self.selectedIndex == 0) {
        return;
    }
    NSInteger previousIndex = self.selectedIndex - 1;
     [self switchToIndex:previousIndex animated:YES];
}

- (void)performClickDelegateMethod {
    if ([_delegate respondsToSelector:@selector(cardSwitchDidClickAtIndex:)]) {
        [_delegate cardSwitchDidClickAtIndex:_selectedIndex];
    }
}

- (void)performScrollDelegateMethod {
    if ([_delegate respondsToSelector:@selector(cardSwitchDidScrollToIndex:)]) {
        [_delegate cardSwitchDidScrollToIndex:_selectedIndex];
    }
}


@end
