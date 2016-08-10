//
//  AppDelegate.m
//  AFDemo
//
//  Created by mike on 8/1/16.
//  Copyright © 2016 mike. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking.h>

#import "HTMLParser.h"
#import "HTMLNode.h"

@interface AppDelegate ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSString *baseurl;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//
//    self.baseurl = @"https://www.v2ex.com";
//
//    [self.manager GET:@"/go/python?p=5" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
//        
// NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",htmlString);
//
//        NSError *error = nil;
//      
//        HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
//        if (error) {
//            NSLog(@"Error: %@", error);
//            return;
//        }
//
//        HTMLNode *bodyNode = [parser body];
//        NSArray *spanNodes = [bodyNode findChildTags:@"div"];
//        
//        for (HTMLNode *spanNode in spanNodes) {
//            if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"content"]) {
//                NSArray *cells = [spanNode findChildTags:@"div"];
//                //寻找每一个cell
//                for (HTMLNode *cell in cells) {
//                    if ([[cell getAttributeNamed:@"class"] isEqualToString:@"cell"]) {
//                        
//                        HTMLNode *sd = [cell findChildTag:@"span"];
//                        
//                        if ([[sd getAttributeNamed:@"class"] isEqualToString:@"item_title"]) {
//                           
//                            
//                            NSLog(@"%@",[sd rawContents]);
//                        }
////                        NSLog(@"%@",[cell rawContents]);
//                    }
//                }
//                
//            }
//        }
//        
//    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
//        NSLog(@"e:%@",error);
//    }];
    
    return YES;
}

- (void)setBaseurl:(NSString *)baseurl{
    _baseurl =baseurl;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                      diskCapacity:50 * 1024 * 1024
                                                          diskPath:nil];
    [config setURLCache:cache];
    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: baseurl] sessionConfiguration:config];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
//    responseSerializer.removesKeysWithNullValues = YES;//json
    
    self.manager.responseSerializer = responseSerializer;
    //only html
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //
    [self.manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//      [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//NSURLRequestUseProtocolCachePolicy
    self.manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
     self.manager.requestSerializer.timeoutInterval = 15;
}

@end
