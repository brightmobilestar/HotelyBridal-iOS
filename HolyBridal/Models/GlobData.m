//
//  GlobData.m
//  HolyBridal
//
//  Created by User on 3/25/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import "GlobData.h"
#import "ModelCategory.h"
#import "ModelSupplier.h"

#define UserInfo @"HolyBridal.UserInfo"
#define Login @"HolyBridal.UserInfoLogin"

@implementation GlobData

@synthesize currentLocation;
@synthesize m_arrayCategories;
@synthesize m_arraySuppliers;
@synthesize m_arrayFilters;
@synthesize isRegisterState;
@synthesize currentItemIndex;
@synthesize currentDeviceVersion;
@synthesize intTemp;
@synthesize supplierTemp;
@synthesize categoryTemp;

static GlobData *instance = nil;

+(GlobData *)getInstance
{
    @synchronized( self )
    {
        if ( instance == nil )
        {
            instance = [GlobData new];
            [instance initAllInfo];
        }
    }
    return( instance );
}

-(void)initAllInfo
{
    instance.isRegisterState = true;
    instance.currentItemIndex = 1;
    instance.m_arrayCategories = [[NSMutableArray alloc] init];
    instance.m_arraySuppliers = [[NSMutableArray alloc] init];
    instance.m_arrayFavouriteSuppliers = [[NSMutableArray alloc] init];
    instance.m_arrayFilters = [[NSMutableArray alloc] initWithObjects:@"All", nil];
    instance.currentLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
}

- (NSString*)generatePassword
{
    NSString* _strPassword = @"";
    
    NSMutableArray* _array = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0", nil];
    
    NSTimeInterval milSec = [[NSDate date] timeIntervalSince1970];
    NSInteger intDate = milSec;
    
    int r = rand() % [_array count];
    
    for (int i = 0; i < intDate % 20; i ++) {
        r = rand();
    }
    
    for (int i = 0; i < 4; i ++) {
        r = rand() % [_array count];
        
        _strPassword = [NSString stringWithFormat:@"%@%@", _strPassword, [_array objectAtIndex:r]];
    }
    
    return _strPassword;
}

- (NSString*)getNumber:(NSInteger)_indexNum
{
    NSMutableArray* _array = [[NSMutableArray alloc] initWithObjects:@"00", @"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"0", nil];
    return [_array objectAtIndex:_indexNum];
}

-(BOOL)isLogin
{
    NSUserDefaults* prefs = [[NSUserDefaults alloc] initWithSuiteName:UserInfo];
    
    if (self.currentDeviceVersion < 8.0) {
        prefs = [NSUserDefaults standardUserDefaults];
    }
    
    //self.m_strFullName = [prefs stringForKey:Login];
    
    if ( [[prefs stringForKey:Login] isEqual:@"login"] ) {
        return true;
    } else {
        return false;
    }
    
    return true;
}

-(void)login
{
    NSUserDefaults* prefs = [[NSUserDefaults alloc] initWithSuiteName:UserInfo];
    
    if (self.currentDeviceVersion < 8.0) {
        prefs = [NSUserDefaults standardUserDefaults];
    }
    
    [prefs setObject:@"login" forKey:Login];
}

-(void)logout
{
    NSUserDefaults* prefs = [[NSUserDefaults alloc] initWithSuiteName:UserInfo];
    
    if (self.currentDeviceVersion < 8.0) {
        prefs = [NSUserDefaults standardUserDefaults];
    }
    
    [prefs setObject:@"logout" forKey:Login];
}

-(NSMutableArray*)getStrMonths
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithObjects: @"January", @"Feburary", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil];
    
    return array;
}

- (NSMutableArray*)getFilterLists
{
    NSMutableArray* array = self.m_arrayFilters; //[[NSMutableArray alloc] initWithObjects:@"All", @"Florist", @"Photography", @"Catering", @"Dresses", @"Etc...", nil];
    
    return array;
}

- (void) removeFavouriteSupplier:(ModelSupplier*)_supplier
{
    GlobData* globData = [GlobData getInstance];
    for (NSInteger i = 0; i < [globData.m_arrayFavouriteSuppliers count]; i ++) {
        ModelSupplier* _modelSupplier = [globData.m_arrayFavouriteSuppliers objectAtIndex:i];
        if ([_modelSupplier.m_strID isEqualToString:_supplier.m_strID]) {
            [globData.m_arrayFavouriteSuppliers removeObjectAtIndex:i];
            break;
        }
    }
}

- (NSString*)calculateDistance:(CLLocation*)_locaton
{
    GlobData* globData = [GlobData getInstance];
    
    float intdistand = [_locaton distanceFromLocation:globData.currentLocation];
    intdistand = intdistand / 250;
    
    NSString* _strDiatance = [NSString stringWithFormat:@"%.2f", intdistand];
    return _strDiatance;
}



@end
