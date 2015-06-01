//
//  ModelSupplier.h
//  HolyBridal
//
//  Created by User on 3/27/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelSupplier : NSObject

@property(nonatomic, retain) NSString* m_strID;
@property(nonatomic, retain) NSString* m_strName;
@property(nonatomic, retain) NSString* m_strAddress;
@property(nonatomic, retain) NSString* m_strLogo;

@property(nonatomic, retain) NSString* m_strAbout;
@property(nonatomic, retain) NSString* m_strEmail;
@property(nonatomic, retain) NSString* m_strTelephone;
@property(nonatomic, retain) NSString* m_strWebsite;
@property(nonatomic, retain) NSString* m_strAddress_l1;
@property(nonatomic, retain) NSString* m_strAddress_l2;
@property(nonatomic, retain) NSString* m_strCountry;
@property(nonatomic, retain) NSString* m_strTown;
@property(nonatomic, retain) NSString* m_strPostcode;

@property(nonatomic, retain) NSMutableArray* m_arrayFeaturedImages;

@property(nonatomic, retain) NSString* m_strLocationLat;
@property(nonatomic, retain) NSString* m_strLocationLng;

@property(nonatomic, retain) NSMutableArray* m_arrayCategories;

@property(readwrite) BOOL m_isFavorite;


@end
