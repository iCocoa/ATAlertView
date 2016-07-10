//
//  HSAlertView.m
//
//  Created by 吴海生 on 16/7/10.
//  Copyright © 2016年 Hansen. All rights reserved.
//

#import "HSAlertView.h"

static CGFloat p_realSize(CGFloat size)
{
    return [UIScreen mainScreen].bounds.size.width / 375.0f * size;
}

static const NSTimeInterval kAnimationTime = 0.4;

static const CGFloat kTitleLabelHeight = 35;
static const CGFloat kHSAlertViewWidth = 260;
static const CGFloat kSeparatorLineWidth = 0.5;
static const CGFloat kButtonHeight = 44;

@interface HSAlertView ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *buttonContainer;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) NSArray *lastButtonConstraints;


@end

@implementation HSAlertView

#pragma mark - Public method
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id<HSAlertViewDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
           confirmButtonTitle:(NSString *)confirmButtonTitle
             otherButtonTitle:(NSString *)otherButtonTitle
{
    self = [super init];
    if (self) {
        self.hidden = YES;
        self.frame = [UIScreen mainScreen].bounds;
        self.alertViewStyle = HSAlertViewStyleDefault;
        [self addSubview:self.backgroundView];
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.titleLabel];
        [self.alertView addSubview:self.contentLabel];
        [self.alertView addSubview:self.buttonContainer];
        
        self.delegate = delegate;
        self.titleLabel.text = title;
        self.contentLabel.text = message;
        [self addButtonWithTitle:cancelButtonTitle];
        [self addButtonWithTitle:confirmButtonTitle];
        [self addButtonWithTitle:otherButtonTitle];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    NSLayoutConstraint *alertViewCenterX = [NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *alertViewCenterY = [NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *alertViewWidth = [NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kHSAlertViewWidth];
    [self addConstraints:@[alertViewCenterX,alertViewCenterY,alertViewWidth]];
    
    NSLayoutConstraint *titleLabelTop = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.alertView attribute:NSLayoutAttributeTop multiplier:1 constant:p_realSize(10)];
    NSLayoutConstraint *titleLabelLeading = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.alertView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *titleLabelTrailing = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.alertView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *titleLabelHeight = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kTitleLabelHeight];
    [self.alertView addConstraints:@[titleLabelTop,titleLabelLeading,titleLabelTrailing,titleLabelHeight]];
    
    NSLayoutConstraint *contentLabelTop = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *contentLabelLeading = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.alertView attribute:NSLayoutAttributeLeading multiplier:1 constant:p_realSize(20)];
    NSLayoutConstraint *contentLabelTrailing = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.alertView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-p_realSize(20)];
    [self.alertView addConstraints:@[contentLabelTop,contentLabelLeading,contentLabelTrailing]];
    
    NSLayoutConstraint *buttonContainerTop = [NSLayoutConstraint constraintWithItem:self.buttonContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:p_realSize(20)];
    NSLayoutConstraint *buttonContainerLeading = [NSLayoutConstraint constraintWithItem:self.buttonContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.alertView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *buttonContainerTrailing = [NSLayoutConstraint constraintWithItem:self.buttonContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.alertView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *buttonContainerBottom = [NSLayoutConstraint constraintWithItem:self.buttonContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.alertView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.alertView addConstraints:@[buttonContainerTop,buttonContainerLeading,buttonContainerTrailing,buttonContainerBottom]];
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    if (title.length > 0) {
        
        UIButton *button = [[UIButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:p_realSize(20)];
        UIColor *normalColor = [UIColor darkGrayColor];
        [button setTitleColor:normalColor forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContainer addSubview:button];
        
        if (self.buttons.count > 0) {
            
            UIColor *normalColor = [UIColor orangeColor]; //#e5a172
            [button setTitleColor:normalColor forState:UIControlStateNormal];
            
            UIButton *lastButton = [self.buttons lastObject];// 最近一次添加的button
            NSInteger lastButtonindex = [self.buttons indexOfObject:lastButton];
            
            [self.buttonContainer removeConstraints:self.lastButtonConstraints];
            
            if (lastButtonindex == 0) {
                
                NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeTop multiplier:1 constant:kSeparatorLineWidth];
                NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
                NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
                NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeLeading multiplier:1 constant:-kSeparatorLineWidth];
                NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kButtonHeight];
                [self.buttonContainer addConstraints:@[top,leading,bottom,trailing,height]];
                
            } else {
                
                UIButton *preButton = [self.buttons objectAtIndex:(lastButtonindex - 1)];
                
                NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeTop multiplier:1 constant:kSeparatorLineWidth];
                NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:preButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:kSeparatorLineWidth];
                NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
                NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeLeading multiplier:1 constant:-kSeparatorLineWidth];
                NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:preButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
                NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kButtonHeight];
                [self.buttonContainer addConstraints:@[top,leading,bottom,trailing,width,height]];
            }
            
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeTop multiplier:1 constant:kSeparatorLineWidth];
            NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:kSeparatorLineWidth];
            NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kButtonHeight];
            self.lastButtonConstraints = @[top,leading,bottom,trailing,width,height];
            [self.buttonContainer addConstraints:self.lastButtonConstraints];
            
        } else {
            
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeTop multiplier:1 constant:kSeparatorLineWidth];
            NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
            NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kButtonHeight];
            self.lastButtonConstraints = @[top,leading,bottom,trailing,height];
            [self.buttonContainer addConstraints:self.lastButtonConstraints];
            
        }
        
        [self.buttons removeObject:button];
        [self.buttons addObject:button];
    }
    
    return self.buttons.count - 1;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    if (self.buttons.count > buttonIndex) {
        UIButton *button = [self.buttons objectAtIndex:buttonIndex];
        return button.titleLabel.text;
    } else {
        return nil;
    }
}

- (void)show
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.hidden = NO;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
        [self.delegate didPresentAlertView:self];
    }
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
    }
    
    [self dismiss];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
    }
}

- (NSInteger)numberOfButtons
{
    return self.buttons.count;
}

- (void)setFont:(UIFont *)font titleColor:(UIColor *)color forButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.buttons.count > buttonIndex) {
        UIButton *button = [self.buttons objectAtIndex:buttonIndex];
        button.titleLabel.font = font;
        [button setTitleColor:color forState:UIControlStateNormal];
    }
}

#pragma mark - Private method
- (void)buttonClick:(UIButton *)sender
{
    NSInteger index = [self.buttons indexOfObject:sender];
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:index];
    }
    [self dismissWithClickedButtonIndex:index animated:YES];
}

- (void)dismiss
{
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.hidden = YES;
    }];
    [self removeFromSuperview];
}

#pragma mark - Setter method
- (void)setAlertViewStyle:(HSAlertViewStyle)alertViewStyle
{
    _alertViewStyle = alertViewStyle;
    if (_alertViewStyle == HSAlertViewStyleDefault) {
        
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:p_realSize(20)];
        
        self.contentLabel.backgroundColor = [UIColor whiteColor];
        self.contentLabel.textColor = [UIColor darkGrayColor];
        self.contentLabel.font = [UIFont systemFontOfSize:p_realSize(15)];
    }
}

#pragma mark - Getter method
- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor grayColor];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundView.alpha = 0.2f;
    }
    return _backgroundView;
}

- (UIView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.translatesAutoresizingMaskIntoConstraints = NO;
        _alertView.alpha = 0.95;
    }
    return _alertView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentLabel;
}

- (UIView *)buttonContainer
{
    if (!_buttonContainer) {
        _buttonContainer = [[UIView alloc]init];
        _buttonContainer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _buttonContainer;
}

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end
