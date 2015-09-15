//
//  QCClockLoadingView.h
//  PieProgress
//
//  Created by MingLi on 15/8/23.
//  Copyright © 2015年 mingli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  LMClockLoadingViewDelegate<NSObject>
@optional
- (void)clockViewDidFinish;
@end

@interface LMClockLoadingView : UIView
@property (nonatomic, weak) id<LMClockLoadingViewDelegate> delegate;
- (void)beginLoadingAnimation;
@end
