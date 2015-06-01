//
//  TextFldFormatter.h
//  HolyBridal
//
//  Created by User on 3/23/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFldFormatter : UIView
{
    
}

@property(readwrite) float SCALE_X;
@property(readwrite) float SCALE_Y;

+(TextFldFormatter*)getInstance;

- (void) initTextFldType:(UITextField*)_textFld placeholder:(NSString*)_txt;
- (void) resizeView:(UIView*)__view;

@end
