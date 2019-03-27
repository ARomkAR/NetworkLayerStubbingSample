//
//  ViewController.m
//  NetworkLayerStubbingSample
//
//  Created by Omkar khedekar on 27/03/19.
//  Copyright © 2019 Omkar khedekar. All rights reserved.
//

#import "ViewController.h"
#import "GoogleService.h"
#import "GITHubService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GoogleService *google = [[GoogleService alloc] init];
    google.url = [NSURL URLWithString:@"https://google.com/"];
    [google executeWithCompletionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
        NSLog(@"%@", data);
        NSLog(@"%@", error);
    }];


    GITHubService *gitHub = [[GITHubService alloc] init];
    gitHub.url = [NSURL URLWithString:@"https://github.com/"];
    [gitHub executeWithCompletionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
        NSLog(@"%@", data);
        NSLog(@"%@", error);
    }];
}


@end
