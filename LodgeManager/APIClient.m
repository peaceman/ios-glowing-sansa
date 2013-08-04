//
//  APIClient.m
//  LodgeManager
//
//  Created by Nico Nägele on 7/21/13.
//  Copyright (c) 2013 n2305. All rights reserved.
//

#import "APIClient.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

@interface APIClient()
@property NSURL* nextPageUrl;
@end

@implementation APIClient
#pragma mark Initialization

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

#pragma mark Data Loading
- (void)fetchLodges:(void (^)(id))successBlock
{
    [self getPath:@"lodges" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        self.nextPageUrl = [self nextPageURLFromOperation:operation];
        NSLog(@"nextPageUrl: %@", self.nextPageUrl);
        successBlock(JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)fetchNextLodges:(void (^)(id))successBlock
{
    if (!self.nextPageUrl) {
        successBlock(nil);
        return;
    }
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.nextPageUrl];
    [request setAllHTTPHeaderFields:@{@"Accept": [self defaultValueForHeader:@"Accept"]}];
    
    AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.nextPageUrl = [self nextPageURLFromOperation:operation];
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
    
    
    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark Pagination

- (NSURL *)nextPageURLFromOperation:(AFHTTPRequestOperation *)operation {
	NSDictionary *header = operation.response.allHeaderFields;
	NSString *linksString = header[@"Link"];
	if (linksString.length < 1) return nil;
    
	NSError *error = nil;
	NSRegularExpression *relPattern = [NSRegularExpression regularExpressionWithPattern:@"rel=\\\"?([^\\\"]+)\\\"?" options:NSRegularExpressionCaseInsensitive error:&error];
	NSAssert(relPattern != nil, @"Error constructing regular expression pattern: %@", error);
    
	NSMutableCharacterSet *whitespaceAndBracketCharacterSet = [NSCharacterSet.whitespaceCharacterSet mutableCopy];
	[whitespaceAndBracketCharacterSet addCharactersInString:@"<>"];
    
	NSArray *links = [linksString componentsSeparatedByString:@","];
	for (NSString *link in links) {
		NSRange semicolonRange = [link rangeOfString:@";"];
		if (semicolonRange.location == NSNotFound) continue;
        
		NSString *URLString = [[link substringToIndex:semicolonRange.location] stringByTrimmingCharactersInSet:whitespaceAndBracketCharacterSet];
		if (URLString.length == 0) continue;
        
		NSTextCheckingResult *result = [relPattern firstMatchInString:link options:0 range:NSMakeRange(0, link.length)];
		if (result == nil) continue;
        
		NSString *type = [link substringWithRange:[result rangeAtIndex:1]];
		if (![type isEqualToString:@"next"]) continue;
        
		return [NSURL URLWithString:URLString];
	}
    
	return nil;
}
@end
