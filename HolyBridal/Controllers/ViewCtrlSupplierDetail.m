//
//  ViewCtrlSupplierDetail.m
//  HolyBridal
//
//  Created by User on 2015. 3. 25..
//  Copyright (c) 2015년 steven. All rights reserved.
//

#import "ViewCtrlSupplierDetail.h"
#import "TextFldFormatter.h"
#import "MFSideMenu.h"
#import "AsyncImageView.h"
#import "GlobData.h"
#import "ModelCategory.h"
#import "ModelSupplier.h"
#import "ModelUser.h"
#import "ConnectWithServer.h"

@interface ViewCtrlSupplierDetail ()

@end

@implementation ViewCtrlSupplierDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_modelSupplier = [[ModelSupplier alloc] init];
    
    TextFldFormatter* _formatter = [TextFldFormatter getInstance];
    [_formatter resizeView:self.view];
    _scale_X = _formatter.SCALE_X;
    _scale_Y = _formatter.SCALE_Y;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self loadData];
    
    [self initControllers];
}

- (void) viewDidAppear:(BOOL)animated
{
    
}

- (void) initControllers
{
    m_scrollViewFull.contentSize = CGSizeMake(320  * _scale_X, 778 * _scale_Y );
    m_scrollViewInner.contentSize = CGSizeMake(290 * 3 * _scale_X, 169 * _scale_Y);
}

