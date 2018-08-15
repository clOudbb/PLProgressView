//
//  PLProgressView.m
//  PLProgressViewDemo
//
//  Created by qmtv on 2018/8/15.
//  Copyright © 2018年 clOud. All rights reserved.
//

#import "PLProgressView.h"
#define ANGLE(angle) (M_PI * angle / 180)

@interface PLProgressLayer : CALayer
@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property(nonatomic) bool roundedCorners;    /**<头部是否圆角*/
@property(nonatomic) CGFloat progressWidth;        /**<圆环宽度*/
@property(nonatomic) CGFloat progress;
@property(nonatomic) bool clockwiseProgress;      /**<顺时针或逆时针*/
@property (nonatomic) CGFloat startAngle;   /**<开始角度*/
@end

@implementation PLProgressLayer
//这里的dynamic有个坑，如果不声明dynamic 在drawContext方法里获取的全局变量会有几率为null，目前原因未知
@dynamic trackTintColor;
@dynamic progressTintColor;
@dynamic roundedCorners;
@dynamic progress;
@dynamic clockwiseProgress;
@dynamic startAngle;
@dynamic progressWidth;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"progress"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (instancetype)init
{
    if (self = [super init]) {
        self.drawsAsynchronously = true;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGRect rect = self.bounds;
    //    CGFloat radius = rect.size.width / 2;
    //    CGPoint centerPoint = (CGPoint){rect.size.width / 2, rect.size.height / 2};
    
    CGFloat start = self.startAngle;
    CGFloat end = self.progress * 360 + start;  //这里要加上起始的角度
    
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGContextSetStrokeColorWithColor(ctx, self.trackTintColor.CGColor);
    CGContextSetLineWidth(ctx, self.progressWidth);
    CGContextAddArc(ctx, rect.size.width / 2, rect.size.height / 2, rect.size.width / 2 - self.progressWidth / 2, ANGLE(0), ANGLE(360), self.clockwiseProgress);
    CGContextAddPath(ctx, trackPath);
    CGContextStrokePath(ctx);
    CGPathRelease(trackPath);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetStrokeColorWithColor(ctx, self.progressTintColor.CGColor);
    if (self.roundedCorners) {
        CGContextSetLineCap(ctx, kCGLineCapRound);
    }
    CGContextSetLineWidth(ctx, self.progressWidth);
    CGContextAddArc(ctx, rect.size.width / 2, rect.size.height / 2, rect.size.width / 2 - self.progressWidth / 2, ANGLE(start), ANGLE(end), self.clockwiseProgress);
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    CGPathRelease(path);
    
    //中间裁剪方案 暂不用
    //    CGContextSetFillColorWithColor(ctx, self.trackTintColor.CGColor);
    //    CGMutablePathRef trackPath = CGPathCreateMutable();
    //    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    //    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, ANGLE(0), ANGLE(360), false);
    //    CGPathCloseSubpath(trackPath);
    //    CGContextAddPath(ctx, trackPath);
    //    CGContextDrawPath(ctx, kCGPathFill);
    //    CGPathRelease(trackPath);
    
    //    CGContextSetFillColorWithColor(ctx, self.progressTintColor.CGColor);
    //    CGMutablePathRef tintPath = CGPathCreateMutable();
    //    CGPathMoveToPoint(tintPath, NULL, centerPoint.x, centerPoint.y);
    //    CGPathAddArc(tintPath, NULL, centerPoint.x, centerPoint.y, rect.size.width / 2, ANGLE(start), ANGLE(end), false);
    //    CGPathCloseSubpath(tintPath);
    //    CGContextAddPath(ctx, tintPath);
    //    CGContextDrawPath(ctx, kCGPathFill);
    //    CGPathRelease(tintPath);
    //
    //    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    //    CGContextAddEllipseInRect(ctx, CGRectMake(self.progressWidth, self.progressWidth, rect.size.width - self.progressWidth * 2, rect.size.height - self.progressWidth * 2));
    //    CGContextDrawPath(ctx, kCGPathFill);
    
}

@end


@implementation PLProgressView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+ (Class)layerClass
{
    return PLProgressLayer.class;
}

- (PLProgressLayer *)progressLayer
{
    return (PLProgressLayer *)self.layer;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    //设置分辨率
    CGFloat windowContentsScale = self.window.screen.scale;
    self.progressLayer.contentsScale = windowContentsScale;
    [self.progressLayer setNeedsDisplay];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - private property


#pragma mark - public property
- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    self.progressLayer.trackTintColor = trackTintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    self.progressLayer.progressTintColor = progressTintColor;
}

- (CGFloat)progress
{
    return self.progressLayer.progress;
}

- (void)setProgress:(CGFloat)progress
{
    //    self.progressLayer.progress = progress;
    //    [self.progressLayer setNeedsDisplay];
    CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
    CFTimeInterval duration = fabs(self.progress - pinnedProgress);
    [self.progressLayer removeAnimationForKey:@"progressAnimation"];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSNumber numberWithFloat:self.progress];
    animation.toValue = [NSNumber numberWithFloat:pinnedProgress];
    animation.beginTime = CACurrentMediaTime() + 0;
    animation.delegate = self;
    [self.progressLayer addAnimation:animation forKey:@"progressAnimation"];
    
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    NSNumber *pinnedProgressNumber = [animation valueForKey:@"toValue"];
    self.progressLayer.progress = [pinnedProgressNumber floatValue];
}

- (void)setStartAngle:(CGFloat)startAngle
{
    self.progressLayer.startAngle = startAngle;
}

- (void)setProgressWidth:(CGFloat)progressWidth
{
    self.progressLayer.progressWidth = progressWidth;
}

- (void)setClockwiseProgress:(bool)clockwiseProgress
{
    self.progressLayer.clockwiseProgress = clockwiseProgress;
}

- (void)setRoundedCorners:(bool)roundedCorners
{
    self.progressLayer.roundedCorners = roundedCorners;
}

@end



