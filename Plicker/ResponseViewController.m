//
//  ResponseViewController.m
//  Plicker
//
//  Created by Justin Lee on 1/9/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

#import "ResponseViewController.h"

@interface ResponseViewController ()

@property (nonatomic,retain) UILabel * headerLabel;
@property (nonatomic,retain) UIImageView * bannerImageView;
@property (nonatomic,retain) UILabel * questionLabel;

@end

@implementation ResponseViewController

@synthesize headerLabel;
@synthesize bannerImageView;
@synthesize questionLabel;

- (void)backButtonNormal:(UIButton *)sender {
	
}

- (void)backTouchDown:(UIButton *) sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"%@", self.responses);
	if ([[self.responses objectForKey:@"question"] objectForKey:@"image"] == nil) {
		[bannerImageView setFrame:CGRectMake(bannerImageView.frame.origin.x, bannerImageView.frame.origin.y, 0, 0)];
		[questionLabel setFrame:CGRectMake(15, bannerImageView.frame.origin.y + bannerImageView.frame.size.height, questionLabel.frame.size.width, questionLabel.frame.size.height)];

	}
	else{
		[bannerImageView setFrame:CGRectMake(bannerImageView.frame.origin.x, bannerImageView.frame.origin.y, self.view.frame.size.width, 230)];
		[questionLabel setFrame:CGRectMake(15, bannerImageView.frame.origin.y + bannerImageView.frame.size.height, questionLabel.frame.size.width, questionLabel.frame.size.height)];
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dispatch_async(queue, ^ {
			NSString *path =[[self.responses objectForKey:@"question"] objectForKey:@"image"];
			NSURL *url = [NSURL URLWithString:path];
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *img = [[UIImage alloc] initWithData:data];
			
			dispatch_async(dispatch_get_main_queue(), ^ {
				[bannerImageView setImage:img];
			});
		});
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor whiteColor];
	
	UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
	
	headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, headerView.frame.size.width, 30)];
	[headerLabel setText:@"Responses"];
	[headerLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[headerLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
	[headerLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0]];
	headerLabel.textAlignment = NSTextAlignmentCenter;
	
	UIView * headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y + headerView.frame.size.height, self.view.frame.size.width, 1)];
	headerLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.2/255.0 alpha:1.0];
	
	UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState :UIControlStateNormal];
	backButton.tintColor = [UIColor colorWithRed:108.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0];
	backButton.frame = CGRectMake(15, 35, 30, 30);
	[backButton addTarget:self action:@selector(backTouchDown:) forControlEvents:UIControlEventTouchDown];
	[backButton addTarget:self action:@selector(backButtonNormal:) forControlEvents:UIControlEventTouchUpInside];
	
	[headerView addSubview:headerLabel];
	[headerView addSubview:backButton];
	[headerView addSubview:headerLine];
	
	bannerImageView = [[UIImageView alloc] init];//WithImage:img];
	[bannerImageView setFrame:CGRectMake(0, headerView.frame.size.height + headerView.frame.origin.y, self.view.frame.size.width, 230)];
	bannerImageView.contentMode = UIViewContentModeScaleToFill;
	bannerImageView.clipsToBounds = YES;
	
	
	NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
	style.minimumLineHeight = 20.f;
	style.maximumLineHeight = 20.f;
	style.alignment = NSTextAlignmentCenter;
	
	NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:12], NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightMedium]};
	
	NSString * body = [[self.responses objectForKey:@"question"] objectForKey:@"body"];
	
	CGFloat maxWidth = (self.view.frame.size.width - (15 * 2));
	CGRect rect = [body boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributtes context:nil];
	
	CGSize size = rect.size;
	CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
	
	
	questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, bannerImageView.frame.origin.y + bannerImageView.frame.size.height, maxWidth, adjustedSize.height)];
	questionLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0];
	questionLabel.numberOfLines = 0;
	questionLabel.attributedText = [[NSAttributedString alloc] initWithString:body attributes:attributtes];
//	questionLabel.attributedText = [[NSAttributedString alloc] init];
	
	[self.view addSubview:headerView];
	[self.view addSubview:bannerImageView];
	[self.view addSubview:questionLabel];
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