//
//  ViewCtrlRegister.m
//  HolyBridal
//
//  Created by User on 3/24/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import "ViewCtrlRegister.h"
#import "TextFldFormatter.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "MFSideMenuContainerViewController.h"
#import "ViewCtrlMenu.h"
#import "MFSideMenu.h"
#import "GlobData.h"
#import "ModelUser.h"

@interface ViewCtrlRegister ()

@end

@implementation ViewCtrlRegister

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControllers];
    
    m_intTempDay = 0;
    m_intTempMonth = 0;
    m_intTempYear = 0;
    
    TextFldFormatter* _formatter = [TextFldFormatter getInstance];
    [_formatter resizeView:self.view];
    _scale_X = _formatter.SCALE_X;
    _scale_Y = _formatter.SCALE_Y;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    m_scrollView.contentSize = CGSizeMake(320 * _scale_X, 768 * _scale_Y);
    
    ModelUser* _user = [ModelUser getInstance];
    if (_user.m_isEmailMethod || _user.m_strEmail == nil) {
        [m_sequmentEmailMobile setSelectedSegmentIndex:0];
    } else {
        [m_sequmentEmailMobile setSelectedSegmentIndex:1];
    }
}

- (void) initControllers
{
    GlobData* globData = [GlobData getInstance];
    
    if (globData.isRegisterState) {
        m_navigationRister.hidden = false;
        m_navigationMyAccount.hidden = true;
        m_btnRegister.hidden = false;
        m_btnUpdate.hidden = true;
    } else {
        m_navigationMyAccount.hidden = false;
        m_navigationRister.hidden = true;
        m_btnUpdate.hidden = false;
        m_btnRegister.hidden = true;
        
        [self setUserData];
    }
    
    //[m_scrollView contentSizeToFit];
    [self formartTxtFld];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                  [UIFont fontWithName:@"Another Typewriter" size:13], NSFontAttributeName,
                  nil, nil, nil];
    
    [m_sequmentEmailMobile setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [m_sequmentEmailMobile setSelectedSegmentIndex:0];
    [m_sequmentEmailMobile.layer setCornerRadius:5.0f];
    
    m_pickerDate.delegate = self;
    m_pickerDate.dataSource = self;
    [m_pickerDate reloadAllComponents];
    
}

- (void) setUserData
{
    ModelUser* _user = [ModelUser getInstance];
    m_txtFldFullname.text = _user.m_strFullName;
    m_txtFldEmailaddress.text = _user.m_strEmail;
    
    m_txtFldPassword.text = @""; //_user.m_strPassword;
    m_txtFldRepeatPwd.text = @""; //_user.m_strPassword;
    
    m_txtFldMobilenumber.text = _user.m_strMoileNumber;
    if (_user.m_isEmailMethod || _user.m_strEmail == nil) {
        [m_sequmentEmailMobile setSelectedSegmentIndex:0];
    } else {
        [m_sequmentEmailMobile setSelectedSegmentIndex:1];
    }
    m_txtFldAddadate.text = _user.m_strDateOfWedding;
}

- (void)saveUserInfo
{
    ModelUser* _user = [ModelUser getInstance];
    _user.m_strFullName = m_txtFldFullname.text;
    _user.m_strEmail = m_txtFldEmailaddress.text;
    
    if ([m_txtFldPassword.text isEqualToString:@""]) {
        _user.m_strPassword = _user.m_strPassword;
    } else {
        _user.m_strPassword = m_txtFldPassword.text;
    }
    
    _user.m_strMoileNumber = m_txtFldMobilenumber.text;
    if (m_sequmentEmailMobile.selectedSegmentIndex == 0) {
        _user.m_isEmailMethod = true;
    } else if (m_sequmentEmailMobile.selectedSegmentIndex == 1) {
        _user.m_isEmailMethod = false;
    }
    _user.m_strDateOfWedding = m_txtFldAddadate.text;
    
    [_user save];
}

- (void) formartTxtFld
{
    TextFldFormatter* formartter = [TextFldFormatter getInstance];
    
    [formartter initTextFldType:m_txtFldFullname placeholder:@"Full name..."];
    [formartter initTextFldType:m_txtFldEmailaddress placeholder:@"Email address..."];
    
    GlobData* globData = [GlobData getInstance];
    
    if (globData.isRegisterState) {
        
        [formartter initTextFldType:m_txtFldPassword placeholder:@"Password..."];
        [formartter initTextFldType:m_txtFldRepeatPwd placeholder:@"Repeat password..."];
        
    } else {
        [formartter initTextFldType:m_txtFldPassword placeholder:@"Set new password..."];
        [formartter initTextFldType:m_txtFldRepeatPwd placeholder:@"Re-enter new password..."];
    }
    
    [formartter initTextFldType:m_txtFldMobilenumber placeholder:@"Mobile number..."];
    [formartter initTextFldType:m_txtFldAddadate placeholder:@"Add a date..."];
}

-(void) displayViewSelectDate
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:1.0f];
    
    m_viewSelectDate.hidden = false;
    m_viewSelectDate.alpha = 1.0f;
    
    [UIView commitAnimations];
}

