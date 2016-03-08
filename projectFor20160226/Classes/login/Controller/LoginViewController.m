//
//  LoginViewController.m
//  
//
//  Created by allenL on 15/7/15.
//  Copyright (c) 2015年 tamYL. All rights reserved.
//

#import "InputText.h"
#import "LoginViewController.h"
#import "UIView+XD.h"
#import "UIStoryboard+WF.h"
#import "WXUserInfo.h"
//#import "MBProgressHUD+HM.h"


@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, weak)UITextField *userText;
@property (nonatomic, weak)UILabel *userTextName;
@property (nonatomic, weak)UITextField *passwordText;
@property (nonatomic, weak)UILabel *passwordTextName;
@property (nonatomic, weak)UIButton *loginBtn;
@property (nonatomic, assign) BOOL chang;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInputRectangle];
    
}

- (void)setupInputRectangle
{
    
    CGFloat centerX = self.view.width * 0.5;
    InputText *inputText = [[InputText alloc] init];
    /**
     *  设置居中图片
     */

    /**
     *  设置账号label
     */
    CGFloat userY = 250;
    UITextField *userText = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
    userText.delegate = self;
    self.userText = userText;
    
    [userText setReturnKeyType:UIReturnKeyNext];
    [userText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:userText];
    UILabel *userTextName = [self setupTextName:@"账号（必填）" frame:userText.frame];
    self.userTextName = userTextName;
    [self.view addSubview:userTextName];
    
    /**
     *  设置密码label
     */
    CGFloat passwordY = CGRectGetMaxY(userText.frame) + 30;
    UITextField *passwordText = [inputText setupWithIcon:nil textY:passwordY centerX:centerX point:nil];
    [passwordText setReturnKeyType:UIReturnKeyDone];
    [passwordText setSecureTextEntry:YES];
    passwordText.delegate = self;
    self.passwordText = passwordText;
    [passwordText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordText];
    UILabel *passwordTextName = [self setupTextName:@"密码（必填）" frame:passwordText.frame];
    self.passwordTextName = passwordTextName;
    [self.view addSubview:passwordTextName];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.width = 200;
    loginBtn.height = 30;
    loginBtn.centerX = self.view.width * 0.5;
    loginBtn.y = CGRectGetMaxY(passwordText.frame) + 30;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:[UIColor orangeColor]];
    loginBtn.enabled = YES;
    self.loginBtn = loginBtn;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor grayColor];
    textNameLabel.frame = frame;
    return textNameLabel;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.userText) {
        [self diminishTextName:self.userTextName];
        
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
       
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userText) {
        return [self.passwordText becomeFirstResponder];
    } else {
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        if (self.userText.text.length != 0  && self.passwordText.text.length != 0) {
            [self loginBtnClick];
            return [self.passwordText resignFirstResponder];
        } else{
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"注意" message:@"账号密码不能为空！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
            return [self.passwordText canResignFirstResponder];
        }
        
    }
    
}
- (void)diminishTextName:(UILabel *)label
{
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -16);
        label.font = [UIFont systemFontOfSize:9];
    }];
}
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled
{
    [self textFieldTextChange:textFieled];
    if (self.chang) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.font = [UIFont systemFontOfSize:16];
        }];
    }
}
- (void)textFieldTextChange:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.chang = NO;
    } else {
        self.chang = YES;
    }
}
- (void)textFieldDidChange
{
    if (self.userText.text.length != 0  && self.passwordText.text.length != 0) {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
}
#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self restoreTextName:self.userTextName textField:self.userText];
    //    [self restoreTextName:self.emailTextName textField:self.emailText];
    [self restoreTextName:self.passwordTextName textField:self.passwordText];
}
- (void)loginBtnClick
{
    NSString *username = self.userText.text;
    NSString *pwd = self.passwordText.text;
    // 放在单例对象中
    WXUserInfo *userInfo = [WXUserInfo sharedWXUserInfo];
    userInfo.loginUserName = username;
    userInfo.loginPwd = pwd;
    
    [self login];
    //跳转到mainstoryboard
    //[UIStoryboard showInitialVCWithName:@"Main"];
    
}

-(void)login{
    // 键盘消失
    //[self.view endEditing:YES];
    
    // 调用代理的登录方法
    //[MBProgressHUD showMessage:@"正在登录.." toView:self.view];
    // 进到主界面
    [UIStoryboard showInitialVCWithName:@"Main"];
//    [WXXMPPTools sharedWXXMPPTools].userRegister = NO;
//    __weak typeof(self) selfVc = self;
//    [[WXXMPPTools sharedWXXMPPTools] userLoginWithResultBlock:^(XMPPResultType type) {
//        [selfVc handleResultType:type];
//    }];
    
}

// 处理请求结果
//-(void)handleResultType:(XMPPResultType)type{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:self.view ];
//        int myType = type;
//        switch (myType) {
//            case XMPPResultTypeLoginSuccess:
//                [MBProgressHUD showSuccess:@"登录成功" toView:self.view ];
//                
//                
//                // 进到主界面
//                [UIStoryboard showInitialVCWithName:@"Main"];
//                
//                // 登录成功
//                [WXUserInfo sharedWXUserInfo].login = YES;
//                // 保存登录信息到沙盒
//                [[WXUserInfo sharedWXUserInfo] synchronizeToSandBox];
//                break;
//                
//            case XMPPResultTypeLoginFailure:
//                [MBProgressHUD showError:@"账号或者密码不正确" toView:self.view];
//                break;
//        }
//        
//        WXLog(@"%d",type);
//    });
//}


@end
