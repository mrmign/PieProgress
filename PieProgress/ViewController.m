//
//  ViewController.m
//  PieProgress
//
//  Created by MingLi on 15/8/23.
//  Copyright © 2015年 mingli. All rights reserved.
//

#import "ViewController.h"
#import "LMClockLoadingView.h"
@interface ViewController ()<LMClockLoadingViewDelegate>
@property (nonatomic, strong) LMClockLoadingView *clockView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _clockView = [[LMClockLoadingView alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
    [self.view addSubview:_clockView];
    
    [_clockView beginLoadingAnimation];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Notify" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 190, 60, 30);
    [btn addTarget:self action:@selector(sendNotify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    [add setTitle:@"Redo" forState:UIControlStateNormal];
    [add setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    add.frame = CGRectMake(180, 190, 60, 30);
    [add addTarget:self action:@selector(redoAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendNotify
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"__getRealNotification__" object:nil];
}

- (void)redoAnimation
{
    [self.view addSubview:_clockView];
    [_clockView beginLoadingAnimation];
}

@end
