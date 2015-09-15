//
//  QCClockLoadingView.m
//  PieProgress
//
//  Created by MingLi on 15/8/23.
//  Copyright © 2015年 mingli. All rights reserved.
//

#import "LMClockLoadingView.h"
#import "LMPieProgressView.h"

@interface LMClockLoadingView ()<LMPieProgressViewDelegate,LMClockPointerProgressViewDelegate>

@property (nonatomic, strong) LMPieProgressView *pieView;
@property (nonatomic, strong) LMClockPointerProgressView *clockView;
@property (nonatomic, strong) UIImageView *bgView;
@end

@implementation LMClockLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImage *img = [UIImage imageNamed:@"time_bg"];
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame)-img.size.width)/2, (CGRectGetHeight(frame) - img.size.height)/2, img.size.width, img.size.height)];
        _bgView.image = img;
        [self addSubview:_bgView];
        
        CGRect bgFrame = _bgView.frame;
        CGRect pieFrame = CGRectInset(bgFrame, 7.5, 7.5);
        
        _pieView = [[LMPieProgressView alloc] initWithFrame:pieFrame];
        _pieView.delegate = self;
        CGPoint cen = _bgView.center;
        cen.y += 1;
        _pieView.center = cen;
        [self addSubview:_pieView];
        
        _clockView = [[LMClockPointerProgressView alloc] initWithFrame:_bgView.frame];
        _clockView.delegate = self;
        
    }
    return self;
}

- (void)beginLoadingAnimation
{
    [_pieView beginAnimation];
}

- (void)pieProgressDidFinishAnimation
{
    [self addSubview:_clockView];
    [_clockView startClockPointerAnimation];
}


- (void)clockProcessDidFinishAnimation:(LMClockPointerProgressView *)clockView
{
    NSLog(@"Animation Finished");
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.alpha = 1;
        [self removeFromSuperview];
    }];
}
@end
