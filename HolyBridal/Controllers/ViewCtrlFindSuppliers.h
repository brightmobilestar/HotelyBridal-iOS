//
//  ViewCtrlFindSuppliers.h
//  HolyBridal
//
//  Created by User on 3/24/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewCtrlFindSuppliers : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableArray* m_arrayTblViewData;
    float _scale_X, _scale_Y;
    
    
    IBOutlet UIView *m_viewFull;
    IBOutlet UISearchBar *m_searchBar;
    IBOutlet UITableView *m_tableView;
    
    IBOutlet UIView* m_viewLoading;
    IBOutlet UIImageView* m_imageViewLoading;
}

-(IBAction)returnToFindSuppliers:(UIStoryboardSegue *)sender;

- (IBAction)onBtnNavSearch:(id)sender;

- (IBAction)onBtnNavMenu:(id)sender;

@end