//
//  ViewCtrlMenu.m
//  HolyBridal
//
//  Created by User on 3/25/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import "ViewCtrlMenu.h"
#import "TextFldFormatter.h"
#import "MFSideMenu.h"
#import "ViewCtrlFindSuppliers.h"
#import "ViewCtrlRegister.h"
#import "ViewCtrlFavourites.h"
#import "GlobData.h"
//#import "ViewCtrlMenu.h"


@interface ViewCtrlMenu ()

@end

@implementation ViewCtrlMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TextFldFormatter* _formatter = [TextFldFormatter getInstance];
    [_formatter resizeView:self.view];
}

- (void)btnSelected:(UIButton*)_button _index:(NSInteger)_index
{
    GlobData* globData = [GlobData getInstance];
    if (_index != 4) { // != Share item
        globData.currentItemIndex = _index;
        NSString* _strImageName = [NSString stringWithFormat:@"menuBtnOn%ld.png", (long)_index];
        UIImage* _image = [UIImage imageNamed:_strImageName];
        
        [_button setBackgroundImage:_image forState:0];
    }
}

- (void)allBtnUnselected
{
    UIImage* _image = [UIImage imageNamed:@"menuBtnOff1.png"];
    [m_btnFindSupplier setBackgroundImage:_image forState:0];
    
    _image = [UIImage imageNamed:@"menuBtnOff2.png"];
    [m_btnFavourite setBackgroundImage:_image forState:0];
    
    _image = [UIImage imageNamed:@"menuBtnOff3.png"];
    [m_btnMyAccount setBackgroundImage:_image forState:0];
    
    _image = [UIImage imageNamed:@"menuBtnOff4.png"];
    [m_btnShare setBackgroundImage:_image forState:0];
}

- (void)showExtension
{
    //- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    
    SLComposeSheetConfigurationItem* item = [[SLComposeSheetConfigurationItem alloc] init];
    item.title = @"title";
    item.value = @"Download The Holy bridal and start planning your perfect wedding today! Available for iPhone & Android. <<LINK TO STORE";
    
    //return @[item];
    //}
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[@"Download The Holy bridal and start planning your perfect wedding today! Available for iPhone & Android."] applicationActivities:nil];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark ----- events ---------
- (IBAction)onBtnFindSuppliers:(id)sender
{
    [self allBtnUnselected];
    
    UIButton* _button = (UIButton*)sender;
    [self btnSelected:_button _index:1];
    
    ViewCtrlFindSuppliers *demoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewCtrlFindSuppliers"];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:demoViewController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)onBtnFavourites:(id)sender
{
    [self allBtnUnselected];
    
    UIButton* _button = (UIButton*)sender;
    [self btnSelected:_button _index:2];
    
    ViewCtrlFavourites *demoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewCtrlFavourites"];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:demoViewController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)onBtnMyAccount:(id)sender
{
    [self allBtnUnselected];
    
    UIButton* _button = (UIButton*)sender;
    [self btnSelected:_button _index:3];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    ViewCtrlRegister *demoViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewCtrlRegister"];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:demoViewController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)onBtnShare:(id)sender
{
    //[self allBtnUnselected];
    
    UIButton* _button = (UIButton*)sender;
    [self btnSelected:_button _index:4];
    
    GlobData* globData = [GlobData getInstance];
    switch (globData.currentItemIndex) {
        case 1:
            [self onBtnFindSuppliers:m_btnFindSupplier];
            break;
        case 2:
            [self onBtnFavourites:m_btnFavourite];
            break;
        case 3:
            [self onBtnMyAccount:m_btnMyAccount];
            break;
            
        default:
            break;
    }
    
    [self showExtension];
}

- (IBAction)onBtnLogout:(id)sender
{
    UIAlertView* _alertView = [[UIAlertView alloc] initWithTitle:@"Logout?" message:@"Are you sure you wish to logout of \n Holy Bridal?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout", nil];
    [_alertView show];
}

#pragma mark ---- alertView -------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // Cancel for Logout
            
            break;
            
        case 1: // Logout
            [self.menuContainerViewController dismissViewControllerAnimated:false completion:nil    ];
            break;
            
        default:
            break;
    }
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

@end
