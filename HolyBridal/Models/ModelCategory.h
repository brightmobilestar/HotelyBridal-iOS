//
//  ModelCategory.h
//  HolyBridal
//
//  Created by User on 3/27/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelSupplier;

@interface ModelCategory : NSObject

@property(nonatomic, retain) NSString* m_strID;
@property(nonatomic, retain) NSString* m_strName;
@property(nonatomic, retain) NSString* m_strImage;
@property(nonatomic, retain) NSMutableArray* m_arraySuppliers;

@end
