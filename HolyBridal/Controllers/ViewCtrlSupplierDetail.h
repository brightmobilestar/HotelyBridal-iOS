//
//  ViewCtrlSupplierDetail.h
//  HolyBridal
//
//  Created by User on 2015. 3. 25..
//  Copyright (c) 2015년 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class ModelSupplier;

@interface ViewCtrlSupplierDetail : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UILabel *m_lblName;
    IBOutlet UIButton *m_btnNavFavourite;
    
    
    IBOutlet UIScrollView *m_scrollViewFull;
    IBOutlet UIScrollView *m_scrollViewInner;
    IBOutlet UIPageControl *m_paeControl;
    
    IBOutlet UIButton *m_btnCategory1;
    IBOutlet UIButton *m_btnCategory2;
    IBOutlet UIButton *m_btnCategory3;
    
    
    IBOutlet UILabel *m_txtViewAbout;
    IBOutlet UILabel *m_lblEmail;
    IBOutlet UILabel *m_lblTelephone;
    IBOutlet UILabel *m_txtViewAddress;
    IBOutlet UILabel *m_lblWebsite;
    
    
    ModelSupplier* m_modelSupplier;
    
    UIAlertView* m_messageBox;
    
    float _scale_X, _scale_Y;
    
}
- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnFavorite:(id)sender;

- (IBAction)onBtnEmail:(id)sender;
- (IBAction)onBtnTel:(id)sender;
- (IBAction)onBtnMap:(id)sender;
- (IBAction)onBtnWebsite:(id)sender;

- (IBAction)onBtnRequestContact:(id)sender;


@end
