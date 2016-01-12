//
//  ResponseViewController.h
//  Plicker
//
//  Created by Justin Lee on 1/9/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"

@interface ResponseViewController : UIViewController

@property (nonatomic, strong) DetailsViewController *detailsViewController;
@property (strong,nonatomic) NSDictionary *responses;

@end