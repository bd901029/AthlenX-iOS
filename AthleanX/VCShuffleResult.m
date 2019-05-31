//
//  VCShuffleResult.m
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCShuffleResult.h"
#import "MealPlanManager.h"


@implementation VCShuffleResult

+ (VCShuffleResult *) instanceWithName:(NSString *)name
{
	return [[[VCShuffleResult alloc] initWithName:name] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:NIB_NAME(@"VCShuffleResult") bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (id)initWithName:(NSString *)name
{
	self = [super initWithNibName:NIB_NAME(@"VCShuffleResult") bundle:nil];
	if ( self )
	{
		eatNamed = name;
	}
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	MealPlanManager *mp = [[MealPlanManager alloc] init];
	int rand = arc4random() % [mp getDaysCount];
	int randSn = arc4random() % 3;
	
	rand++;
	randSn++;
	
	if ([eatNamed isEqual:@"BREAKFAST"])
	{
		[titleName setText:@"SHUFFLE BREAKFAST"];
		[redTitle setText:@"BREAKFAST"];
		animArr = [[NSMutableArray alloc] initWithArray:[mp getBreakfastList]];
	}  
	if ([eatNamed isEqual:@"LUNCH"])
	{
		[titleName setText:@"SHUFFLE LUNCH"];
		[redTitle setText:@"LUNCH"];
		animArr = [[NSMutableArray alloc] initWithArray:[mp getLunchList]];
	} 
	if ([eatNamed isEqual:@"DINNER"])
	{
		[titleName setText:@"SHUFFLE DINNER"];
		[redTitle setText:@"DINNER"];
		animArr = [[NSMutableArray alloc] initWithArray:[mp getDinnerList]];
	} 
	if ([eatNamed isEqual:@"SNACK"])
	{
		[titleName setText:@"SHUFFLE SNACK"];
		[redTitle setText:@"SNACK"];
		animArr = [[NSMutableArray alloc] initWithArray:[mp getSnackList:randSn]];
		for (int i = 0; i < [animArr count]; i++)
		{
			if (randSn == 1)
			{
				if ([[[animArr objectAtIndex:i] objectForKey:@"Snack1"] length] == 0)
				{
					[animArr removeObjectAtIndex:i];
				}
			}
			if (randSn == 2)
			{
				if ([[[animArr objectAtIndex:i] objectForKey:@"Snack2"] length] == 0)
				{
					[animArr removeObjectAtIndex:i];
				}
			}
			if (randSn == 3)
			{
				if ([[[animArr objectAtIndex:i] objectForKey:@"Snack3"] length] == 0)
				{
					[animArr removeObjectAtIndex:i];
				}
			}
		}
	}
	
	NSMutableArray *aryTemp = [NSMutableArray arrayWithArray:animArr];
	for (id item in aryTemp)
	{
		NSString *content = [item allValues].lastObject;
		if ( content == nil || [content isKindOfClass:[NSNull class]] )
		{
			[animArr removeObject:item];
			NSLog(@"removed");
		}
		else
		{
			content = [content stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
			if ( content.length <= 0 )
			{
				[animArr removeObject:item];
				NSLog(@"removed");
			}
		}
	}
	
	[mp release];
	
	[m_tableView reloadData];
}


- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
//	int rand = arc4random() % [animArr count];
//	NSIndexPath *indp = [NSIndexPath  indexPathForRow:rand inSection:0];
//	[m_tableView selectRowAtIndexPath:indp animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (IBAction) back
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) reload {
	
	int rand = arc4random() % [animArr count];
	int randSn = arc4random() % 3;
	
	rand++;
	randSn++;

	NSIndexPath *indp = [NSIndexPath  indexPathForRow:rand-1 inSection:0];
	[m_tableView selectRowAtIndexPath:indp animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (NSString *)stripDoubleSpaceFrom:(NSString *)str
{
	while ([str rangeOfString:@"  "].location != NSNotFound)
	{
		str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
	}
	
	return str;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [animArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"] autorelease];
	}
	
	cell.textLabel.numberOfLines = 10;
	[cell.textLabel setTextColor:[UIColor whiteColor]];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundColor = [UIColor clearColor];
	

	NSString *str1 = [NSString stringWithFormat:@"<style type=\"text/css\"> p.p1 {margin: 0.0px 0.0px 0.0px 0.0px;  font: 18.0px Helvetica; color:#fff} p.p2 {margin: 0.0px 0.0px 0.0px 0.0px;  font: 12.0px Helvetica; min-height: 14.0px; color:#fff} p.p3 {margin: 0.0px 0.0px 0.0px 0.0px; font: 18.0px Helvetica} p.p4 {margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Helvetica; min-height: 14.0px}p.p5 {margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Helvetica; color: #ff1f17} p.p6 {margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Helvetica; color:#fff} p.p7 {margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Helvetica; color: #ff1f17; min-height: 14.0px} p.p8 {margin: 0.0px 0.0px 0.0px 0.0px; font: 17.0px Helvetica} p.p9 {margin: 0.0px 0.0px 0.0px 0.0px; font: 18.0px Helvetica; min-height: 22.0px} span.s1 {text-decoration: underline} span.s2 {font: 11.0px 'Times New Roman'; text-decoration: underline} p.eatPeriod { display:inline; color: red; font-size: 15px; font: 15.0px Helvetica; font-weight: bold; text-decoration: none;} body {color:weight;} </style> <body>	%@ </body>",
					  [animArr[indexPath.row] allValues].lastObject];
	
	NSString *htmlString = [[[[[[[[[[[str1 stringByReplacingOccurrencesOfString:@"‚Äô" withString:@"'"]
									 stringByReplacingOccurrencesOfString:@"%" withString:@"%"]
									stringByReplacingOccurrencesOfString:@"¬Ω" withString:@"0,5"]
								   stringByReplacingOccurrencesOfString:@"Breakfast" withString:@""]
								  stringByReplacingOccurrencesOfString:@"Lunch" withString:@""]
								 stringByReplacingOccurrencesOfString:@"Dinner" withString:@""]
								stringByReplacingOccurrencesOfString:@"Snack #1" withString:@""]
							   stringByReplacingOccurrencesOfString:@"Snack #2" withString:@""]
							  stringByReplacingOccurrencesOfString:@"Snack #3" withString:@""]
							 stringByReplacingOccurrencesOfString:@"Snack#2" withString:@""]
							stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
//	htmlString = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content= user-scalable=\"no\", width=\"device-width\"/><meta http-equiv=\"Content-Type\" content=\"text/html\"; charset=\"UTF-8\"/><link rel=\"stylesheet\" type=\"text/css\" href=\"mystyle.css\" /><script type=\"text/javascript\" src=\"myjavascript.js\"></script></head>%@</html>", htmlString];
//	NSLog(@"html = %@", htmlString);
	
	UIWebView *cellView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)] autorelease];
	[cellView setBackgroundColor:[UIColor clearColor]];
	[cellView setOpaque:NO];
	[cellView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:DOCUMENT_PATH]];
	cell.backgroundView = cellView;
//	NSString *reformedPanda = [@"Panda&#39;s Expenses" stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	return cell;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
