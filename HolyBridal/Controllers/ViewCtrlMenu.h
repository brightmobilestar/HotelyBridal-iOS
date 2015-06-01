//
//  ViewCtrlMenu.h
//  HolyBridal
//
//  Created by User on 3/25/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface ViewCtrlMenu : UIViewController< UIAlertViewDelegate >
{
    IBOutlet UIButton *m_btnFindSupplier;
    IBOutlet UIButton *m_btnFavourite;
    IBOutlet UIButton *m_btnMyAccount;
    IBOutlet UIButton *m_btnShare;
}

- (void)btnSelected:(UIButton*)_button _index:(NSInteger)_index;

- (IBAction)onBtnFindSuppliers:(id)sender;
- (IBAction)onBtnFavourites:(id)sender;
- (IBAction)onBtnMyAccount:(id)sender;
- (IBAction)onBtnShare:(id)sender;
- (IBAction)onBtnLogout:(id)sender;


@end
