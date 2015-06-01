//
//  GlobData.h
//  HolyBridal
//
//  Created by User on 3/25/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ModelSupplier;
@class ModelCategory;

@interface GlobData : NSObject

@property(nonatomic, retain) NSMutableArray* m_arrayCategories; // GlobData
@property(nonatomic, retain) NSMutableArray* m_arraySuppliers; // GlobData
@property(nonatomic, retain) NSMutableArray* m_arrayFavouriteSuppliers;
@property(nonatomic, retain) NSMutableArray* m_arrayFilters;

@property(nonatomic, retain) CLLocation* currentLocation;
@property(readwrite) BOOL isRegisterState; // To check if current state is register or update on AccountRegiste or AccoutUpdate
@property(readwrite) NSInteger currentItemIndex; // To check which button is clicked in Menu list
@property(readwrite) float currentDeviceVersion; // current Device Version


// ------- For temporary ----------
@property(readwrite) NSInteger intTemp; // To use as temporary parameter
@property(nonatomic, retain) NSString* strTemp;
@property(nonatomic, retain) ModelSupplier* supplierTemp;
@property(nonatomic, retain) ModelCategory* categoryTemp;


+(GlobData*)getInstance;
-(void)initAllInfo;
-(NSString*)generatePassword;
-(NSMutableArray*)getStrMonths;
-(NSMutableArray*)getFilterLists;
- (NSString*)getNumber:(NSInteger)_indexNum;

-(BOOL)isLogin;
-(void)login;
-(void)logout;

- (void) removeFavouriteSupplier:(ModelSupplier*)_supplier;
- (NSString*)calculateDistance:(CLLocation*)_locaton;

@end
