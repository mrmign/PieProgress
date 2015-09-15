//
//  Progress.h
//  KeyframeAni
//
//  Created by armingli on 15/8/21.
//  Copyright © 2015年 armingli. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LMPieProgressViewDelegate <NSObject>
@optional

- (void)pieProgressDidFinishAnimation;
@end
@interface LMPieProgressView : UIView
@property (nonatomic, weak) id<LMPieProgressViewDelegate> delegate;
- (void)beginAnimation;

- (void)stopAnimation;
@end


@class LMClockPointerProgressView;
@protocol LMClockPointerProgressViewDelegate<NSObject>
@optional

- (void)clockProcessDidFinishAnimation:(LMClockPointerProgressView*)clockView;
@end
@interface LMClockPointerProgressView : UIView
@property (nonatomic, weak) id<LMClockPointerProgressViewDelegate> delegate;
- (void)startClockPointerAnimation;
@end