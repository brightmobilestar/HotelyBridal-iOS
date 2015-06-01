//
//  ViewCtrlLogin.m
//  HolyBridal
//
//  Created by User on 3/23/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import "ViewCtrlLogin.h"
#import "TextFldFormatter.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "MFSideMenuContainerViewController.h"
#import "ViewCtrlMenu.h"
#import "GlobData.h"
#import "ConnectWithServer.h"
#import "ModelUser.h"

#define SCALE_X  375 / 320
#define SCALE_Y  667 / 568

@interface ViewCtrlLogin ()

@end

@implementation ViewCtrlLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [scrollView contentSizeToFit];
    
    GlobData* globData = [GlobData getInstance];
    if ([globData isLogin]) {
        [self moveToMenuCtrl];
    }
    
    //----------------
    TextFldFormatter* _formart = [TextFldFormatter getInstance];
    [_formart resizeView:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    ModelUser* _user = [ModelUser getInstance];
    [_user read];
    
    [self initControllers];
    [self startTracking];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self getAllData];
    m_txtFldPassword.text = @"";
    m_txtFldUsername.text = @"";
}

- (void) initControllers
{
    GlobData* globData = [GlobData getInstance];
    [globData initAllInfo];
    
    self.navigationController.navigationBarHidden = true;
    [self formartTxtFld];
}

- (void) getAllData
{
    ConnectWithServer* _server = [[ConnectWithServer alloc] init];
    [_server readCategories];
}

