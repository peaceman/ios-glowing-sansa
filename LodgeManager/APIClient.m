//
//  APIClient.m
//  LodgeManager
//
//  Created by Nico Nägele on 7/21/13.
//  Copyright (c) 2013 n2305. All rights reserved.
//

#import "APIClient.h"
#import "AFJSONRequestOperation.h"

@implementation APIClient
+ (id)sharedInstance
{
    static APIClient* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APIClient alloc] initWithBaseURL:
                          [NSURL URLWithString:APIBaseURLString]];
    });
    
    return sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}
@end
