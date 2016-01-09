//
//  ViewController.m
//  Plicker
//
//  Created by Justin Lee on 1/8/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

#import "ViewController.h"
#import "NetworkAccess.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	NSString *url = @"http://plickers-interview.herokuapp.com/polls";
	
	[NetworkAccess accessServer:url success:^(NSURLSessionTask *task, NSArray * responseObject) {
		NSLog(@"Yo %@", responseObject);
	}failure:^(NSURLSessionTask *operation, NSError *error){
		NSLog(@"%@", error);
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
