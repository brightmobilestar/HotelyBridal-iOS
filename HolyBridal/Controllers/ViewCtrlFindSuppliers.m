//
//  ViewCtrlFindSuppliers.m
//  HolyBridal
//
//  Created by User on 3/24/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import "ViewCtrlFindSuppliers.h"
#import "TextFldFormatter.h"
#import "MFSideMenu.h"
#import "GlobData.h"
#import "ConnectWithServer.h"
#import "ModelCategory.h"
#import "AsyncImageView.h"
#import "UIImage+animatedGIF.h"
#import "ModelUser.h"

@interface ViewCtrlFindSuppliers ()

@end

@implementation ViewCtrlFindSuppliers

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initControllers];
    
    TextFldFormatter* _formatter = [TextFldFormatter getInstance];
    [_formatter resizeView:self.view];
    _scale_X = _formatter.SCALE_X;
    _scale_Y = _formatter.SCALE_Y;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [m_tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self loadData];
}

- (void) loadData
{
    GlobData* globData = [GlobData getInstance];
    
    if ([globData.m_arrayCategories count] == 0) {
        [self getData];
    }
    
    [m_arrayTblViewData removeAllObjects];
    
    for (NSInteger i = 0; i < [globData.m_arrayCategories count]; i ++) {
        ModelCategory* _modelCategory = [globData.m_arrayCategories objectAtIndex:i];
        [m_arrayTblViewData addObject:_modelCategory];
    }
    
    [m_tableView reloadData];
    
    m_viewLoading.hidden = true;
}

- (void)searchCategoryByKeyword:(NSString*)_keyword
{
    GlobData* globData = [GlobData getInstance];
    
    [m_arrayTblViewData removeAllObjects];
    
    for (NSInteger i = 0; i < [globData.m_arrayCategories count]; i ++) {
        ModelCategory* _modelCategory = [globData.m_arrayCategories objectAtIndex:i];
        
        if ([_keyword isEqualToString:@""]) {
            [m_arrayTblViewData addObject:_modelCategory];
        } else if ([[_modelCategory.m_strName uppercaseString] containsString:[_keyword uppercaseString]]) {
            [m_arrayTblViewData addObject:_modelCategory];
        }
        //[m_arrayTblViewData addObject:_modelCategory];
    }
    
    [m_tableView reloadData];
}

- (void) getData
{
    ConnectWithServer* _server = [[ConnectWithServer alloc] init];
    [_server readCategories];
}

- (void) initControllers
{
    m_arrayTblViewData = [[NSMutableArray alloc] init];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillShowNotification object:nil];
    
    GlobData* globData = [GlobData getInstance];
    globData.isRegisterState = false;
    
    self.navigationController.navigationBarHidden = true;
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"dribbble" withExtension:@"gif"];
    m_imageViewLoading.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    m_viewLoading.hidden = false;
    
    [self formartTxtFld];
}

- (void) formartTxtFld
{
    
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void) displayLoadingView
{
    
}

#pragma mark ------ search bar ----------
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar                      // return NO to not become first responder
{
    return true;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    NSString* _searchKey = searchBar.text;
    [self searchCategoryByKeyword:_searchKey];
}

//- (BOOL)searchBar:(UISearchBar *)sea.rchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0); // called before text changes

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSString* _searchKey = searchBar.text;
    //[self searchCategoryByKeyword:_searchKey];
    
    [self onBtnNavSearch:nil];
}

#pragma mark ----- delegate --- scrolling -------
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    m_viewFull.center = CGPointMake(m_viewFull.center.x * _scale_X, 287 * _scale_Y);
    m_viewFull.frame = CGRectMake(0, 6 * _scale_Y, 320 * _scale_X, 562 * _scale_Y);
    m_tableView.frame = CGRectMake(0, 44 * _scale_Y, 320 * _scale_X, 518 * _scale_Y);

    [UIView commitAnimations];
    
    [m_searchBar resignFirstResponder];
}

#pragma mark ---- tableView --------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrayTblViewData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 158 * _scale_Y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCategory* _modelCategory = [m_arrayTblViewData objectAtIndex:indexPath.row];
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel* _lblName = (UILabel*)[_cell viewWithTag:1];
    [_lblName setText:_modelCategory.m_strName];
    
    UIImageView* _imageViewImage = (UIImageView*)[_cell viewWithTag:2];
    [_imageViewImage setImageURL:[NSURL URLWithString:_modelCategory.m_strImage]];
    
    TextFldFormatter* _formatter = [TextFldFormatter getInstance];
    
    if (_imageViewImage.frame.size.width < 288 * _scale_X - 3) {
        [_formatter resizeView:_cell];
    }
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GlobData* globData = [GlobData getInstance];
    
    globData.categoryTemp = [m_arrayTblViewData objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"sequepushToFlorists" sender:nil];
}

#pragma mark ------ control - events --------------
-(IBAction)returnToFindSuppliers:(UIStoryboardSegue *)sender
{
    
}

- (IBAction)onBtnNavSearch:(id)sender {
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    NSInteger temp_intCenter = m_viewFull.center.y;
    NSInteger temp_intPosition = 287 * _scale_Y;
    
    if (temp_intCenter < temp_intPosition + 5 && temp_intCenter > temp_intPosition - 5) {
        
//        m_viewFull.center = CGPointMake(m_viewFull.center.x, 328);
//        m_viewFull.frame = CGRectMake(0, 48, 320, 520);
//        m_tableView.frame = CGRectMake(0, 44, 320, 480);
        
        m_viewFull.center = CGPointMake(m_viewFull.center.x * _scale_X, 328 * _scale_Y);
        m_viewFull.frame = CGRectMake(0, 48 * _scale_Y, 320 * _scale_X, 520 * _scale_Y);
        m_tableView.frame = CGRectMake(0, 44 * _scale_Y, 320 * _scale_X, 478 * _scale_Y);
        
    } else {
        
//        m_viewFull.center = CGPointMake(m_viewFull.center.x, 287);
//        m_viewFull.frame = CGRectMake(0, 6, 320, 562);
//        m_tableView.frame = CGRectMake(0, 44, 320, 520);
        
        m_viewFull.center = CGPointMake(m_viewFull.center.x * _scale_X, 287 * _scale_Y);
        m_viewFull.frame = CGRectMake(0, 6 * _scale_Y, 320 * _scale_X, 562 * _scale_Y);
        m_tableView.frame = CGRectMake(0, 44 * _scale_Y, 320 * _scale_X, 518 * _scale_Y);
    }
    
    [m_searchBar resignFirstResponder];
    
    
    [UIView commitAnimations];
}

- (IBAction)onBtnNavMenu:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
