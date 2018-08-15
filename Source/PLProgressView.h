//
//  PLProgressView.h
//  PLProgressViewDemo
//
//  Created by qmtv on 2018/8/15.
//  Copyright © 2018年 clOud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLProgressView : UIView <CAAnimationDelegate>

@property(nonatomic, strong) UIColor *trackTintColor;     /**<圆环底色*/
@property(nonatomic, strong) UIColor *progressTintColor;
@property(nonatomic) bool roundedCorners;    /**<头部是否圆角*/
@property(nonatomic) CGFloat progressWidth;        /**<圆环宽度*/
@property(nonatomic) CGFloat progress;
@property(nonatomic) bool clockwiseProgress;      /**<顺时针或逆时针*/

@property (nonatomic) CGFloat startAngle;   /**<开始角度*/
@end