- (void) formartTxtFld
{
    TextFldFormatter* formartter = [TextFldFormatter getInstance];
    
    [formartter initTextFldType:m_txtFldUsername placeholder:@"Email address..."];
    [formartter initTextFldType:m_txtFldPassword placeholder:@"Password..."];
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
//    [self performSegueWithIdentifier:@"sequemodalToMenuFromLogin" sender:nil];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)hideAllKeyboard
{
    [m_txtFldPassword resignFirstResponder];
    [m_txtFldUsername resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) sendEmail:(NSString*)_emailAddress title:(NSString*)_mailTitle message:(NSString*)_mailContent
{
    
    //ModelUser* _userModel = [ModelUser getInstance];

    NSString* strBody = [NSString stringWithFormat:@"Hello. I am in emergency. current location is "];
    
    strBody = @"Robert Pirolo is in Emergency. and dialed 911, at ... ";
    
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    
    // his class should be the delegate of the mc
    mc.mailComposeDelegate = self;
    
    // set a mail subject ... but you do not need to do this :)
    [mc setSubject:_mailTitle];
    
    // set some basic plain text as the message body ... but you do not need to do this :)
    [mc setMessageBody:[NSString stringWithFormat:@"%@", _mailContent] isHTML:YES];
    
    //NSArray* array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@", saveData.m_personEmail], nil];
    // set some recipients ... but you do not need to do this :)
    [mc setToRecipients:[NSArray arrayWithObjects:_emailAddress, nil]];
    
    //[mc setCcRecipients:array];
    
    //[mc setToRecipients:[NSArray arrayWithObjects:@"first.address@test.com", @"second.address@test.com", nil]];
    
    // displaying our modal view controller on the screen with standard transition
    [self presentViewController:mc animated:YES completion:nil];
    
    // be a good memory manager and release mc, as you are responsible for it because your alloc/init
}

#pragma mark ---- events ------------
-(IBAction)returnToLogin:(UIStoryboardSegue *)sender
{
    
}

- (IBAction)onBtnLogin:(id)sender
{
    ModelUser* _user = [ModelUser getInstance];
    [_user read];
    
    [self hideAllKeyboard];
    
    if ([m_txtFldUsername.text isEqualToString:@""]) {
        [self showMessageBox:@"ERROR" message:@"Please enter email address"];
        return;
    } else if ([m_txtFldPassword.text isEqualToString:@""]) {
        //[self showMessageBox:nil message:@"Please inpute Password"];
        //return;
    }
    
    if (![_user.m_strEmail isEqualToString:m_txtFldUsername.text] || ![_user.m_strPassword isEqualToString:m_txtFldPassword.text]) {
        [self showMessageBox:@"ERROR" message:@"Please enter correct email address and password."];
        return;
    }
    
    [self moveToMenuCtrl];
}

- (IBAction)onBtnForgotPwd:(id)sender {
    
    [self hideAllKeyboard];
    
    UIAlertView* dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:self];
    [dialog setTitle:@"Forgotten password"];
    [dialog setMessage:@"Please enter your email address to recover your password"];
    [dialog addButtonWithTitle:@"Cancel"];
    [dialog addButtonWithTitle:@"Recover"];
    
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
    
    [dialog show];
}

//------------- Message Box ------------
-(void)showMessageBox:(NSString*)__title message:(NSString*)_message
{
    m_messageBox = [[UIAlertView alloc] initWithTitle:__title message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [m_messageBox show];
    
    [self performSelector:@selector(hideMessageBox) withObject:nil afterDelay:3.0f];
}

-(void)hideMessageBox
{
    [m_messageBox dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark -------- delegate ------ email --------
// delegate function callback
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // switchng the result
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled.");
            /*
             Execute your code for canceled event here ...
             */
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved.");
            /*
             Execute your code for email saved event here ...
             */
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent.");
            /*
             Execute your code for email sent event here ...
             */
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send error: %@.", [error localizedDescription]);
            /*
             Execute your code for email send failed event here ...
             */
            break;
        default:
            break;
    }
    // hide the modal view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ------ alertView ------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ConnectWithServer* _connectionServer = [[ConnectWithServer alloc] init];
    
    GlobData* globData = [GlobData getInstance];
    NSString* _strPassword = [globData generatePassword];
    
    NSString* _strTemp = [alertView textFieldAtIndex:0].text;
    
    m_strForgottenEmail = _strTemp;
    
    switch (buttonIndex) {
        case 0: // Cancel
            
            break;
        case 1: // Recover
            
            [_connectionServer sendRequestPasswordRecover:_strTemp password:_strPassword];
            
            
            break;
            
        default:
            break;
    }
}

// -------------------- Location Services --------------------
#pragma mark --- location services ---------
- (void)startTracking {
    // unit test success: NSLog( @"location services initiated" );
    //start location manager
    lm = [[CLLocationManager alloc] init];
    lm.delegate = self;
    lm.desiredAccuracy = kCLLocationAccuracyKilometer;    // kCLLocationAccuracyBest;
    lm.distanceFilter = kCLDistanceFilterNone;
    
    [lm requestAlwaysAuthorization];
    [lm requestWhenInUseAuthorization];
    
    [lm startUpdatingLocation];
    
    [lm startMonitoringSignificantLocationChanges];
    
    //[self startLocationRequest:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *currentLocation = [locations lastObject];
    
    //store latest location in stored track array;
    
    GlobData* globData = [GlobData getInstance];
    globData.currentLocation = currentLocation;
    
    NSLog(@"currentloadtion: %f,    %f", globData.currentLocation.coordinate.latitude, globData.currentLocation.coordinate.longitude);
    
//    if (_intLocationUpdateCount == 0 ) {
//        
//        NSLog(@"---------update location--------");
//        
//        _intLocationUpdateCount = _intLocationUpdateCount + 1;
//        
//        [self updateUser];
//        
//        if (isPossibleVisitPlace) {
//            [self updateVisitPlace];
//        }
//        
//        // find the city and state or province
//        [self findTheCityandStateorProvince:currentLocation];
//        
//    } else if (_intLocationUpdateCount > 60) {
//        _intLocationUpdateCount = 0;
//    } else {
//        _intLocationUpdateCount = _intLocationUpdateCount + 1;
//    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

@end
