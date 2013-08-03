//
//  APIClient.m
//  LodgeManager
//
//  Created by Nico Nägele on 7/21/13.
//  Copyright (c) 2013 n2305. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient
+ (id)sharedInstance {
    static APIClient* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APIClient alloc] initWithBaseURL:
                          [NSURL URLWithString:APIBaseURLString]];
    });
    
    return sharedInstance;
}
@end
