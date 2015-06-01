//
//  ViewCtrlFavourites.h
//  HolyBridal
//
//  Created by User on 3/25/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewCtrlFavourites : UIViewController < UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate >
{
    IBOutlet UITableView *m_tableView;
    
    IBOutlet UIView *m_viewSelectDate;
    IBOutlet UIPickerView *m_pickerViewFilter;
    
    NSMutableArray* m_arrayTblViewData;
    NSInteger m_intFilter;
    
    float _scale_X, _scale_Y;
}

- (IBAction)onBtnNavMenu:(id)sender;
- (IBAction)onBtnFilter:(id)sender;

- (IBAction)onBtnFilterSuppliers:(id)sender;
- (IBAction)onBtnSelectDate:(id)sender;
@end
