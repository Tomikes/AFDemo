//
//  ViewController.m
//  AFDemo
//
//  Created by mike on 8/1/16.
//  Copyright © 2016 mike. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "ONOXMLDocument.h"

@interface ViewController ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSString *baseurl;
@property (nonatomic, strong) ONOXMLDocument *document;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    NSError *error = nil;
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"demo" ofType:@"html"];
    
    self.document = [ONOXMLDocument HTMLDocumentWithData:[NSData dataWithContentsOfFile:filePath] error:&error];
  
    
// 获取所有<div cell>
    [self.document.rootElement enumerateElementsWithCSS:@"div.cell" usingBlock:^(ONOXMLElement *el, NSUInteger idx, BOOL *stop){
        //获取每一个cell里面属性为 <span item_title>
    
        NSLog(@"%@",el);
        [el enumerateElementsWithCSS:@"span.item_title" usingBlock:^(ONOXMLElement *ela, NSUInteger idx, BOOL *stop){
//
            //获取a标签
            [ela enumerateElementsWithCSS:@"a" usingBlock:^(ONOXMLElement *elas, NSUInteger idx, BOOL *stop){
                //
                NSLog(@"%@",elas.attributes);
                NSLog(@"%@",elas.stringValue);
            }];

        }];
        
        
        //获取img 24*24
        [el enumerateElementsWithCSS:@"a/img" usingBlock:^(ONOXMLElement *elah, NSUInteger idx, BOOL *stop){
            NSLog(@"%@",elah.attributes[@"src"]);
        }];
        
      
    }];
    
    

    

    
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
    
    self.manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    self.manager.requestSerializer.timeoutInterval = 15;
}




@end
