//
//  JHLikeButton.m
//  JHKit
//
//  Created by HaoCold on 2018/11/28.
//  Copyright © 2018 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2018 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "JHLikeButton.h"

@interface JHLikeButton()
///
@property (nonatomic,  strong) UIView *normalView;
///
@property (nonatomic,  strong) UIView *likeView;
///
@property (nonatomic,  strong) UIView *circleView1;
///
@property (nonatomic,  strong) UIView *circleView2;
///
@property (nonatomic,  strong) UIView *circleView3;
///
@property (nonatomic,  assign) BOOL  animating;
///
@property (nonatomic,  assign) BOOL  clickAction;
@end

@implementation JHLikeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame)) {
        frame.size.width = 40;
        frame.size.height = 40;
    }
    self = [super initWithFrame:frame];
    if (self) {
        
        _rate = 0.65;
        _color = [UIColor lightGrayColor];
        _likeColor = [UIColor orangeColor];
        
        _circleView1 = [self setupSubview];
        _circleView2 = [self setupSubview];
        _circleView3 = [self setupSubview];
        _normalView  = [self setupSubview];
        _likeView    = [self setupSubview];
        
        _normalView.hidden = NO;
    }
    return self;
}

- (UIView *)setupSubview
{
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = NO;
    view.hidden = YES;
    [self addSubview:view];
    return view;
}

- (void)drawPentagramInView:(UIView *)view color:(UIColor *)color rate:(CGFloat)rate
{
    CGFloat centerX = CGRectGetWidth(view.bounds)*0.5;
    CGFloat centerY = CGRectGetHeight(view.bounds)*0.5;
    
    CGPoint center = CGPointMake(centerX, centerY);
    CGFloat radius = MIN(centerX, centerY);
    
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer.fillColor = [UIColor orangeColor].CGColor;
    if (color) {
        shapeLayer.fillColor = color.CGColor;
    }
    shapeLayer.path = ({
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        // 五角星最上面的点 & the top point of star
        CGPoint first  = CGPointMake(center.x, center.y-radius);
        
        [path moveToPoint:first];
        
        // 点与点之间点夹角为2*M_PI/5.0,要隔一个点才连线
        CGFloat angle=4*M_PI/5.0;
        if (rate > 1.5) {
            rate = 1.5;
        }
        for (int i= 1; i <= 5; i++) {
            CGFloat x = center.x - sinf(i*angle)*radius;
            CGFloat y = center.y - cosf(i*angle)*radius;
            
            CGFloat midx = center.x - sinf(i*angle-2*M_PI/5.0)*radius*rate;
            CGFloat midy = center.y - cosf(i*angle-2*M_PI/5.0)*radius*rate;
            [path addQuadCurveToPoint:CGPointMake(x, y) controlPoint:CGPointMake(midx, midy)];
        }
        
        path.CGPath;
    });
    shapeLayer.lineWidth = 1.0f;
    shapeLayer.lineJoin = kCALineJoinRound;
    [view.layer addSublayer:shapeLayer];
    
}

- (void)drawCircleInView:(UIView *)view color:(UIColor *)color
{
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CGRectGetWidth(self.bounds)*0.5].CGPath;
    [view.layer addSublayer:shapeLayer];
}

- (void)drawLightInView:(UIView *)view color:(UIColor *)color
{
    CGFloat centerX = CGRectGetWidth(view.bounds)*0.5;
    CGFloat centerY = CGRectGetHeight(view.bounds)*0.5;
    
    CGPoint center = CGPointMake(centerX, centerY);
    CGFloat radius = MIN(centerX, centerY);
    
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.path = ({
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        CGFloat minAngle = (2*M_PI/10.0);
        CGFloat angle = minAngle;
        for (int i = 1; i < 6; i++) {
            
            angle = minAngle * (i*2+1);
            
            // 半径为 radius*0.7 的圆上的点
            CGFloat rate = 0.8;
            CGFloat midx = center.x - sinf(angle)*radius*rate;
            CGFloat midy = center.y - cosf(angle)*radius*rate;
            
            // 半径为 radius 的圆上的点
            CGFloat maxx = center.x - sinf(angle)*radius;
            CGFloat maxy = center.y - cosf(angle)*radius;
            
            [path moveToPoint:CGPointMake(midx, midy)];
            [path addLineToPoint:CGPointMake(maxx, maxy)];
        }
        
        path.CGPath;
    });
    shapeLayer.lineWidth = 1.0f;
    shapeLayer.lineJoin = kCALineJoinRound;
    [view.layer addSublayer:shapeLayer];
}

