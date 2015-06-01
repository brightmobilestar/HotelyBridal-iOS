//
//  TextFldFormatter.m
//  HolyBridal
//
//  Created by User on 3/23/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import "TextFldFormatter.h"

@implementation TextFldFormatter

@synthesize SCALE_X;
@synthesize SCALE_Y;

static TextFldFormatter *instance = nil;

+(TextFldFormatter *)getInstance
{
    @synchronized( self )
    {
        if ( instance == nil )
        {
            instance = [TextFldFormatter new];
            
            instance.SCALE_X = ((float)[UIScreen mainScreen].applicationFrame.size.width) / 320.0f;
            instance.SCALE_Y = ((float)[UIScreen mainScreen].applicationFrame.size.height + 22) / 568.f;
        }
    }
    return( instance );
}

- (void) initTextFldType:(UITextField*)_textFld placeholder:(NSString*)_txt
{
    UIColor *color = [UIColor grayColor];
    
    _textFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_txt attributes:@{NSForegroundColorAttributeName: color}];
}

- (void) resizeView:(UIView*)__view
{
    NSArray* _subViews = [__view subviews];
    for (UIView *subView in _subViews) {
        NSLog(@"%@", subView);
        
        [self resizeView:subView];
        
        [subView setFrame:CGRectMake(subView.frame.origin.x * SCALE_X, subView.frame.origin.y * SCALE_Y, subView.frame.size.width * SCALE_X , subView.frame.size.height * SCALE_Y)];
        
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
