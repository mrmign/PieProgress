//
//  Progress.m
//  KeyframeAni
//
//  Created by armingli on 15/8/21.
//  Copyright © 2015年 armingli. All rights reserved.
//

#import "LMPieProgressView.h"

typedef enum : NSUInteger {
    AnimationType_Green,
    AnimationType_White,
} AnimationType;

@interface LMPieProgressView ()

@property (nonatomic, assign) CGFloat radius;
@property(nonatomic, strong)CAShapeLayer *greenLayer;
@property(nonatomic, strong)NSMutableArray *paths;
@property(nonatomic, assign)CGFloat animationDuration;
@property (nonatomic, strong) CAShapeLayer *whiteLayer;
@property (nonatomic, strong) NSMutableArray *whitePaths;
@property (nonatomic, assign) AnimationType aniType;
@property (nonatomic , strong) NSString *animationKey;
@end

@implementation LMPieProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _animationDuration = 1.;
        _paths = [NSMutableArray array];
        _whitePaths = [NSMutableArray array];
        [self initial];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimation) name:@"__getRealNotification__" object:nil];
    }
    return self;
}

- (void)initial
{
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    UIBezierPath *initialPath = [UIBezierPath bezierPath];
    
    _radius =MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))/2;
    
    [initialPath addArcWithCenter:center radius:_radius startAngle:degreeToRadian(-90) endAngle:degreeToRadian(-90) clockwise:YES]; //add the arc
    _greenLayer = [CAShapeLayer layer];
    _greenLayer.frame = self.bounds;
    _greenLayer.path = initialPath.CGPath;
    _greenLayer.strokeColor = [UIColor redColor].CGColor;
    _greenLayer.fillColor = [UIColor greenColor].CGColor;
    _greenLayer.lineWidth = 0;
    [self.layer addSublayer:_greenLayer];
    
    UIBezierPath *whiteInitalPath = [UIBezierPath bezierPath];
    [whiteInitalPath addArcWithCenter:center radius:_radius+0.1 startAngle:degreeToRadian(-90) endAngle:degreeToRadian(-90) clockwise:YES];
    _whiteLayer = [CAShapeLayer layer];
    _whiteLayer.frame = self.bounds;
    _whiteLayer.path = whiteInitalPath.CGPath;
    _whiteLayer.fillColor = [UIColor whiteColor].CGColor;
    _whiteLayer.strokeColor = [UIColor blackColor].CGColor;
    _whiteLayer.lineWidth = 0;
    
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSString *)animationKey
{
    NSLog(@"current Animation: %@", _animationKey);
    return _animationKey;
}
- (void)beginAnimation
{
    [self beginGreenAnimation];
}
- (void)stopAnimation
{
    if (_aniType == AnimationType_Green) {
    }
    switch (_aniType) {
        case AnimationType_Green:
        {
            
            [_greenLayer removeAnimationForKey:_animationKey];
            [_greenLayer removeFromSuperlayer];
        }
            break;
        case AnimationType_White:
        {
            [_whiteLayer removeAnimationForKey:_animationKey];
            [_whiteLayer removeFromSuperlayer];
            [_greenLayer removeFromSuperlayer];
        }
            break;
        default:
            break;
    }
}

- (void)beginGreenAnimation
{
    if (![_greenLayer superlayer]) {
        [self.layer addSublayer:_greenLayer];
    }
    [_whiteLayer removeFromSuperlayer];
    [_paths removeAllObjects];
    [_paths addObjectsFromArray:[self createGreenPaths]];
    
    _greenLayer.path = (__bridge CGPathRef)[_paths lastObject];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    [pathAnimation setValues:_paths];
    [pathAnimation setDuration:self.animationDuration];
    _animationKey = @"green";
    _aniType = AnimationType_Green;
//    [pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    pathAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                      ];
    [pathAnimation setRemovedOnCompletion:YES];
    pathAnimation.calculationMode = kCAAnimationDiscrete;
    pathAnimation.fillMode =  kCAFillModeForwards;
    pathAnimation.delegate = self;
    [pathAnimation setValue:@(YES) forKey:@"greenPath"];
    [_greenLayer addAnimation:pathAnimation forKey:@"green"];
}