- (void)loadData
{
    GlobData* globData = [GlobData getInstance];
    m_modelSupplier = globData.supplierTemp;
    
    [m_lblName setText:m_modelSupplier.m_strName];
    [m_txtViewAbout setText:m_modelSupplier.m_strAbout];
    [m_lblEmail setText:m_modelSupplier.m_strEmail];
    
    [m_lblTelephone setText:m_modelSupplier.m_strTelephone];
    [m_lblWebsite setText:m_modelSupplier.m_strWebsite];
    
    [m_txtViewAddress setText:[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@", m_modelSupplier.m_strAddress_l1, m_modelSupplier.m_strAddress_l2, m_modelSupplier.m_strTown,m_modelSupplier.m_strCountry, m_modelSupplier.m_strPostcode]];
    
    [m_btnCategory1 setFrame:CGRectMake(37 * _scale_X, 306 * _scale_Y, 119 * _scale_X, 17 * _scale_Y)];
    ModelCategory* _category = [m_modelSupplier.m_arrayCategories objectAtIndex:0];
    [m_btnCategory1 setTitle:_category.m_strName  forState:0];
    
    m_btnCategory1.hidden = true;
    m_btnCategory2.hidden = true;
    
    if ([m_modelSupplier.m_arrayCategories count] == 2) {
        
        m_btnCategory1.hidden = false;
        m_btnCategory2.hidden = false;
        
        [m_btnCategory1 setFrame:CGRectMake(78 * _scale_X, 306 * _scale_Y, 61 * _scale_X, 17 * _scale_Y)];
        ModelCategory* _category = [m_modelSupplier.m_arrayCategories objectAtIndex:0];
        [m_btnCategory1 setTitle:_category.m_strName  forState:0];
        
        [m_btnCategory2 setFrame:CGRectMake(180 * _scale_X, 306 * _scale_Y, 61 * _scale_X, 17 * _scale_Y)];
        _category = [m_modelSupplier.m_arrayCategories objectAtIndex:1];
        [m_btnCategory2 setTitle:_category.m_strName  forState:0];
        
        if ([_category.m_strName length] > 7) {
            [m_btnCategory2 setFrame:CGRectMake(176 * _scale_X, 306 * _scale_Y, 87 * _scale_X, 17 * _scale_Y)];
        }
        
    } else if ([m_modelSupplier.m_arrayCategories count] == 1) {
        
        m_btnCategory1.hidden = true;
        
        [m_btnCategory1 setFrame:CGRectMake(130 * _scale_X, 306 * _scale_Y, 61 * _scale_X, 17 * _scale_Y)];
        ModelCategory* _category = [m_modelSupplier.m_arrayCategories objectAtIndex:0];
        [m_btnCategory1 setTitle:_category.m_strName  forState:0];
        
        
        
    } else {
        
    }
    
    [self changeBtnStatus];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void) sendEmail:(NSString*)_emailAddress title:(NSString*)_mailTitle message:(NSString*)_mailContent
{
    
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

//public static void setTextViewColorPartial(TextView view, String fulltext, String subtext, int color) {
//    view.setText(fulltext, TextView.BufferType.SPANNABLE);
//    Spannable str = (Spannable) view.getText();
//    int i = fulltext.indexOf(subtext);
//    str.setSpan(new ForegroundColorSpan(color), i, i + subtext.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
//}

#pragma mark ---------- delegate --------- scrollView -------------------
- (IBAction)onBtnPageIndicator:(id)sender
{
    CGRect frame;
    frame.origin.x = m_scrollViewInner.frame.size.width * m_paeControl.currentPage;
    frame.origin.y = 0;
    frame.size = m_scrollViewInner.frame.size;
    [m_scrollViewInner scrollRectToVisible:frame animated:YES];
    
    //    m_scrollViewInfomation.
}

- (IBAction)onBtnBackGround:(id)sender
{
    //    [self hideKeyBoardAll];
    //    [self viewMoveToBottom];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView                                               // any offset changes
{
    CGFloat pageWidth = m_scrollViewInner.frame.size.width;
    int page = floor((m_scrollViewInner.contentOffset.x - pageWidth / 2) / pageWidth) +1;
    
    m_paeControl.currentPage = page;
}

- (void)changeBtnStatus
{
    NSString* _strMessage = @"";
    UIImage* _image;
    
    if (m_modelSupplier.m_isFavorite) {
        _strMessage = @"navbarBtnFav-Remove@3x";
        
    } else {
        _strMessage = @"navbarBtnFav@3x.png";
    }
    
    _image = [UIImage imageNamed:_strMessage];
    [m_btnNavFavourite setBackgroundImage:_image forState:0];
}

- (void)changeFavoriteState
{
    GlobData* globData = [GlobData getInstance];
    [globData removeFavouriteSupplier:m_modelSupplier];
    
    if (m_modelSupplier.m_isFavorite) {
        [globData.m_arrayFavouriteSuppliers addObject:m_modelSupplier];
    } else {
        
    }
    
    [self changeBtnStatus];
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

- (IBAction)onBtnBack:(id)sender {
    [self.menuContainerViewController.centerViewController popViewControllerAnimated:YES];
}

- (IBAction)onBtnFavorite:(id)sender {
    
    NSString* _strMessage = @"";
    
    UIAlertView* _alertView = [[UIAlertView alloc] initWithTitle:nil message:_strMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    
    if (m_modelSupplier.m_isFavorite) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"Already Favourited" message:@"You have already added this supplier to your favourites, would you like to remove it?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Remove", nil];
        
    } else {
        _alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The supplier has been added to your favourites!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confirm", nil];
    }
    
    
    _alertView.tag = 1; // Favorite or Unfavorite
    
    [_alertView show];
}

- (IBAction)onBtnEmail:(id)sender {
    [self sendEmail:m_modelSupplier.m_strEmail title:@"Enquiry from The Holy Bridal" message:@""];
}

- (IBAction)onBtnTel:(id)sender {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",m_modelSupplier.m_strTelephone]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView* calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }

}

- (IBAction)onBtnMap:(id)sender {
    NSString* _strURL = [NSString stringWithFormat:@"https://www.google.com.sg/maps?q=%f,%f", [m_modelSupplier.m_strLocationLat floatValue], [m_modelSupplier.m_strLocationLng floatValue]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_strURL]];
}

- (IBAction)onBtnWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", m_modelSupplier.m_strWebsite]]];
}

- (IBAction)onBtnRequestContact:(id)sender {
    UIAlertView* dialog = [[UIAlertView alloc] init];
    dialog.tag = 2; // Request Contact
    [dialog setDelegate:self];
    [dialog setTitle:@"Request contact"];
    [dialog setMessage:@"Are you sure you wish to request contact? Your details will be sent to this supplier so they can get in touch with you."];
    [dialog addButtonWithTitle:@"Cancel"];
    [dialog addButtonWithTitle:@"Request"];
    
    [dialog show];
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
    NSString* _strTemp = [alertView textFieldAtIndex:0].text;
    
    _strTemp = _strTemp;
    
    switch (buttonIndex) {
        case 0: // Cancel
            if (alertView.tag == 1 && (!m_modelSupplier.m_isFavorite)) {
                m_modelSupplier.m_isFavorite = !m_modelSupplier.m_isFavorite;
                
                [self changeFavoriteState];
            }
            break;
        case 1: // Request
            
            if (alertView.tag == 1) {
                m_modelSupplier.m_isFavorite = !m_modelSupplier.m_isFavorite;
                
                [self changeFavoriteState];
            } else if (alertView.tag == 2) {
                
                ConnectWithServer* _server = [[ConnectWithServer alloc] init];
                NSString* _responseStr = [_server requestContact:m_modelSupplier.m_strID];
                
                if (![_responseStr isEqualToString:@""]) {
                    [self showMessageBox:@"Enquiry from The Holy Bridal" message:_responseStr];
                } else {
                    [self showMessageBox:@"Contact requested" message:@"\n Your details have successfully been sent to the supplier. \n"];
                }
                
            }
            
            break;
            
        default:
            break;
    }
}

//------------- Message Box ------------
-(void)showMessageBox:(NSString*)__title message:(NSString*)_message
{
    m_messageBox = [[UIAlertView alloc] initWithTitle:__title message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [m_messageBox show];
    
    [self performSelector:@selector(hideMessageBox) withObject:nil afterDelay:4.0f];
}

-(void)hideMessageBox
{
    [m_messageBox dismissWithClickedButtonIndex:0 animated:YES];
}

@end
