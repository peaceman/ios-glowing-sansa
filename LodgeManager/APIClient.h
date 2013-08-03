//
//  APIClient.h
//  LodgeManager
//
//  Created by Nico Nägele on 7/21/13.
//  Copyright (c) 2013 n2305. All rights reserved.
//

#import "AFHTTPClient.h"

#define APIBaseURLString @"http://glowing-sansa.nc23.de/api/v1/"

@interface APIClient : AFHTTPClient
+ (id)sharedInstance;
@end
