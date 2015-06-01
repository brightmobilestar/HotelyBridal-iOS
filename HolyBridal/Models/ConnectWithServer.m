//
//  ConnectWithServer.m
//  HolyBridal
//
//  Created by User on 3/27/15.
//  Copyright (c) 2015 steven. All rights reserved.
//

#import "ConnectWithServer.h"
#import "ModelCategory.h"
#import "ModelSupplier.h"
#import "GlobData.h"
#import "ModelUser.h"
#import <stdlib.h>

#define _BACKEND_SERVER_ @"http://www.theholybridal.co.uk"

@implementation ConnectWithServer

-(void)sendRequestPasswordRecover:(NSString*)_emailAddress password:(NSString*)_password
{
    NSString* _strPassword = _password;
    
    NSString* strUrl = [NSString stringWithFormat:@"%@/api/v1/account/password?email=%@&password=%@", _BACKEND_SERVER_, _emailAddress, _strPassword];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    if ( error == nil )
    {
        ModelUser* _user = [ModelUser getInstance];
        [_user resetPassword:_password];
    }   // end if no error
    else
    {
        NSLog(@"Networking problem getting to our system's Web Services!");
    }
    
    return;
}

-(NSString*)requestContact:(NSString*)_supplierID
{
    GlobData* globData = [GlobData getInstance];
    
    
    ModelUser* _user = [ModelUser getInstance];
    
    NSString* _strMethd;
    if (_user.m_isEmailMethod) {
        _strMethd = @"Email";
    } else {
        _strMethd = @"Mobilenumber";
    }
    
    NSString* _strDate = _user.m_strDateOfWedding;
    NSArray* _array = [_strDate componentsSeparatedByString:@" / "];
    for (int i = 0; i < 12; i ++) {
        
        if ([_array count] < 2) {
            break;
        }
        
        NSString* __strStr = [[globData getStrMonths] objectAtIndex:i];
        if ([__strStr isEqualToString:[_array objectAtIndex:1]]) {
            _strDate = [NSString stringWithFormat:@"%@/%d/%@", [_array objectAtIndex:0], i+1, [_array objectAtIndex:2]];
        }
    }
    
    NSString* strUrl = [NSString stringWithFormat:@"%@/api/v1/supplier/%@/request?name=%@&email=%@&telephone=%@&method=%@&date=%@", _BACKEND_SERVER_, _supplierID, _user.m_strFullName, _user.m_strEmail, _user.m_strMoileNumber, _strMethd, _strDate];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                          returningResponse:&response
                                      error:&error];
    if ( error == nil )
    {
        NSString* strTemp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSData* dataTemp = [strTemp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:dataTemp options:kNilOptions error:&error];
        
        NSString *_alertMessage = [ json objectForKey: @"description" ];
        
        BOOL __intTemp = (BOOL)[ json objectForKey:@"error" ];
        if (!__intTemp) {
            return @"";
        }
        
        _alertMessage = [NSString stringWithFormat:@"%@\n", _alertMessage];
        
        NSDictionary *responseB = [ json objectForKey: @"data" ];
        for( NSString *aKey in [responseB allKeys] )
        {
            NSString *_strTemp = [responseB objectForKey:aKey];
            
            _alertMessage = [NSString stringWithFormat:@"%@\n%@: %@", _alertMessage, aKey, _strTemp];
            
        }
        
        return _alertMessage;
    }   // end if no error
    else
    {
        NSLog(@"Networking problem getting to our system's Web Services!");
    }
    
    return @"";
}

