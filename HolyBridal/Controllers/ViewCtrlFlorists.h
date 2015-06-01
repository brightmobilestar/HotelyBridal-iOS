//
//  ViewCtrlFlorists.h
//  HolyBridal
//
//  Created by User on 2015. 3. 25..
//  Copyright (c) 2015년 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelCategory;

@interface ViewCtrlFlorists : UIViewController< UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate >
{
    NSMutableArray *m_arrayTblViewData;
    ModelCategory* m_currentCategory;
    
    float _scale_X, _scale_Y;
    
    IBOutlet UILabel *m_lblTitle;
    
    IBOutlet UIView *m_viewFull;
    IBOutlet UISearchBar *m_searchBar;
    IBOutlet UITableView *m_tableView;
}

-(IBAction)returnToFlorists:(UIStoryboardSegue *)sender;

- (IBAction)onBtnNavSearch:(id)sender;

@end