- (void)drawHeartInView:(UIView *)view color:(UIColor *)color
{
    CGRect bounds = view.bounds;
    CGSize size = CGSizeMake(bounds.size.width, bounds.size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color set];
    
    //===> heart path
    CGFloat w = CGRectGetWidth(view.bounds);
    CGFloat radius = w*(7/24.0);
    CGPoint leftPoint = CGPointMake(radius, radius);
    CGPoint rightPoint = CGPointMake(w-radius, radius);
    
    // clockwise 顺时针
    UIBezierPath *leftArc = [UIBezierPath bezierPathWithArcCenter:leftPoint radius:radius startAngle:-M_PI_4 endAngle:M_PI_2+M_PI_4 clockwise:0];
    
    UIBezierPath *rightArc = [UIBezierPath bezierPathWithArcCenter:rightPoint radius:radius startAngle:-M_PI_2-M_PI_4 endAngle:M_PI_4 clockwise:1];
    
    UIBezierPath *line = [UIBezierPath bezierPath];
    [line moveToPoint:CGPointMake(w*0.5,w/12.0)];
    [line addLineToPoint:CGPointMake(w/12.0, w*0.5)];
    [line addLineToPoint:CGPointMake(w*0.5, w)];
    [line addLineToPoint:CGPointMake(w*11/12.0, w*0.5)];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:line];
    [path appendPath:leftArc];
    [path appendPath:rightArc];
    //===>
    
    CGContextAddPath(context, path.CGPath);
    CGContextDrawPath(context, kCGPathEOFill);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.layer.contents = (id)[image CGImage];
}

- (void)drawDotInView:(UIView *)view color:(UIColor *)color
{
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.path = ({
        
        CGFloat W = CGRectGetWidth(view.bounds);
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = W * 0.05;
        CGFloat h = w;
        
        UIBezierPath *dot1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, w, h) cornerRadius:w*0.5];
        
        x = W - w;
        UIBezierPath *dot2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, w, h) cornerRadius:w*0.5];
        
        x = W * 0.0375;
        y = W * 0.7;
        w = W * 0.1;
        h = w;
        UIBezierPath *dot3 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, w, h) cornerRadius:w*0.5];
        
        x = W - x - w;
        UIBezierPath *dot4 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, w, h) cornerRadius:w*0.5];
        
        x = W * 0.275;
        y = W * 0.875;
        w = W * 0.075;
        h = w;
        UIBezierPath *dot5 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, w, h) cornerRadius:w*0.5];
        
        x = W - x - w;
        UIBezierPath *dot6 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, w, h) cornerRadius:w*0.5];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path appendPath:dot1];
        [path appendPath:dot2];
        [path appendPath:dot3];
        [path appendPath:dot4];
        [path appendPath:dot5];
        [path appendPath:dot6];
        
        path.CGPath;
    });
    [view.layer addSublayer:shapeLayer];
}

#pragma mark - override

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    _clickAction = YES;
    [self preAnimation];
    return YES;
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event
{
    CGPoint point = [touch locationInView:touch.view];
    
    if (0 - _touchInsets.left <= point.x &&
        0 - _touchInsets.top <= point.y &&
        CGRectGetWidth(self.frame) + _touchInsets.right >= point.x &&
        CGRectGetHeight(self.frame) + _touchInsets.bottom >= point.y){
        [self startAnimation];
    }else{
        [self cancelPreAnimation];
    }
}

- (void)cancelTrackingWithEvent:(nullable UIEvent *)event
{
    [self startAnimation];
}

#pragma mark - private

- (void)preAnimation
{
    self.userInteractionEnabled = NO;
    if (!_like) {
        _normalView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }else{
        _likeView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }
}

- (void)cancelPreAnimation
{
    self.userInteractionEnabled = YES;
    if (!_like) {
        _normalView.transform = CGAffineTransformMakeScale(1, 1);
    }else{
        _likeView.transform = CGAffineTransformMakeScale(1, 1);
    }
}

- (void)stopAnimation
{
    if (!_like) {
        _like = YES;
        _animating = YES;
        [self startAnimation];
    }else{
        _like = NO;
        _normalView.hidden = NO;
        _likeView.hidden = YES;
        
        _normalView.transform = CGAffineTransformMakeScale(1, 1);
        _likeView.transform = CGAffineTransformIdentity;
        self.userInteractionEnabled = YES;
        
        [self clickFinish];
    }
}

