//
//  YJAlertView.h
//  Animaiton
//
//  Created by  ZhouYingJie on 16/5/17.
//  Copyright © 2016年 ZhouYingJie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YJPopViewStyle) {
    YJPopViewStyleAlert       = 1,
    YJPopViewStyleSheet       = 2,
    YJPopViewStyleMsg         = 3
};

#define ScreenHeight    [UIScreen mainScreen].bounds.size.height
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ButtonHeight     45
#define KeyWindow       [UIApplication sharedApplication].keyWindow
#define viewWidth      ScreenWidth - 140

@interface YJPopView : UIView
@property (nonatomic, strong) void(^selectBlock)(NSInteger index);


//初始化
-(instancetype)initWithItems:(NSArray *)items type:(YJPopViewStyle)type;
//点击
- (void)didSelectItem:(void(^)(NSInteger index))index;

- (void)show;
- (void)dismiss;

@end

@interface YJAlertView : UIAlertController
@property (nonatomic, strong) UIColor *titleColor; //字体颜色

- (instancetype)initWithItems:(NSArray *)items sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle onTap:(void(^)(NSInteger index))onTapBlock;

- (void)show:(UIViewController *)vc;
@end