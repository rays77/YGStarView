//
//  YGStarView.h
//  iOutletShopping
//
//  Created by Ray on 2017/6/12.
//  Copyright © 2017年 aolaigo. All rights reserved.
//
//

#import <UIKit/UIKit.h>
@class YGStarView;

#define YGSTARTNOR    @"btn_assessment_center_star_normaled"
#define YGSTARTSEL    @"btn_assessment_center_star_pressed"

typedef void(^CompleteBlock)(CGFloat score);

typedef NS_ENUM(NSInteger, YGStarStyle)
{
    FullStar = 0, /**< 整星 */
    HalfStar, /**< 半星 */
    IncompleteStar /**< 不完整评星 */
};

@protocol YGStarViewDelegate <NSObject>

- (void)starView:(YGStarView *)starView score:(CGFloat)score;

@end

@interface YGStarView : UIView

@property (nonatomic, strong) UIImage *norImage;
@property (nonatomic, strong) UIImage *selImage;
@property (nonatomic, assign) NSInteger numberOfStars;
@property (nonatomic, assign) CGFloat score; /**< 评分：0-5，默认1 */
@property (nonatomic, assign) BOOL isThumbStar; /**< 是否开启评星，默认YES */
@property (nonatomic, assign) BOOL isAnimation; /**< 是否动画显示，默认NO */
@property (nonatomic, assign) BOOL isNoStar; /**< 是否允许评0星，默认NO */
@property (nonatomic, assign) YGStarStyle starStyle; /**< 评分样式，默认是FullStar */
@property (nonatomic, weak) id<YGStarViewDelegate>delegate; /**< 点击评星时的回调 */
@property (nonatomic, copy) CompleteBlock complete;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame starStyle:(YGStarStyle)starStyle isAnination:(BOOL)isAnimation delegate:(id)delegate;

- (instancetype)initWithFrame:(CGRect)frame complete:(CompleteBlock)complete;
- (instancetype)initWithFrame:(CGRect)frame starStyle:(YGStarStyle)starStyle isAnination:(BOOL)isAnimation complete:(CompleteBlock)complete;

/** 创建评星 */
- (void)createStarView;

@end
