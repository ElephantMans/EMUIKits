//
//  EMCardCell.m
//  CardSwitchDemo
//

#import "EMCardCell.h"
#import "EMCardModel.h"

@interface EMCardCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation EMCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)switchToSelectedState {
    [self.layer addSublayer:self.circleLayer];
}

- (void)switchToDeselecteState {
    [self.circleLayer removeFromSuperlayer];
}

- (void)buildUI {
    self.backgroundColor = [UIColor clearColor];
    CGFloat imageViewHeight = self.bounds.size.height;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, imageViewHeight)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = true;
    [self addSubview:self.imageView];
    self.circleLayer = [CAShapeLayer new];
    self.circleLayer.strokeColor = [UIColor purpleColor].CGColor;
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleLayer.lineWidth = 3;
    self.frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) radius:self.bounds.size.width/ 2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.circleLayer.path = path.CGPath;
}

- (void)setModel:(EMCardModel *)model {
    _model = model;
    self.imageView.image = [UIImage imageNamed:model.imageName];
    if(model.selected) {
        [self switchToSelectedState];
    } else {
        [self switchToDeselecteState];
    }
}

@end
