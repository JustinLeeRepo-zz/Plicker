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
@property (nonatomic,retain) UIView * responsesView;
@property (nonatomic,retain) NSMutableDictionary * answerFreq;

@end

@implementation ResponseViewController

@synthesize headerLabel;
@synthesize bannerImageView;
@synthesize questionLabel;
@synthesize responsesView;
@synthesize answerFreq;

- (void)calculateFreq:(NSArray *)arr {
	for (NSDictionary * dict in arr) {
		NSString *choice = [dict objectForKey:@"answer"];
		int prevCount = [[answerFreq objectForKey:choice] intValue];
		[answerFreq setValue:[NSString stringWithFormat:@"%d", [[answerFreq objectForKey:choice] intValue] + 1] forKey:choice];
	}
}

- (void)backButtonNormal:(UIButton *)sender {
	
}

- (void)backTouchDown:(UIButton *) sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[self calculateFreq:[self.responses objectForKey:@"responses"]];
	
	NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
	style.minimumLineHeight = 20.f;
	style.maximumLineHeight = 20.f;
	style.alignment = NSTextAlignmentCenter;
	
	NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:12], NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightMedium]};
	
	NSString * body = [[self.responses objectForKey:@"question"] objectForKey:@"body"];
	if ([body isEqualToString:@""]) {
		body = @"No question body provided.";
	}
	CGFloat maxWidth = (self.view.frame.size.width - (15 * 2));
	CGRect rect = [body boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributtes context:nil];
	
	CGSize size = rect.size;
	CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
	
	questionLabel.attributedText = [[NSAttributedString alloc] initWithString:body attributes:attributtes];
	
	if ([[self.responses objectForKey:@"question"] objectForKey:@"image"] == nil) {
		[bannerImageView setFrame:CGRectMake(bannerImageView.frame.origin.x, bannerImageView.frame.origin.y, 0, 0)];
		[questionLabel setFrame:CGRectMake(15, bannerImageView.frame.origin.y + bannerImageView.frame.size.height, maxWidth, adjustedSize.height)];
		[responsesView setFrame:CGRectMake(0, questionLabel.frame.origin.y + questionLabel.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (questionLabel.frame.origin.y + questionLabel.frame.size.height))];

	}
	else{
		[bannerImageView setFrame:CGRectMake(bannerImageView.frame.origin.x, bannerImageView.frame.origin.y, self.view.frame.size.width, 230)];
		[questionLabel setFrame:CGRectMake(15, bannerImageView.frame.origin.y + bannerImageView.frame.size.height, maxWidth, adjustedSize.height)];
		[responsesView setFrame:CGRectMake(0, questionLabel.frame.origin.y + questionLabel.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (questionLabel.frame.origin.y + questionLabel.frame.size.height))];
		
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
	
	NSArray * arr = [[self.responses objectForKey:@"question"] objectForKey:@"choices"];
	int bound = [arr count];
	if (bound == 0){
		bound = 4;
	}
	int choiceSize = responsesView.frame.size.width / bound;
	
	
	for (int i = 0; i < bound; i++) {
		UIView * view = [[UIView alloc] initWithFrame:CGRectMake(i * choiceSize, 0, choiceSize, responsesView.frame.size.height)];
		
		NSString *choice;
		switch (i) {
			case 0:
				choice = @"A";
				break;
				
			case 1:
				choice = @"B";
				break;
				
			case 2:
				choice = @"C";
				break;
				
			case 3:
				choice = @"D";
				break;
				
			default:
				break;
		}
		
		UILabel * choiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, choiceSize, 50)];
		choiceLabel.textColor = [UIColor colorWithRed:108.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0];
		choiceLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
		choiceLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
		choiceLabel.textAlignment = NSTextAlignmentCenter;
		choiceLabel.numberOfLines = 0;
		
		if([arr count] == 0){
			choiceLabel.text = choice;
		}
		else{
			choiceLabel.text = [[arr objectAtIndex:i] objectForKey:@"body"];
			if ([[[arr objectAtIndex:i] objectForKey:@"correct"] intValue] == 1) {
				choiceLabel.textColor = [UIColor greenColor];
				CALayer* layer = [choiceLabel layer];
				CALayer *bottomBorder = [CALayer layer];
				bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
				bottomBorder.borderWidth = 3;
				bottomBorder.frame = CGRectMake(5, layer.frame.size.height - 3, layer.frame.size.width-10, 3);
				[bottomBorder setBorderColor:[UIColor greenColor].CGColor];
				[bottomBorder setName:@"border"];
				[layer addSublayer:bottomBorder];

			}
		}
		
		UILabel * freqLabel = [[UILabel alloc] initWithFrame:CGRectMake(choiceLabel.frame.origin.x, choiceLabel.frame.origin.y + choiceLabel.frame.size.height, choiceLabel.frame.size.width, 50)];
		freqLabel.textColor = [UIColor colorWithRed:108.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0];
		freqLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
		freqLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
		freqLabel.textAlignment = NSTextAlignmentCenter;
		freqLabel.numberOfLines = 2;
		freqLabel.text = [NSString stringWithFormat:@"%lu%%\n%d out of %lu", [[answerFreq objectForKey:choice] intValue] * 100 / [[self.responses objectForKey:@"responses"] count], [[answerFreq objectForKey:choice] intValue], [[self.responses objectForKey:@"responses"] count]];
		
		
		
		[view addSubview:choiceLabel];
		[view addSubview:freqLabel];
//		view.backgroundColor = [UIColor colorWithRed:50 * i / 255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
		
		[responsesView addSubview:view];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor whiteColor];
	answerFreq = [[NSMutableDictionary alloc] init];

	[answerFreq setValue:[NSNumber numberWithInt:0] forKey:@"A"];
	[answerFreq setValue:[NSNumber numberWithInt:0] forKey:@"B"];
	[answerFreq setValue:[NSNumber numberWithInt:0] forKey:@"C"];
	[answerFreq setValue:[NSNumber numberWithInt:0] forKey:@"D"];
	
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
	
//	
//	NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
//	style.minimumLineHeight = 20.f;
//	style.maximumLineHeight = 20.f;
//	style.alignment = NSTextAlignmentCenter;
//	
//	NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:12], NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightMedium]};
//	
//	NSString * body = [[self.responses objectForKey:@"question"] objectForKey:@"body"];
//	
//	CGFloat maxWidth = (self.view.frame.size.width - (15 * 2));
//	CGRect rect = [body boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributtes context:nil];
//	
//	CGSize size = rect.size;
//	CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
	
	
	questionLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(15, bannerImageView.frame.origin.y + bannerImageView.frame.size.height, maxWidth, adjustedSize.height)];
	questionLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0];
	questionLabel.numberOfLines = 0;
//	questionLabel.attributedText = [[NSAttributedString alloc] initWithString:body attributes:attributtes];
	
	responsesView = [[UIView alloc] initWithFrame:CGRectMake(0, questionLabel.frame.origin.y + questionLabel.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (questionLabel.frame.origin.y + questionLabel.frame.size.height))];
	
	[self.view addSubview:bannerImageView];
	[self.view addSubview:questionLabel];
	[self.view addSubview:responsesView];
	[self.view addSubview:headerView];
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