-(NSMutableArray*)readCategories
{
    GlobData* globData = [GlobData getInstance];
    
    NSMutableArray* _arrayCategory = [[NSMutableArray alloc] init];
    
    NSString* strUrl = [NSString stringWithFormat:@"%@/api/v1/supplier/categories", _BACKEND_SERVER_];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    if ( error == nil )
    {
        
        NSString* strTemp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSData* dataTemp = [strTemp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:dataTemp options:kNilOptions error:&error];
        
        NSDictionary *responseA = [ json objectForKey: @"data" ];
        
        // initialize the DB list of events
        
        for( NSString *aKey in [responseA allKeys] )
        {
            NSDictionary *tempObj = [responseA objectForKey:aKey];
            
            ModelCategory *categoryObj = [[ModelCategory alloc] init];
            categoryObj.m_strID = [tempObj valueForKey:@"id"];
            categoryObj.m_strName = [tempObj valueForKey:@"name"];
            
            //[globData.m_arrayFilters addObject:categoryObj.m_strName];
            
            categoryObj.m_strImage = [tempObj valueForKey:@"image"];
            
            categoryObj.m_arraySuppliers = [[NSMutableArray alloc] init];
            
            NSDictionary* responseB = [tempObj valueForKey:@"suppliers"];
           for( NSString *bKey in [responseB allKeys] )
            {
                NSDictionary *eventObj2 = [responseB objectForKey:bKey];
                
                ModelSupplier* suplierObj = [[ModelSupplier alloc] init];
                suplierObj.m_strID = [eventObj2 valueForKey:@"id"];
                suplierObj.m_strName = [eventObj2 valueForKey:@"name"];
                suplierObj.m_strAddress = [eventObj2 valueForKey:@"address"];
                suplierObj.m_strLogo = [eventObj2 valueForKey:@"logo"];
                
                [self readSupplierFullInfo:suplierObj];
                
                [categoryObj.m_arraySuppliers addObject:suplierObj];
                [globData.m_arraySuppliers addObject:suplierObj];
                
                for (NSInteger i = 0; i < [globData.m_arraySuppliers count]; i ++) {
                    ModelSupplier* _inSupplier = [globData.m_arraySuppliers objectAtIndex:i];
                    if ([_inSupplier.m_strID isEqualToString:suplierObj.m_strID]) {
                        
                        [categoryObj.m_arraySuppliers removeObjectAtIndex:[categoryObj.m_arraySuppliers count] - 1];
                        [categoryObj.m_arraySuppliers addObject:_inSupplier];
                        
                        break;
                    }
                }
            }
            
            if ([categoryObj.m_arraySuppliers count] == 0) {
                continue;
            }
            
            [globData.m_arrayCategories addObject:categoryObj];
            
        }    // end for
    }   // end if no error
    else
    {
        NSLog(@"Networking problem getting to our system's Web Services!");
    }
    
    return(  _arrayCategory  );
}

-(NSMutableArray*)readAllSuppliersByCategory:(NSString*)_id
{
    NSMutableArray* _arrayCategory = [[NSMutableArray alloc] init];
    
    NSString* strUrl = [NSString stringWithFormat:@"%@/api/v1/supplier/categories/%@", _BACKEND_SERVER_, _id];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    if ( error == nil )
    {
        
        NSString* strTemp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSData* dataTemp = [strTemp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:dataTemp options:kNilOptions error:&error];
        
        NSDictionary *responseA = [ json objectForKey: @"data" ];
        
        // initialize the DB list of events
        
        for( NSString *aKey in [responseA allKeys] )
        {
            NSDictionary *tempObj = [responseA objectForKey:aKey];
            
            ModelCategory *categoryObj = [[ModelCategory alloc] init];
            categoryObj.m_strID = [tempObj valueForKey:@"id"];
            categoryObj.m_strName = [tempObj valueForKey:@"name"];
            categoryObj.m_strImage = [tempObj valueForKey:@"image"];
            
            categoryObj.m_arraySuppliers = [[NSMutableArray alloc] init];
            
//            if ([categoryObj.m_strID isEqualToString:@"7"]) {
//                continue; // now Data structure is not correct for suppliers
//            }
            
            NSDictionary* responseB = [tempObj valueForKey:@"suppliers"];
            for( NSString *bKey in [responseB allKeys] )
            {
                NSDictionary *eventObj2 = [responseB objectForKey:bKey];
                
                ModelSupplier* suplierObj = [[ModelSupplier alloc] init];
                suplierObj.m_strID = [eventObj2 valueForKey:@"id"];
                suplierObj.m_strName = [eventObj2 valueForKey:@"name"];
                suplierObj.m_strAddress = [eventObj2 valueForKey:@"address"];
                suplierObj.m_strLogo = [eventObj2 valueForKey:@"logo"];
                
                [_arrayCategory addObject:suplierObj];
            }
            
        }    // end for
    }   // end if no error
    else
    {
        NSLog(@"Networking problem getting to our system's Web Services!");
    }
    
    return(  _arrayCategory  );
}