-(void) hideViewSelectDate
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:1.0f];
    
    m_viewSelectDate.hidden = false;
    m_viewSelectDate.alpha = 0.0f;
    
    [UIView commitAnimations];
}

- (void)moveToMenuCtrl
{
    GlobData* globData = [GlobData getInstance];
    [globData login];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MFSideMenuContainerViewController *container = (MFSideMenuContainerViewController *)[storyboard instantiateViewControllerWithIdentifier:@"menuSliderViewController"];
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
    
    ViewCtrlMenu *leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewCtrlMenu"];
    //    UIViewController *rightSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rightSideMenuViewController"];
    
    [container setLeftMenuViewController:nil];
    [container setRightMenuViewController:leftSideMenuViewController];
    [container setCenterViewController:navigationController];
    container.navigationController.navigationBarHidden = true;
    
    self.navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:container animated:false completion:nil];
    [self.navigationController popToRootViewControllerAnimated:false];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideAllKey];
}

#pragma mark ---- picker view ---------------
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 31;
            break;
            
        case 1:
            return 12;
            break;
            
        case 2:
            return 10;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    GlobData* globData = [GlobData getInstance];
    
    UILabel* tView = (UILabel*)view;
    if (tView == nil) {
        tView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
        tView.textAlignment = UIBaselineAdjustmentAlignCenters;
    
    UIColor* color = [UIColor blackColor];
    tView.textColor = color;
    tView.text = @"";
    }
    
    NSString* _strLabel = @"";
    NSInteger _intLabel;
    switch (component) {
        case 0:
            _intLabel = 1 + row;
            _strLabel = [NSString stringWithFormat:@"%ld", (long)_intLabel];
            break;
            
        case 1:
            _strLabel = [[globData getStrMonths] objectAtIndexedSubscript:row];
            break;
            
        case 2:
            _intLabel = 2015 + row;
            _strLabel = [NSString stringWithFormat:@"%ld", (long)_intLabel];
            break;
            
        default:
            break;
    }

    
    tView.text = _strLabel;
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
    case 0:
            
            m_intTempDay = row;
        break;
        
    case 1:

            m_intTempMonth = row;
        break;
        
    case 2:

            m_intTempYear = row;
        break;
        
    default:
        break;
    }

}

