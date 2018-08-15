//
//  ViewController.m
//  PLProgressViewDemo
//
//  Created by qmtv on 2018/8/15.
//  Copyright © 2018年 clOud. All rights reserved.
//

#import "ViewController.h"
#import "PLProgressView.h"
@interface ViewController ()

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) PLProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _progressView = [PLProgressView new];
    _progressView.frame = (CGRect){0, 200, 150, 150};
    CGPoint center = (CGPoint){self.view.center.x, 200};
    _progressView.center = center;
    _progressView.trackTintColor = [UIColor grayColor];
    _progressView.progressTintColor = [UIColor orangeColor];
    _progressView.startAngle = 90;
    _progressView.progressWidth = 10;
    _progressView.roundedCorners = true;
    [self.view addSubview:_progressView];
    
    [self.view addSubview:self.slider];
}

- (void)sliderAction:(UISlider *)sender
{
    _progressView.progress = sender.value;
}

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:(CGRect){50, 400, 300, 20}];
        _slider.maximumValue = 1;
        [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
