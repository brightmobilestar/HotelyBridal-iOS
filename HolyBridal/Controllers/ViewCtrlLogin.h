//
//  ViewCtrlLogin.h
//  HolyBridal
//
//  Created by User on 3/23/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>

@class TPKeyboardAvoidingScrollView;

@interface ViewCtrlLogin : UIViewController< UITextFieldDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate >
{
    UIEdgeInsets degeInsets;
    CLLocationManager* lm;
    
    NSString* m_strForgottenEmail;
    
    IBOutlet UITextField *m_txtFldUsername;
    IBOutlet UITextField *m_txtFldPassword;
    
    IBOutlet TPKeyboardAvoidingScrollView *scrollView;
    
    UIAlertView* m_messageBox;
}

-(IBAction)returnToLogin:(UIStoryboardSegue *)sender;

- (IBAction)onBtnLogin:(id)sender;

- (IBAction)onBtnForgotPwd:(id)sender;

@end