-(NSMutableArray*)searchSuppliersByKeywordUnderCategory:(NSString*)_keyword categoryID:(NSString*)_id
{
    NSMutableArray* _arrayCategory = [[NSMutableArray alloc] init];
    
    NSString* strUrl = [NSString stringWithFormat:@"%@/api/v1/supplier/categories/%@/search/%@", _BACKEND_SERVER_, _id, _keyword];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    if ( error == nil )
    {
        
        NSString* strTemp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSData* dataTemp = [strTemp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:dataTemp options:kNilOptions error:&error];
        
        NSDictionary *responseA = [ json objectForKey: @"data" ];
        
        // initialize the DB list of events
        
        for( NSString *aKey in [responseA allKeys] )
        {
            NSDictionary *tempObj = [responseA objectForKey:aKey];
            
            ModelCategory *categoryObj = [[ModelCategory alloc] init];
            categoryObj.m_strID = [tempObj valueForKey:@"id"];
            categoryObj.m_strName = [tempObj valueForKey:@"name"];
            categoryObj.m_strImage = [tempObj valueForKey:@"image"];
            
            categoryObj.m_arraySuppliers = [[NSMutableArray alloc] init];
            
//            if ([categoryObj.m_strID isEqualToString:@"7"]) {
//                continue; // now Data structure is not correct for suppliers
//            }
            
            NSDictionary* responseB = [tempObj valueForKey:@"suppliers"];
            for( NSString *bKey in [responseB allKeys] )
            {
                NSDictionary *eventObj2 = [responseB objectForKey:bKey];
                
                ModelSupplier* suplierObj = [[ModelSupplier alloc] init];
                suplierObj.m_strID = [eventObj2 valueForKey:@"id"];
                suplierObj.m_strName = [eventObj2 valueForKey:@"name"];
                suplierObj.m_strAddress = [eventObj2 valueForKey:@"address"];
                suplierObj.m_strLogo = [eventObj2 valueForKey:@"logo"];
                
                [_arrayCategory addObject:suplierObj];
            }
            
        }    // end for
    }   // end if no error
    else
    {
        NSLog(@"Networking problem getting to our system's Web Services!");
    }
    
    return(  _arrayCategory  );
}

-(void) readSupplierFullInfo:(ModelSupplier*)_modelSupplier
{
    NSString* strUrl = [NSString stringWithFormat:@"%@/api/v1/supplier/%@", _BACKEND_SERVER_, _modelSupplier.m_strID];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    if ( error == nil )
    {
        
        NSString* strTemp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSData* dataTemp = [strTemp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:dataTemp options:kNilOptions error:&error];
        
        NSDictionary *responseA = [ json objectForKey: @"data" ];
        
        // initialize the DB list of events
        
        //for( NSString *aKey in [responseA allKeys] )
        {
            NSDictionary *tempObj = responseA; //[responseA objectForKey:aKey];
            
            _modelSupplier.m_strID = [tempObj valueForKey:@"id"];
            _modelSupplier.m_strName = [tempObj valueForKey:@"name"];
            _modelSupplier.m_strLogo = [tempObj valueForKey:@"logo"];
            _modelSupplier.m_strAbout = [tempObj valueForKey:@"about"];
            _modelSupplier.m_strEmail = [tempObj valueForKey:@"email"];
            _modelSupplier.m_strTelephone = [tempObj valueForKey:@"telephone"];
            _modelSupplier.m_strAddress_l1 = [tempObj valueForKey:@"address_l1"];
            _modelSupplier.m_strAddress_l2 = [tempObj valueForKey:@"address_l2"];
            _modelSupplier.m_strCountry = [tempObj valueForKey:@"county"];
            _modelSupplier.m_strTown = [tempObj valueForKey:@"town"];
            _modelSupplier.m_strPostcode = [tempObj valueForKey:@"postcode"];
            _modelSupplier.m_strWebsite = [tempObj valueForKey:@"website"];
            
            _modelSupplier.m_arrayFeaturedImages = [[NSMutableArray alloc] init];
            
            NSDictionary* responseB = [tempObj valueForKey:@"featured"];
            for( NSString *bKey in [responseB allKeys] )
            {
                NSString* _strImage = [responseB objectForKey:bKey];
                
                [_modelSupplier.m_arrayFeaturedImages addObject:_strImage];
            }
            
            _modelSupplier.m_strLocationLat = [tempObj valueForKey:@"lat"];
            _modelSupplier.m_strLocationLng = [tempObj valueForKey:@"lng"];
            
            _modelSupplier.m_arrayCategories = [[NSMutableArray alloc] init];
            
             // now Data structure is not correct for categories
            
            responseB = [tempObj valueForKey:@"categories"];
            for( NSString *bKey in [responseB allKeys] )
            {
                NSDictionary *eventObj2 = [responseB objectForKey:bKey];
                
                ModelCategory* categoryObj = [[ModelCategory alloc] init];
                categoryObj.m_strID = [eventObj2 valueForKey:@"id"];
                categoryObj.m_strName = [eventObj2 valueForKey:@"name"];
                
                [_modelSupplier.m_arrayCategories addObject:categoryObj];
            }
            
        }    // end for
    }   // end if no error
    else
    {
        NSLog(@"Networking problem getting to our system's Web Services!");
    }
    
    return;

}

@end