- (void)scaleAnimationForView:(UIView *)view values:(NSArray *)values duration:(CFTimeInterval)duration beginTimeOffset:(CGFloat)offset timingFunction:(CAMediaTimingFunctionName)functionName keepLastStatus:(BOOL)keep
{
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.values = values;
    scaleAnimation.duration = duration;
    if (keep) {
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
    }
    scaleAnimation.beginTime = CACurrentMediaTime()+offset;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:functionName];
    [view.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)clickFinish
{
    [_normalView.layer  removeAnimationForKey:@"scaleAnimation"];
    [_likeView.layer    removeAnimationForKey:@"scaleAnimation"];
    [_circleView1.layer removeAnimationForKey:@"scaleAnimation"];
    [_circleView2.layer removeAnimationForKey:@"scaleAnimation"];
    [_circleView3.layer removeAnimationForKey:@"scaleAnimation"];
    
    if (_clickBlock) {
        _clickBlock(_like);
    }
}

#pragma mark - public

- (void)prepare
{
    _normalView.frame = self.bounds;
    _likeView.frame = self.bounds;
    _circleView1.frame = self.bounds;
    _circleView2.frame = self.bounds;
    _circleView3.frame = self.bounds;
    
    [self drawCircleInView:_circleView1 color:_likeColor];
    [self drawCircleInView:_circleView2 color:[UIColor whiteColor]];
    
    if (_type == JHLikeButtonType_Star) {
        [self drawLightInView:_circleView3 color:_likeColor];
        [self drawPentagramInView:_normalView color:_color rate:_rate];
        [self drawPentagramInView:_likeView color:_likeColor rate:_rate];
    }
    else if (_type == JHLikeButtonType_Heart) {
        [self drawDotInView:_circleView3 color:_likeColor];
        [self drawHeartInView:_normalView color:_color];
        [self drawHeartInView:_likeView color:_likeColor];
    }
}

- (void)startAnimation
{
    if (!_like) {
        
        _like = YES;
        _animating = YES;
        
        // Zoom out the dark view / 缩小
        [self scaleAnimationForView:_normalView values:@[@(1),@(0.2)] duration:0.2 beginTimeOffset:0  timingFunction:kCAMediaTimingFunctionEaseOut keepLastStatus:YES];
        
        // Zoom in the first circle / 放大
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _normalView.hidden = YES;
            _circleView1.hidden = NO;
            
            [self scaleAnimationForView:_circleView1 values:@[@(0),@(1)] duration:0.3 beginTimeOffset:0 timingFunction:kCAMediaTimingFunctionEaseIn keepLastStatus:NO];
        });
        
        // Zoom in the second circle / 放大
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[_normalView.layer removeAnimationForKey:@"scaleAnimation"];
            _circleView2.hidden = NO;
            
            [self scaleAnimationForView:_circleView2 values:@[@(0),@(1.1)] duration:0.3 beginTimeOffset:0 timingFunction:kCAMediaTimingFunctionEaseOut keepLastStatus:YES];
        });
        
        // Zoom in the light view / 放大
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _likeView.hidden = NO;
            
            [self scaleAnimationForView:_likeView values:@[@(0.2),@(1)] duration:0.3 beginTimeOffset:0 timingFunction:kCAMediaTimingFunctionEaseOut keepLastStatus:NO];
        });
        
        // Flash
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _circleView3.hidden = NO;
            
            if (_type == JHLikeButtonType_Star) {
                [self scaleAnimationForView:_circleView3 values:@[@(0.2),@(1.1)] duration:0.3 beginTimeOffset:0 timingFunction:kCAMediaTimingFunctionEaseOut keepLastStatus:YES];
            }else if (_type == JHLikeButtonType_Heart) {
                
            }
        });
        
        // Finish / 完成
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _circleView1.hidden = YES;
            _circleView2.hidden = YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _circleView3.hidden = YES;
                _animating = NO;
                self.userInteractionEnabled = YES;
                
                [self clickFinish];
            });
        });
    }
    else{
        _like = NO;
        
        if (!_clickAction) {
            
            _likeView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _normalView.hidden = NO;
                _likeView.hidden = YES;
                _likeView.transform = CGAffineTransformIdentity;
            });
        }else{
            _normalView.hidden = NO;
            _likeView.hidden = YES;
            _normalView.transform = CGAffineTransformIdentity;
            _likeView.transform = CGAffineTransformIdentity;
        }
        
        self.userInteractionEnabled = YES;
        
        [self clickFinish];
    }
}

- (void)setLike:(BOOL)like
{
    _like = like;
    if (!_animating) {
        if (like) {
            _normalView.hidden = YES;
            _likeView.hidden = NO;
        }else{
            _normalView.hidden = NO;
            _likeView.hidden = YES;
        }
    }
}

- (void)setLike:(BOOL)like animated:(BOOL)animated
{
    if (animated) {
        _like = !like;
        [self startAnimation];
    }else{
        self.like = like;
    }
}

@end
