//
//  Card.h
//  CardSwitchDemo
//
//  被切换的卡片

#import <UIKit/UIKit.h>
#import "EMCardModel.h"

@interface EMCardCell : UICollectionViewCell

@property (nonatomic, strong) EMCardModel *model;

- (void)switchToSelectedState;

- (void)switchToDeselecteState;

@end
