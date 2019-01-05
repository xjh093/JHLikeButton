//
//  JHLikeButton.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JHLikeButtonClickBlock)(BOOL like);

typedef NS_ENUM(NSUInteger, JHLikeButtonType) {
    JHLikeButtonType_Star,
    JHLikeButtonType_Heart,
};

/// A button for 👍
@interface JHLikeButton : UIControl

/// Normal theme color.
@property (nonatomic,  strong) UIColor *color;
/// Like theme color.
@property (nonatomic,  strong) UIColor *likeColor;
/// Default is 0.65. The suggest value range is 0.3 ~ 1.1.
@property (nonatomic,  assign) CGFloat  rate;
/// 
@property (nonatomic,  assign) BOOL  like;
///
@property (nonatomic,  assign,  readonly) BOOL  animating;
///
@property (nonatomic,    copy) JHLikeButtonClickBlock clickBlock;
/// Default is 'JHLikeButtonType_Star'
@property (nonatomic,  assign) JHLikeButtonType  type;
/// Make touch area bigger
@property (nonatomic,  assign) UIEdgeInsets  touchInsets;

/// Call it before 'startAnimation'.
- (void)prepare;
/// Start animation if 'like' is 'NO'.
- (void)startAnimation;
///
- (void)setLike:(BOOL)like animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