#pragma mark ----- Message Box ------------
-(void)showMessageBox:(NSString*)__title message:(NSString*)_message
{
    m_messageBox = [[UIAlertView alloc] initWithTitle:__title message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [m_messageBox show];
    
    [self performSelector:@selector(hideMessageBox) withObject:nil afterDelay:2.0f];
}

-(void)hideMessageBox
{
    [m_messageBox dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideAllKey
{
    [m_txtFldAddadate resignFirstResponder];
    [m_txtFldEmailaddress resignFirstResponder];
    [m_txtFldMobilenumber resignFirstResponder];
    [m_txtFldPassword resignFirstResponder];
    [m_txtFldRepeatPwd resignFirstResponder];
    [m_txtFldFullname resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark ------ events ----------
- (IBAction)onBtnNavMenu:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (IBAction)onBtnLogout:(id)sender {
    UIAlertView* _alertView = [[UIAlertView alloc] initWithTitle:@"Logout?" message:@"Are you sure you wish to logout of \n Holy Bridal?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout", nil];
    [_alertView show];
}

- (IBAction)onBtnAddadate:(id)sender {
    
    [self hideAllKey];
    
    [self displayViewSelectDate];
}

- (IBAction)onBtnDateOfWedding:(id)sender {
    
    [self hideViewSelectDate];
}

- (NSString*)getTodayDate
{
    GlobData* globData = [GlobData getInstance];
    
    NSDate *today = [NSDate date];
    
    NSString* strTemp = [today description];
    NSArray* array1 = [[today description] componentsSeparatedByString:@" "];
    NSArray* arrayTemp = [[array1 objectAtIndex:0] componentsSeparatedByString:@"-"];
    
     NSString* _strMonth = @"";
    if ([[arrayTemp objectAtIndex:1] integerValue] < 10) {
        _strMonth = [globData getNumber:[[arrayTemp objectAtIndex:1] integerValue]];
    } else {
        _strMonth = [NSString stringWithFormat:@"%ld", (long)[[arrayTemp objectAtIndex:1] integerValue]];
    }
    
    NSString* _strDay = @"";
    if ([[arrayTemp objectAtIndex:2] integerValue] < 10) {
        _strDay = [globData getNumber:[[arrayTemp objectAtIndex:2] integerValue]];
    } else {
        _strDay = [NSString stringWithFormat:@"%ld", (long)[[arrayTemp objectAtIndex:2] integerValue]];
    }
    
    strTemp = [NSString stringWithFormat:@"%@%@%@", [arrayTemp objectAtIndex:0], _strMonth, _strDay];
    
    return strTemp;
}

- (IBAction)onBtnSelectDate:(id)sender {
    
    NSString* _strToday = [self getTodayDate];
    
    GlobData* globData = [GlobData getInstance];
    
    NSString *_strLabelDay, *_strlabelMonth, *_strlabelYear;
    NSInteger _intLabel;
    
    
    _intLabel = 1 + m_intTempDay;
    _strLabelDay = [NSString stringWithFormat:@"%ld", (long)_intLabel];
    
    _strlabelMonth = [[globData getStrMonths] objectAtIndexedSubscript:m_intTempMonth];
    
    _intLabel = 2015 + m_intTempYear;
    _strlabelYear = [NSString stringWithFormat:@"%ld", (long)_intLabel];
    
    NSString* _strMonth = @"";
    if (m_intTempMonth + 1 < 10) {
        _strMonth = [globData getNumber:m_intTempMonth + 1];
    } else {
        _strMonth = [NSString stringWithFormat:@"%ld", (long)m_intTempMonth + 1];
    }
    
    NSString* _strDay = @"";
    if (m_intTempDay + 1 < 10) {
        _strDay = [globData getNumber:m_intTempDay + 1];
    } else {
        _strDay = [NSString stringWithFormat:@"%ld", (long)m_intTempDay + 1];
    }
    
    NSString* __strDate = [NSString stringWithFormat:@"%ld%@%@", (long)2015 + m_intTempYear, _strMonth, _strDay];
    
    if ([__strDate compare:_strToday] == NSOrderedAscending) {
        UIAlertView* _alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"The date you have selected for you wedding is in the past, please choose an upcoming date" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [_alertView show];
        
        return;
    }
    
    m_txtFldAddadate.text = [NSString stringWithFormat:@"%@ / %@ / %@", _strLabelDay, _strlabelMonth, _strlabelYear];
    
    [self hideViewSelectDate];
}

- (IBAction)onBtnRegister:(id)sender {
    
    [self hideAllKey];
    
    if ([m_txtFldFullname.text isEqualToString:@""]) {
        [self showMessageBox:@"ERROR" message:@"Please enter full name"];
        return;
    } else     if ([m_txtFldEmailaddress.text isEqualToString:@""]) {
        [self showMessageBox:@"ERROR" message:@"Please enter email address"];
        return;
    } else     if ([m_txtFldPassword.text isEqualToString:@""]) {
        [self showMessageBox:@"ERROR" message:@"Please enter password"];
        return;
    }   else     if ([m_txtFldRepeatPwd.text isEqualToString:@""]) {
        [self showMessageBox:@"ERROR" message:@"Please enter repeat password"];
        return;
    }  else  if ([m_txtFldMobilenumber.text isEqualToString:@""] && m_sequmentEmailMobile.selectedSegmentIndex == 1) {
        [self showMessageBox:@"ERROR" message:@"Please enter mobile number"];
        return;
    }  else     if ([m_txtFldAddadate.text isEqualToString:@""]) {
        [self showMessageBox:@"ERROR" message:@"Please add a date"];
        return;
    } else if (![m_txtFldPassword.text isEqualToString:m_txtFldRepeatPwd.text]) {
        [self showMessageBox:@"ERROR" message:@"Please confirm repeat password. It doesn't match with password"];
        return;
    }
    
//    else if ([m_txtFldPassword.text isEqualToString:@""]) {
//        //[self showMessageBox:nil message:@"Please inpute Password"];
//        //return;
//    }
    
    [self saveUserInfo];
    
    [self moveToMenuCtrl];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onBtnUpdate:(id)sender {
    
    [self hideAllKey];
    
    if ([m_txtFldFullname.text isEqualToString:@""]) {
        [self showMessageBox:@"ERROR" message:@"Please enter full name"];
        return;
    } else     if ([m_txtFldEmailaddress.text isEqualToString:@""]) {
        [self showMessageBox:@"ERROR" message:@"Please enter email address"];
        return;
    } else     if ([m_txtFldMobilenumber.text isEqualToString:@""] && m_sequmentEmailMobile.selectedSegmentIndex == 1) {
        [self showMessageBox:@"ERROR" message:@"Please enter mobile number"];
        return;
    } else     if ([m_txtFldAddadate.text isEqualToString:@""]) {
        [self showMessageBox:@"ERROR" message:@"Please add a date"];
        return;
    } else if (![m_txtFldPassword.text isEqualToString:m_txtFldRepeatPwd.text]) {
        [self showMessageBox:@"ERROR" message:@"Please confirm repeat password. It doesn't match with password"];
        return;
    }
    
    [self saveUserInfo];
    
    [self showMessageBox:@"Account updated." message:nil];
}

- (IBAction)onBtnTermsAndConditions:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.theholybridal.co.uk/terms/"]];
}

#pragma mark ---- alertView -------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    GlobData* globData = [GlobData getInstance];
    
    switch (buttonIndex) {
        case 0: // Cancel for Logout
            
            break;
            
        case 1: // Logout
            
            [globData logout];
            [self.menuContainerViewController dismissViewControllerAnimated:true completion:nil    ];
            break;
            
        default:
            break;
    }
}

@end
