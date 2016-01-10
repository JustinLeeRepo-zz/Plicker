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

@property (nonatomic,retain) UITableView * tableView;
@property (nonatomic,retain) UILabel * headerLabel;
@property (nonatomic,retain) NSMutableArray* dataArray;

@end

@implementation ViewController
@synthesize headerLabel;
@synthesize dataArray;

- (void)initTableView
{
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80) style:UITableViewStylePlain];
//	self.view.backgroundColor = [UIColor colorWithRed:181.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0];
	self.tableView.dataSource =self;
	self.tableView.delegate = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self.view addSubview:self.tableView];
	[self.view sendSubviewToBack:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.responseViewController = [[ResponseViewController alloc] init];
	self.responseViewController.responses = [dataArray objectAtIndex:[indexPath row]];
	[self presentViewController:self.responseViewController animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	static NSString *CellIdentifier = @"ListingIdentifier";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.textLabel.numberOfLines = 0;
		
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
		cell.textLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
		cell.textLabel.textColor = [UIColor colorWithRed:108.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0];
		
	}
	if ([[[[dataArray objectAtIndex:row] objectForKey:@"question"] objectForKey:@"body"]  isEqual: @""]) {
		cell.textLabel.text = @"No question body provided.";
	}
	else{
		cell.textLabel.text = [[[dataArray objectAtIndex:row] objectForKey:@"question"] objectForKey:@"body"];
	}
	return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor whiteColor];
	
	UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
	
	headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, headerView.frame.size.width, 30)];
	[headerLabel setText:@"Questions"];
	[headerLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[headerLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
	[headerLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0]];
	headerLabel.textAlignment = NSTextAlignmentCenter;

	UIView * headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y + headerView.frame.size.height, self.view.frame.size.width, 1)];
	headerLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.2/255.0 alpha:1.0];
	
	[headerView addSubview:headerLabel];
	[headerView addSubview:headerLine];

	NSString *url = @"http://plickers-interview.herokuapp.com/polls";

	[NetworkAccess accessServer:url success:^(NSURLSessionTask *task, NSArray * responseObject) {
//		NSLog(@"%@", [responseObject objectAtIndex:0]);
		dataArray = responseObject;
		[self.tableView reloadData];
	}failure:^(NSURLSessionTask *operation, NSError *error){
		[dataArray removeAllObjects];
		[self.tableView reloadData];
	}];
	
	
	[self initTableView];
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
