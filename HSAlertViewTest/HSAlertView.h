//
//  HSAlertView.h
//
//  Created by 吴海生 on 16/7/10.
//  Copyright © 2016年 Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HSAlertViewStyle) {
    HSAlertViewStyleDefault = 0,
};

@protocol HSAlertViewDelegate;

@interface HSAlertView : UIView

@property (nonatomic, assign) HSAlertViewStyle alertViewStyle;
@property (nonatomic, weak) id <HSAlertViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, readonly) NSInteger numberOfButtons;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id <HSAlertViewDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
           confirmButtonTitle:(NSString *)confirmButtonTitle
             otherButtonTitle:(NSString *)otherButtonTitle;

- (NSInteger)addButtonWithTitle:(NSString *)title;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

- (void)show;

// hides alert sheet or popup. use this method when you need to explicitly dismiss the alert.
// it does not need to be called if the user presses on a button
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

- (void)setFont:(UIFont *)font titleColor:(UIColor *)color forButtonAtIndex:(NSInteger)buttonIndex;

@end


@protocol HSAlertViewDelegate <NSObject>

@optional

- (void)alertView:(HSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)willPresentAlertView:(HSAlertView *)alertView;
- (void)didPresentAlertView:(HSAlertView *)alertView;

- (void)alertView:(HSAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)alertView:(HSAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end