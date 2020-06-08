//
//  DemoViewController.m
//  EMCardSwitchDemo
//
// 

#import "EMSwitchDemoViewController.h"
#import "EMCardSwitch.h"

@interface EMSwitchDemoViewController ()<EMCardSwitchDelegate>

@property (nonatomic, strong) EMCardSwitch *cardSwitch;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentTitleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) NSMutableArray *models;


@end

@implementation EMSwitchDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self configNavigationBar];
    [self addCardSwitch];
    [self addContentView];
    [self buildData];
}

- (void)configNavigationBar {
    self.navigationItem.title = @"Coupang Category";
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)addCardSwitch {
    //初始化
    self.cardSwitch = [[EMCardSwitch alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    //设置代理方法
    self.cardSwitch.delegate = self;
    [self.view addSubview:self.cardSwitch];
}

- (void)addContentView {
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height- 100)];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.userInteractionEnabled = YES;
    [self.view addSubview:self.contentView];
    UISwipeGestureRecognizer* swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    [swipeUpGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.contentView addGestureRecognizer:swipeUpGesture];
    UISwipeGestureRecognizer* swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    [swipeDownGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.contentView addGestureRecognizer:swipeDownGesture];

    self.contentTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.contentView.bounds.size.width, 30)];
    self.contentTitleLabel.font = [UIFont systemFontOfSize:24];
    self.contentTitleLabel.textColor = [UIColor purpleColor];
    self.contentTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.contentTitleLabel];

    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 200)];
    self.contentLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.textColor = [UIColor lightGrayColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.contentLabel];
}

-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        [self switchPrevious];
    }
}

-(void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [self switchNext];
    }
}

- (void)buildData {
    //初始化数据源
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"category" ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(!json || error) {
        return;
    }
    NSArray *arr = json;
     self.models = [NSMutableArray new];
     for (NSDictionary *dic in arr) {
         EMCardModel *model = [[EMCardModel alloc] init];
         model.imageName = dic[@"category_filename"];
         model.title = dic[@"title"];
         model.introduction = dic[@"introduction"];
         [self.models addObject:model];
     }
    
    //设置卡片数据源
    self.cardSwitch.models = self.models;
    
    //更新背景图
    [self configImageViewOfIndex:self.cardSwitch.selectedIndex];
}

#pragma mark -
#pragma mark CardSwitchDelegate
- (void)cardSwitchDidClickAtIndex:(NSInteger)index {
    NSLog(@"点击了：%zd",index);
    [self configImageViewOfIndex:index];
}

- (void)cardSwitchDidScrollToIndex:(NSInteger)index {
    NSLog(@"滚动到了击了：%zd",index);
    [self configImageViewOfIndex:index];
}

#pragma mark -
#pragma mark 更新imageView
- (void)configImageViewOfIndex:(NSInteger)index {
    //更新背景图
    EMCardModel *model = self.models[index];
    [self.contentTitleLabel setText:model.title];
    [self.contentLabel setText:model.introduction];
    self.contentView.frame = CGRectMake(0, self.view.bounds.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);

    [UIView animateWithDuration:1 animations:^{
        self.contentView.frame = CGRectMake(0, 80, self.contentView.frame.size.width, self.contentView.frame.size.height);
    }];
}

#pragma mark -
#pragma mark 手势切换方法
- (void)switchPrevious {
    [self.cardSwitch switchPrevious];
}

- (void)switchNext {
    [self.cardSwitch switchNext];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
