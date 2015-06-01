//
//  ViewCtrlFavourites.m
//  HolyBridal
//
//  Created by User on 3/25/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import "ViewCtrlFavourites.h"
#import "TextFldFormatter.h"
#import "MFSideMenu.h"
#import "ModelSupplier.h"
#import "ModelCategory.h"
#import "GlobData.h"

@interface ViewCtrlFavourites ()

@end

@implementation ViewCtrlFavourites

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_arrayTblViewData = [[NSMutableArray alloc] init];
    m_intFilter = 0;
    
    TextFldFormatter* _formatter = [TextFldFormatter getInstance];
    [_formatter resizeView:self.view];
    _scale_X = _formatter.SCALE_X;
    _scale_Y = _formatter.SCALE_Y;
}

- (void)vieWillAppear
{
    [m_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    GlobData* globData = [GlobData getInstance];
    [globData.m_arrayFilters removeAllObjects];
    [globData.m_arrayFilters addObject:@"All"];
    
    [m_arrayTblViewData removeAllObjects];
    
    for (NSInteger i = 0; i < [globData.m_arrayFavouriteSuppliers count]; i ++) {
        ModelSupplier* _modelSupplier = [globData.m_arrayFavouriteSuppliers objectAtIndex:i];
        
        [m_arrayTblViewData addObject:_modelSupplier];
        
        for (int j = 0; j < [_modelSupplier.m_arrayCategories count]; j ++) {
            ModelCategory* _category = [_modelSupplier.m_arrayCategories objectAtIndex:j];
            [self addFilter:_category.m_strName];
        }
    }
    
    [m_tableView reloadData];
    [m_pickerViewFilter reloadAllComponents];
}

- (void) addFilter:(NSString*)_filter
{
    GlobData* globData = [GlobData getInstance];
    
    for (NSInteger i = 0; i < [globData.m_arrayFilters count]; i ++) {
        NSString* _strTemp = [globData.m_arrayFilters objectAtIndex:i];
        if ([_strTemp isEqualToString:_filter]) {
            [globData.m_arrayFilters removeObject:_filter];
            break;
        }
    }
    
    [globData.m_arrayFilters addObject:_filter];
}

- (void)filter
{
    GlobData* globData = [GlobData getInstance];
    [m_arrayTblViewData removeAllObjects];
    
    NSString* _strFilter = [globData.m_arrayFilters objectAtIndex:m_intFilter];
    
    for (NSInteger i = 0; i < [globData.m_arrayFavouriteSuppliers count]; i ++) {
        ModelSupplier* _modelSupplier = [globData.m_arrayFavouriteSuppliers objectAtIndex:i];
        
        for (int i = 0; i < [_modelSupplier.m_arrayCategories count]; i ++) {
            ModelCategory* _category = [_modelSupplier.m_arrayCategories objectAtIndex:i];
            if ( (m_intFilter == 0) || [_category.m_strName isEqualToString:_strFilter]) {
                [m_arrayTblViewData addObject:_modelSupplier];
                break;
            }
        }
        
        //[m_arrayTblViewData addObject:_modelSupplier];
    }
    
    [m_tableView reloadData];
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

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark ---- events --------------
- (IBAction)onBtnNavMenu:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (IBAction)onBtnFilter:(id)sender {
    [self displayViewSelectDate];
}

- (IBAction)onBtnFilterSuppliers:(id)sender
{
    [self hideViewSelectDate];
}

- (IBAction)onBtnSelectDate:(id)sender
{
    [self filter];
    [self hideViewSelectDate];
}

#pragma mark ---- picker view ---------------
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    GlobData* globData = [GlobData getInstance];
    return [[globData getFilterLists] count];
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    GlobData* globData = [GlobData getInstance];
//    NSMutableArray* _array = [globData getFilterLists];
//    return [_array objectAtIndex:row];
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    GlobData* globData = [GlobData getInstance];
    NSMutableArray* _array = [globData getFilterLists];

    UILabel* tView = (UILabel*)view;
    if (tView == nil) {
        tView = [[UILabel alloc] init];
        tView.text = [_array objectAtIndex:row];
        tView.textAlignment = UIBaselineAdjustmentAlignCenters;
    }
    
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    m_intFilter = row;
}

#pragma mark ---- tableView --------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([m_arrayTblViewData count] == 0) {
        return 1;
    }
    return [m_arrayTblViewData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44 * _scale_Y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    
    if ([m_arrayTblViewData count] == 0) {
        UITableViewCell* __cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell_NoFavourite" forIndexPath:indexPath];
        __cell.userInteractionEnabled = false;
        
        TextFldFormatter* _formatter = [TextFldFormatter getInstance];
        UILabel* _lblAddress = (UILabel*)[__cell viewWithTag:2];
        if (_lblAddress.frame.size.width < 232 * _scale_X - 3) {
            [_formatter resizeView:__cell];
        }
        
        return __cell;
    }
    
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
    [self performSegueWithIdentifier:@"sequepushFromFavouriteToSupplierDetail" sender:nil];
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
