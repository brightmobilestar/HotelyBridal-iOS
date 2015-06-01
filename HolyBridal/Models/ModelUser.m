//
//  ModelUser.m
//  HolyBridal
//
//  Created by User on 3/30/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import "ModelUser.h"
#import "GlobData.h"

#define UserInfo @"HolyBridal.UserInfo"
#define UserName @"UserInfo.UserName"
#define UserEmail @"UserInfo.Email"
#define UserPwd @"UserInfo.Password"
#define UserMobileNum @"UserInfo.MobileNumber"
#define UserContactWay @"UserInfo.ContactMethod"
#define UserDateOfWedding @"UserInfo.DateOfWedding"


@implementation ModelUser

@synthesize m_strFullName;
@synthesize m_strEmail;
@synthesize m_strPassword;
@synthesize m_strMoileNumber;
@synthesize m_isEmailMethod;
@synthesize m_strDateOfWedding;


static ModelUser* instance = nil;

+ (ModelUser*)getInstance
{
    @synchronized( self )
    {
        if (instance == nil) {
            instance = [ModelUser new];
            
            instance.m_isEmailMethod = true;
            instance.m_strPassword = @"";
        }
    }
    
    return instance;
}

- (void)read
{
    GlobData* globData = [GlobData getInstance];
    
    NSUserDefaults* prefs = [[NSUserDefaults alloc] initWithSuiteName:UserInfo];
    
    if (globData.currentDeviceVersion < 8.0) {
        prefs = [NSUserDefaults standardUserDefaults];
    }
    
    self.m_strFullName = [prefs stringForKey:UserName];
    self.m_strEmail = [prefs stringForKey:UserEmail];
    self.m_strPassword = [prefs stringForKey:UserPwd];
    self.m_strMoileNumber = [prefs stringForKey:UserMobileNum];
    if ([[prefs stringForKey:UserContactWay] isEqual:@"email"]) {
        self.m_isEmailMethod = true;
    } else {
        self.m_isEmailMethod = false;
    }
    self.m_strDateOfWedding = [prefs stringForKey:UserDateOfWedding];
}

-(void)save
{
    GlobData* globData = [GlobData getInstance];
    
    NSUserDefaults* prefs = [[NSUserDefaults alloc] initWithSuiteName:UserInfo];
    
    if (globData.currentDeviceVersion < 8.0) {
        prefs = [NSUserDefaults standardUserDefaults];
    }
    
    [prefs setObject:self.m_strFullName forKey:UserName];
    [prefs setObject:self.m_strEmail forKey:UserEmail];
    [prefs setObject:self.m_strPassword forKey:UserPwd];
    [prefs setObject:self.m_strMoileNumber forKey:UserMobileNum];
    if (self.m_isEmailMethod) {
        [prefs setObject:@"email" forKey:UserContactWay];
    } else {
        [prefs setObject:@"mobilenumber" forKey:UserContactWay];
    }
    [prefs setObject:self.m_strDateOfWedding forKey:UserDateOfWedding];
}

-(void)resetPassword:(NSString*)_strPassword
{
    GlobData* globData = [GlobData getInstance];
    
    NSUserDefaults* prefs = [[NSUserDefaults alloc] initWithSuiteName:UserInfo];
    
    if (globData.currentDeviceVersion < 8.0) {
        prefs = [NSUserDefaults standardUserDefaults];
    }
    
    [prefs setObject:_strPassword forKey:UserPwd];
}

@end
