//
//  ViewController.m
//  HSAlertViewTest
//
//  Created by Hansen on 16/7/10.
//  Copyright © 2016年 Hansen. All rights reserved.
//

#import "ViewController.h"
#import "HSAlertView.h"

@interface ViewController ()<HSAlertViewDelegate>

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = nil;
    CGRect frame = CGRectMake(50, 100, 150, 40);
    button = [[UIButton alloc] initWithFrame:frame];
    button.center = self.view.center;
    [button setTitle:@"清除历史记录" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)sender
{
    HSAlertView *alertView = [[HSAlertView alloc] initWithTitle:@"提示" message:@"你确定要清楚历史记录?" delegate:self cancelButtonTitle:@"No" confirmButtonTitle:@"Yes" otherButtonTitle:@""];
    
    [alertView show];
}

#pragma mark - HSAlertViewDelegate method
- (void)willPresentAlertView:(HSAlertView *)alertView
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)didPresentAlertView:(HSAlertView *)alertView
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)alertView:(HSAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)alertView:(HSAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)alertView:(HSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",buttonIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
