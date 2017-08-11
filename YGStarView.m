//
//  YGStarView.h
//  iOutletShopping
//
//  Created by Ray on 2017/6/12.
//  Copyright © 2017年 aolaigo. All rights reserved.
//

#import "YGStarView.h"

@interface YGStarView()

@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;

@end

@implementation YGStarView

#pragma mark - Nib方式
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _numberOfStars = 5;
        _score = 1;
        _isNoStar = NO;
        _starStyle = FullStar;
        _isThumbStar = YES;
    }
    return self;
}

#pragma mark - delegate方式
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _score = 1;
        _isNoStar = NO;
        _starStyle = FullStar;
        _isThumbStar = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame starStyle:(YGStarStyle)starStyle isAnination:(BOOL)isAnimation delegate:(id)delegate  {
    if (self = [super initWithFrame:frame]) {
        _score = 1;
        _isNoStar = NO;
        _starStyle = starStyle;
        _isAnimation = isAnimation;
        _delegate = delegate;
        _isThumbStar = YES;
    }
    return self;
}

#pragma mark - block方式
- (instancetype)initWithFrame:(CGRect)frame complete:(CompleteBlock)complete {
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _score = 1;
        _isNoStar = NO;
        _starStyle = FullStar;
        _isThumbStar = YES;
        _complete = complete;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame starStyle:(YGStarStyle)starStyle isAnination:(BOOL)isAnimation complete:(CompleteBlock)complete {
    if (self = [super initWithFrame:frame]) {
        _score = 1;
        _isNoStar = NO;
        _starStyle = starStyle;
        _isAnimation = isAnimation;
        _isThumbStar = YES;
        _complete = complete;
    }
    return self;
}

#pragma mark - private Method
- (void)createStarView
{
    if (_selImage == nil) {
        _selImage = [UIImage imageNamed:YGSTARTSEL];
    }
    
    if (_norImage == nil) {
        _norImage = [UIImage imageNamed:YGSTARTNOR];
    }
    
    self.foregroundStarView = [self createStarViewWithImage:self.selImage];
    self.backgroundStarView = [self createStarViewWithImage:self.norImage];
    self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width*_score/self.numberOfStars, self.bounds.size.height);
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    
    if (_isThumbStar) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapStarView:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
}

- (UIView *)createStarViewWithImage:(UIImage *)image {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark - 评星点击事件
- (void)userTapStarView:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    CGFloat offset = point.x;
    CGFloat realScore = offset / (self.bounds.size.width / self.numberOfStars);
    
    switch (_starStyle) {
        case FullStar:
        {
            CGFloat s = ceilf(realScore);
            if (_isNoStar && (_score == s) && _score == 1.0) {
                s = 0;
            }
            self.score = s;
            break;
        }
        case HalfStar:
        {
            self.score = roundf(realScore)>realScore ? ceilf(realScore):(ceilf(realScore)-0.5);
            break;
        }
        case IncompleteStar:
        {
            self.score = realScore;
            break;
        }
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak YGStarView *weakSelf = self;
    CGFloat animationTimeInterval = self.isAnimation ? 0.2 : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        weakSelf.foregroundStarView.frame = CGRectMake(0, 0, weakSelf.bounds.size.width * weakSelf.score/self.numberOfStars, weakSelf.bounds.size.height);
    }];
}

- (void)setScore:(CGFloat)score {
    if (_score == score) {
        return;
    }
    if (score < 0) {
        _score = 0;
    } else if (score > _numberOfStars) {
        _score = _numberOfStars;
    } else {
        _score = score;
    }
    
    if ([self.delegate respondsToSelector:@selector(starView:score:)]) {
        [self.delegate starView:self score:_score];
    }
    
    if (self.complete) {
        _complete(_score);
    }
    
    [self setNeedsLayout];
}

@end
