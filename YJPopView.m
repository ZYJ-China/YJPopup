//
//  YJAlertView.m
//  Animaiton
//
//  Created by  ZhouYingJie on 16/5/17.
//  Copyright © 2016年 ZhouYingJie. All rights reserved.
//

#import "YJPopView.h"

@interface YJPopView () {
    CGFloat viewHeight;
    NSInteger style;
}
@property (nonatomic, strong) YJPopView *alertView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *button;
@end

@implementation YJPopView
- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.layer.cornerRadius = 8.0f;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        [KeyWindow addSubview:_backView];
    }
    return _backView;
}
- (instancetype)initWithItems:(NSArray *)items type:(YJPopViewStyle)type{
    if (self == [super init]){
        style = type;
        viewHeight = items.count * ButtonHeight;
        YJPopView *alertView = [self init];
        self.alertView = alertView;
        
        alertView.frame = [UIScreen mainScreen].bounds;
        alertView.backgroundColor = [UIColor blackColor];
        [KeyWindow addSubview:alertView];
        alertView.alpha = 0.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [alertView addGestureRecognizer:tap];
        
        switch (type) {
            case 1:{
                [self setupAlertView:items with:viewWidth];
            }
                break;
            case 2:{
                [self setupSheetView:items];
            }
                break;
//            case 3:{
//                [self setupMsgView:items];
//            }
//                break;
            default:
                break;
        }
        
    }
    return self;
}
//alertView
- (void)setupAlertView:(NSArray *)items with:(CGFloat)width{
    [self configure:width];

    for (int i=0; i<items.count; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, ButtonHeight*i, width, ButtonHeight)];
        [button setTitle:items[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        button.tag = i+1;
        [button addTarget:self action:@selector(clickedButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:button];
        self.button = button;
        
        // 最上面画分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, ButtonHeight-0.5, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.3;
        [button addSubview:line];
    }
}
//actionSheet
- (void)setupSheetView:(NSArray *)items{
    [self setupAlertView:items with:ScreenWidth];
    self.backView.frame = CGRectMake(0, 0, ScreenWidth, 0);
    self.backView.center = KeyWindow.center;
    self.backView.layer.cornerRadius = 0;
    CGRect sheetViewF = self.backView.frame;
    sheetViewF.size.height = ButtonHeight *items.count + 50;
    self.backView.frame = sheetViewF;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, viewHeight+5, ScreenWidth, ButtonHeight)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(sheetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:btn];
}
//提示
- (void)setupMsgView:(NSArray *)items{
    NSString *msg = items[0];
    UILabel *msgLabel = [UILabel new];
    msgLabel.backgroundColor = [UIColor whiteColor];
    msgLabel.text = msg;
    msgLabel.font = [UIFont systemFontOfSize:14.0f];
    msgLabel.numberOfLines = 0;
    
    CGSize size = [self sizeWithString:msg font:[UIFont systemFontOfSize:14.0f] rect:CGSizeMake(viewWidth-20, MAXFLOAT)];
    msgLabel.frame = CGRectMake(10, 10, viewWidth-20, size.height);
    self.backView.frame = CGRectMake(0, 0, viewWidth, size.height + 60);
    self.backView.center = KeyWindow.center;
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:msgLabel];
}


- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font rect:(CGSize)size {
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    return actualsize;
}

- (void)configure:(CGFloat)width{
    self.backView.frame = CGRectMake(0, 0, width, viewHeight);
    self.backView.center = KeyWindow.center;
    self.backView.hidden = YES;
}
- (void)show {
    __weak YJPopView *weakSelf = self;
    if (style == 2){
        CGRect sheetViewF = self.backView.frame;
        sheetViewF.origin.y = ScreenHeight;
        self.backView.frame = sheetViewF;

        CGRect newSheetViewF = self.backView.frame;
        newSheetViewF.origin.y = ScreenHeight - self.backView.frame.size.height;
        
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.alertView.alpha = 0.3;
            weakSelf.backView.hidden = NO;
            self.backView.frame = newSheetViewF;
        }];
    }else{
    
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.alertView.alpha = 0.3;
            weakSelf.backView.hidden = NO;
            [weakSelf springbackAnimation:weakSelf.backView];
        }];
    }
}
- (void)dismiss {
    __weak YJPopView *weakSelf = self;
    if (style == 2){
        CGRect sheetViewF = self.backView.frame;
        sheetViewF.origin.y = ScreenHeight;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.backView.frame = sheetViewF;
            weakSelf.alertView.alpha = 0.0;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.alertView.alpha = 0.0;
            [weakSelf.backView setBounds:CGRectMake(weakSelf.backView.frame.size.width/2, weakSelf.backView.frame.size.height/2,0,0)];
        } completion:^(BOOL finished) {
            weakSelf.backView.hidden = YES;
            [weakSelf.backView setBounds:CGRectMake(weakSelf.backView.frame.size.width/2, weakSelf.backView.frame.size.height/2,viewWidth,viewHeight)];
        }];
    }
    
}
- (void)sheetBtnClick{
    [self dismiss];
}
- (void)clickedButtonAtIndex:(UIButton *)btn {
    [self dismiss];
    self.selectBlock(btn.tag-1);
}
- (void)didSelectItem:(void (^)(NSInteger))index {
    self.selectBlock = index;
}
- (void)springbackAnimation:(UIView *)theView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [theView.layer addAnimation:animation forKey:nil];
}
@end

@interface YJAlertView ()
@property (nonatomic, strong) UIAlertController *alert;

@end

@implementation YJAlertView
- (instancetype)initWithItems:(NSArray *)items sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle onTap:(void(^)(NSInteger index))onTapBlock{
    if (self == [super init]){
        UIAlertController *alert;
        if (items.count == 1){
            alert = [UIAlertController alertControllerWithTitle:@"" message:items[0] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(onTapBlock){
                    onTapBlock(0);
                }
            }]];
        }else if (items.count == 2){
            alert = [UIAlertController alertControllerWithTitle:items[0] message:items[1] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(onTapBlock){
                    onTapBlock(0);
                }
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(onTapBlock){
                    onTapBlock(1);
                }
            }]];
        }else{
            alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            for(int i=0; i<items.count; i++){
                [alert addAction:[UIAlertAction actionWithTitle:items[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if(onTapBlock){
                        onTapBlock(i);
                    }
                }]];
            }
        }
        
        self.alert = alert;
    }
    return self;
    
}




- (void)show:(UIViewController *)vc {
    
    [[UIView appearance]setTintColor:self.titleColor];
    [vc presentViewController:self.alert animated:YES completion:nil];
}

@end

