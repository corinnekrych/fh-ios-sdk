//
//  FHRemote.m
//  fh-ios-sdk
//
//  Created by Craig Brookes on 26/01/2012.
//  Copyright (c) 2012 Feedhenry. All rights reserved.
//

#import "FHRemote.h"
#import "FHAct.h"
#import "FH.h"
#import "NSString+Validation.h"
@implementation FHRemote
@synthesize url, remoteAction;

- (id)init{
    self = [super init];
    if(self){
        _location = FH_LOCATION_REMOTE;
        NSString * path = [[NSBundle mainBundle] pathForResource:@"fhconfig" ofType:@"plist"];
        appProperties   = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return self;
}

- (void)buildURL{
    //use parents properties to build url
    
    NSMutableString * tempString = [[NSMutableString alloc] init];
    NSString * domain   = [appProperties objectForKey:@"domain"];
    NSString * guid     = [appProperties objectForKey:@"guid"];
    NSString * instid   = [appProperties objectForKey:@"appinstid"];
    NSString * api      = [appProperties objectForKey:@"apiurl"];
    
    guid = ([guid validateGuid] == true)?guid:@"";
    
    NSLog(@"the remote action is %@",remoteAction);
    
    
    NSString * turl = nil; 
    if([self.method isEqualToString:@"act"]){
       turl = [tempString stringByAppendingFormat:@"%@%@/%@/%@/%@/%@",api,self.method,domain,guid,self.remoteAction,instid];
    }else if([self.method isEqualToString:@"auth"]){
        
        turl = [tempString stringByAppendingFormat:@"%@arm/user/auth",api];
    }

    NSURL * uri = [[NSURL alloc]initWithString:turl];
    NSLog(@"built uri = %@",turl);
    self.url = uri;

    [tempString release];
    [uri release];
}

- (void)dealloc{
    url = nil;
    [url release];
    remoteAction = nil;
    [remoteAction release];
    [super dealloc];
}

@end
