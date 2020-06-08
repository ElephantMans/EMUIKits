//
//  EMCardSwitch.h
//  EMCardSwitchDemo
//
//

#import <UIKit/UIKit.h>
#import "EMCardModel.h"

@protocol EMCardSwitchDelegate <NSObject>

@optional

/**
 点击卡片代理方法
 */
-(void)cardSwitchDidClickAtIndex:(NSInteger)index;

/**
 滚动卡片代理方法
 */
-(void)cardSwitchDidScrollToIndex:(NSInteger)index;

@end

@interface EMCardSwitch : UIView
/**
 当前选中位置
 */
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
/**
 设置数据源
 */
@property (nonatomic, strong) NSArray <EMCardModel *>*models;
/**
 代理
 */
@property (nonatomic, weak) id<EMCardSwitchDelegate>delegate;

/**
 手动滚动到某个卡片位置
 */
- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated;

- (void)switchPrevious;

- (void)switchNext;


@end
