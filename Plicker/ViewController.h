//
//  ViewController.h
//  Plicker
//
//  Created by Justin Lee on 1/8/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseViewController.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ResponseViewController *responseViewController;

@end