- (void)beginWhiteAnimation
{
//    [_greenLayer removeFromSuperlayer];
    [self.layer addSublayer:_whiteLayer];
    [_whitePaths removeAllObjects];
    [_whitePaths addObjectsFromArray:[self createWhitePaths]];
    _whiteLayer.path = (__bridge CGPathRef)[_whitePaths lastObject];
    _animationKey = @"white";
    _aniType = AnimationType_White;
    CAKeyframeAnimation *whiteAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    whiteAnimation.values = _whitePaths;
    whiteAnimation.duration = self.animationDuration;
    whiteAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       ];
    whiteAnimation.removedOnCompletion = YES;
    whiteAnimation.calculationMode = kCAAnimationDiscrete;
    whiteAnimation.delegate = self;
    [whiteAnimation setValue:@(YES) forKey:@"whitePath"];
    [_whiteLayer addAnimation:whiteAnimation forKey:@"white"];
}

- (NSArray *)createWhitePaths
{
    NSArray *a = @[@0, @15,@22,@28,@34,@39,@44, @48, @52,@55,@57,@59,@60];
    NSMutableArray *arr = [NSMutableArray array];
    
    CGFloat startAngle = degreeToRadian(-90);
    for (int i = 1; i<a.count; i++) {
        NSInteger cur = [a[i] integerValue];
        CGFloat endAngle = startAngle + cur/60.0*2*M_PI;
        [arr addObject:(id)([self pathWithStartAngle:startAngle endAngle:endAngle].CGPath)];
    }
    return arr;
}

- (NSArray *)createGreenPaths
{
    NSArray *a = @[@(0),@(1),@(3),@(5),@(8),@(12),@(16),@(21),@(26),@(32),@(38),@(45),@(60)];
    NSMutableArray *arr = [NSMutableArray array];
    
    CGFloat startAngle = degreeToRadian(-90);
    for (int i = 1; i<a.count; i++) {
        NSInteger cur = [a[i] integerValue];
        CGFloat endAngle = startAngle + cur/60.0*2*M_PI;
        [arr addObject:(id)([self pathWithStartAngle:startAngle endAngle:endAngle].CGPath)];
    }
    return arr;
}

- (UIBezierPath *)pathWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    [path moveToPoint:center];
    [path addArcWithCenter:center radius:_radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path closePath];
    return path;
}

float degreeToRadian(float degree)
{
    return ((degree * M_PI)/180.0f);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        NSNumber *green = [anim valueForKey:@"greenPath"];
        NSNumber *white = [anim valueForKey:@"whitePath"];
        if (green) {
            [self beginWhiteAnimation];
        }
        else if (white) {
            [self beginGreenAnimation];
        }
    }
    else {
        NSLog(@"Not Finished");
        if ([_delegate respondsToSelector:@selector(pieProgressDidFinishAnimation)]) {
            [_delegate pieProgressDidFinishAnimation];
        }
    }
}

@end

@interface LMClockPointerProgressView ()
@property (nonatomic, strong) UIView *staticView;
@property (nonatomic, strong) UIView *movedView;
@end

@implementation LMClockPointerProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _staticView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 6)];
        _staticView.backgroundColor = [UIColor greenColor];
        CGRect fra = _staticView.frame;
        fra.origin.x = CGRectGetMidX(frame) - 0.5;
        fra.origin.y = CGRectGetMidY(frame) - CGRectGetHeight(fra);
        _staticView.frame = fra;
        [self addSubview:_staticView];
        
        fra.size.height = 5;
        fra.origin.y = CGRectGetMidY(frame) - CGRectGetHeight(fra);
        _movedView = [[UIView alloc]initWithFrame:fra];
        _movedView.backgroundColor = [UIColor greenColor];
        _movedView.layer.anchorPoint = CGPointMake(0.5f, 1.f);
        _movedView.frame = fra;
        [self addSubview:_movedView];
    }
    return self;
}


- (void)startClockPointerAnimation
{
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.fromValue = @(0.f);
    rotation.toValue = @(0.7 * M_PI);
    rotation.duration = 0.5f;
    rotation.repeatCount = 0;
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotation.delegate = self;
    rotation.removedOnCompletion = YES;
    [self.movedView.layer addAnimation:rotation forKey:nil];
}

- (void)animationDidStop:(nonnull CAAnimation *)anim finished:(BOOL)flag
{
    CABasicAnimation *a = (CABasicAnimation *)anim;
    _movedView.transform = CGAffineTransformMakeRotation([a.toValue floatValue]);
    if ([_delegate respondsToSelector:@selector(clockProcessDidFinishAnimation:)]) {
        [_delegate clockProcessDidFinishAnimation:self];
        [self removeFromSuperview];
    }
}
@end