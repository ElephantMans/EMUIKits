//
//  CardModel.h
//  CardSwitchDemo
//

#import <Foundation/Foundation.h>

@interface EMCardModel : NSObject

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, assign) BOOL selected;

@end
