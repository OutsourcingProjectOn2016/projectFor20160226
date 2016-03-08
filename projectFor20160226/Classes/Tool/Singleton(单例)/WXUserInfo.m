//
//  WXUserInfo.m
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-20.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import "WXUserInfo.h"
#define UserNameKey @"USER_NAME"
#define PwdKey @"PASSWORD"
#define LoginKey @"Login"
static NSString *xmppDomain = @"WIN-RP1TDDJ0SJJ";
static NSString *xmppHostIP = @"18.8.19.68";
@implementation WXUserInfo
singleton_implementation(WXUserInfo);


-(NSString *)xmppDomain{
    return xmppDomain;
}

-(NSString *)xmppHostIP{
    return xmppHostIP;
}

-(NSString *)userJid{
    return [NSString stringWithFormat:@"%@@%@",self.loginUserName,xmppDomain];
}

-(void)synchronizeToSandBox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.loginUserName forKey:UserNameKey];
    [defaults setObject:self.loginPwd forKey:PwdKey];
    [defaults setBool:self.login forKey:LoginKey];
    [defaults synchronize];
}

-(void)loadDataFromSandBox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.loginUserName = [defaults objectForKey:UserNameKey];
    self.loginPwd = [defaults objectForKey:PwdKey];
    self.login = [defaults boolForKey:LoginKey];
}
/**
 *  @property(nonatomic,copy,readonly)NSString *xmppDomain;//xmpp服务器域名
 @property(nonatomic,copy,readonly)NSString *xmppHostIP;//xmpp服务器IP
 @property(nonatomic,copy)NSString *loginUserName;//登录账号
 *
 *  @return <#return value description#>
 */
//-(NSString *)domain{
//    return xmppDomain;
//}
//
//-(NSString *)host{
//    return host;
//}
//
//-(int)port{
//    return port;
//}
@end
