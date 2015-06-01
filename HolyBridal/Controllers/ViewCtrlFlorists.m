//
//  ViewCtrlFlorists.m
//  HolyBridal
//
//  Created by User on 2015. 3. 25..
//  Copyright (c) 2015년 steven. All rights reserved.
//

#import "ViewCtrlFlorists.h"
#import "TextFldFormatter.h"
#import "MFSideMenu.h"
#import "GlobData.h"
#import "ModelCategory.h"
#import "ModelSupplier.h"
#import "ConnectWithServer.h"

@interface ViewCtrlFlorists ()

@end

@implementation ViewCtrlFlorists

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GlobData* globData = [GlobData getInstance];
    m_currentCategory = globData.categoryTemp;
    
    [m_lblTitle setText:m_currentCategory.m_strName];
    
    [self initObjects];
    
    TextFldFormatter* _formatter = [TextFldFormatter getInstance];
    [_formatter resizeView:self.view];
    _scale_X = _formatter.SCALE_X;
    _scale_Y = _formatter.SCALE_Y;
}

- (void)viewWillAppear:(BOOL)animated
{
    [m_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadData];
}

- (void) initObjects
{
    m_arrayTblViewData = [[NSMutableArray alloc] init];
}

- (void) loadData
{
    [self searchSupplierByKeyword:m_searchBar.text];
}

- (void)searchSupplierByKeyword:(NSString*)_keyword
{
    ModelCategory* _modelCategory = m_currentCategory;
    
    [m_arrayTblViewData removeAllObjects];
    
    for (NSInteger i = 0; i < [_modelCategory.m_arraySuppliers count]; i ++) {
        ModelSupplier* _modelSupplier = [_modelCategory.m_arraySuppliers objectAtIndex:i];
        
        if ([_keyword isEqualToString:@""]) {
            [m_arrayTblViewData addObject:_modelSupplier];
        } else if ([[_modelSupplier.m_strName uppercaseString] containsString:[_keyword uppercaseString]]) {
            [m_arrayTblViewData addObject:_modelSupplier];
        }
    }
    
    [m_tableView reloadData];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark ------ events ------------
-(IBAction)returnToFlorists:(UIStoryboardSegue *)sender
{
    
}

- (IBAction)onBtnNavSearch:(id)sender {
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    NSInteger temp_intCenter = m_viewFull.center.y;
    NSInteger temp_intPosition = 288 * _scale_Y;
    
    if (temp_intCenter < temp_intPosition + 4 && temp_intCenter > temp_intPosition - 4) {
        
//        m_viewFull.center = CGPointMake(m_viewFull.center.x, 329);
//        m_viewFull.frame = CGRectMake(0, 48, 320, 520);
//        m_tableView.frame = CGRectMake(0, 40, 320, 480);
        
        m_viewFull.center = CGPointMake(m_viewFull.center.x * _scale_X, 328 * _scale_Y);
        m_viewFull.frame = CGRectMake(0, 48 * _scale_Y, 320 * _scale_X, 520 * _scale_Y);
        m_tableView.frame = CGRectMake(0, 44 * _scale_Y, 320 * _scale_X, 478 * _scale_Y);
        
    } else {
        
//        m_viewFull.center = CGPointMake(m_viewFull.center.x, 288);
//        m_viewFull.frame = CGRectMake(0, 8, 320, 560);
//        m_tableView.frame = CGRectMake(0, 40, 320, 520);
        
        m_viewFull.center = CGPointMake(m_viewFull.center.x * _scale_X, 287 * _scale_Y);
        m_viewFull.frame = CGRectMake(0, 6 * _scale_Y, 320 * _scale_X, 562 * _scale_Y);
        m_tableView.frame = CGRectMake(0, 44 * _scale_Y, 320 * _scale_X, 518 * _scale_Y);
    }
    
    [m_searchBar resignFirstResponder];
    
    [UIView commitAnimations];
}

#pragma mark ------ search bar ----------
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar                      // return NO to not become first responder
{
    return true;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    [self searchSupplierByKeyword:searchBar.text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
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
    return 44 * _scale_Y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelSupplier* _modelSupplier = [m_arrayTblViewData objectAtIndex:indexPath.row];
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel* _lblName = (UILabel*)[_cell viewWithTag:1];
    [_lblName setText:_modelSupplier.m_strName];
    
    UILabel* _lblAddress = (UILabel*)[_cell viewWithTag:2];
    [_lblAddress setText:_modelSupplier.m_strAddress];
    
    UILabel* _lblDistance = (UILabel*)[_cell viewWithTag:3];
    
    CLLocation* _location = [[CLLocation alloc] initWithLatitude:[_modelSupplier.m_strLocationLat floatValue] longitude:[_modelSupplier.m_strLocationLng floatValue]];
    
    GlobData* globData = [GlobData getInstance];
    NSString* _strDistance = [globData calculateDistance:_location];
    
    [_lblDistance setText:_strDistance];
    
    TextFldFormatter* _formatter = [TextFldFormatter getInstance];
    
    if (_lblAddress.frame.size.width < 232 * _scale_X - 3) {
        [_formatter resizeView:_cell];
    }
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GlobData* globData = [GlobData getInstance];
    
    globData.supplierTemp = [m_arrayTblViewData objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"sequepushToSupplierDetail" sender:nil];
}

#pragma mark ---- Keyboard --------
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyAll];
}

- (void) hideKeyAll
{
    [m_searchBar resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyAll];
    return true;
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
