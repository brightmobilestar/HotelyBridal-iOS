//
//  ModelUser.h
//  HolyBridal
//
//  Created by User on 3/30/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelUser : NSObject

@property(nonatomic, retain) NSString* m_strFullName;
@property(nonatomic, retain) NSString* m_strEmail;
@property(nonatomic, retain) NSString* m_strPassword;
@property(nonatomic, retain) NSString* m_strMoileNumber;

@property(readwrite) BOOL m_isEmailMethod;

@property(nonatomic, retain) NSString* m_strDateOfWedding;



+(ModelUser*)getInstance;

-(void)save;
-(void)read;
-(void)resetPassword:(NSString*)_strPassword;

@end
