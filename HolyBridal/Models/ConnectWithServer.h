//
//  ConnectWithServer.h
//  HolyBridal
//
//  Created by User on 3/27/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelSupplier.h"

@interface ConnectWithServer : NSObject

-(void)sendRequestPasswordRecover:(NSString*)_emailAddress password:(NSString*)_password;
-(NSMutableArray*)readCategories;
-(void) readSupplierFullInfo:(ModelSupplier*)_modelSupplier;
-(NSString*)requestContact:(NSString*)_supplierID;

@end
