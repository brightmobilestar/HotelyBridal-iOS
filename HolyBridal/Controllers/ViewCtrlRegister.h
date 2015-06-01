//
//  ViewCtrlRegister.h
//  HolyBridal
//
//  Created by User on 3/24/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKeyboardAvoidingScrollView;

@interface ViewCtrlRegister : UIViewController <UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>
{
    
    UIAlertView* m_messageBox;
    
    IBOutlet UIView *m_navigationRister;
    IBOutlet UIView *m_navigationMyAccount;

    IBOutlet TPKeyboardAvoidingScrollView *m_scrollView;
    
    IBOutlet UITextField *m_txtFldFullname;
    IBOutlet UITextField *m_txtFldEmailaddress;
    IBOutlet UITextField *m_txtFldPassword;
    IBOutlet UITextField *m_txtFldRepeatPwd;
    IBOutlet UITextField *m_txtFldMobilenumber;
    IBOutlet UITextField *m_txtFldAddadate;
    
    IBOutlet UISegmentedControl *m_sequmentEmailMobile;
    
    IBOutlet UIButton *m_btnRegister;
    
    IBOutlet UIButton *m_btnUpdate;
    IBOutlet UIView *m_viewSelectDate;
    IBOutlet UIPickerView *m_pickerDate;
    
    NSInteger m_intTempDay, m_intTempMonth, m_intTempYear;
    float _scale_X, _scale_Y;
}

- (IBAction)onBtnNavMenu:(id)sender;
- (IBAction)onBtnLogout:(id)sender;


- (IBAction)onBtnAddadate:(id)sender;
- (IBAction)onBtnDateOfWedding:(id)sender;
- (IBAction)onBtnSelectDate:(id)sender;

- (IBAction)onBtnRegister:(id)sender;
- (IBAction)onBtnUpdate:(id)sender;

- (IBAction)onBtnTermsAndConditions:(id)sender;

@end
