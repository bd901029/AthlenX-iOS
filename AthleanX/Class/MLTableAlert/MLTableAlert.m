//
//  MLTableAlert.m
//
//  Version 1.3
//
//  Created by Matteo Del Vecchio on 11/12/12.
//  Updated on 03/07/2013.
//
//  Copyright (c) 2012 Matthew Labs. All rights reserved.
//  For the complete copyright notice, read Source Code License.
//

#import <QuartzCore/QuartzCore.h>

#import "MLTableAlert.h"


#define kTableAlertWidth     284.0
#define kLateralInset         12.0
#define kVerticalInset         8.0
#define kMinAlertHeight      220.0
#define kCancelButtonHeight   44.0
#define kCancelButtonMargin    5.0
#define kTitleLabelMargin     12.0


// Since orientation is managed by view controllers,
// MLTableAlertController is used under the MLTableAlert
// to provide support for orientation and rotation
@interface MLTableAlertController : UIViewController
@end

@implementation MLTableAlertController

// Orientation support
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return YES;
	else
		return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	MLTableAlert *ta = [self.view.subviews lastObject];
	if (ta != nil && [ta isKindOfClass:[MLTableAlert class]])
	{
		// Rotate the MLTableAlert if orientation changes
		// when it is visible on screen
		[UIView animateWithDuration:duration animations:^{
			[ta sizeToFit];
			
			CGFloat x = CGRectGetMidX(self.view.bounds);
			CGFloat y = CGRectGetMidY(self.view.bounds);
			ta.center = CGPointMake(x, y);
			ta.frame = CGRectIntegral(ta.frame);
		}];
	}
	else
		return;
}

@end


@interface MLTableAlert ()
@property (nonatomic, strong) UIView *alertBg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIWindow *appWindow;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cancelButtonTitle;

@property (nonatomic) BOOL cellSelected;

@property (nonatomic, strong) MLTableAlertNumberOfRowsBlock numberOfRows;
@property (nonatomic, strong) MLTableAlertTableCellsBlock cells;

-(void)createBackgroundView;	// Draws and manages the view behind the alert
-(void)animateIn;	 // Animates the alert when it has to be shown
-(void)animateOut;	 // Animates the alert when it has to be dismissed
-(void)dismissTableAlert;	// Dismisses the alert
@end



@implementation MLTableAlert

@synthesize aryTableCells;
@synthesize delegate;

#pragma mark - MLTableAlert Class Method
+ (MLTableAlert *) instanceWithTitle:(NSString *)title tableCells:(NSArray *)tableCells
{
	return [[[MLTableAlert alloc] initWithTitle:title
									 tableCells:tableCells] autorelease];
}

+(MLTableAlert *)tableAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle numberOfRows:(MLTableAlertNumberOfRowsBlock)rowsBlock andCells:(MLTableAlertTableCellsBlock)cellsBlock
{
	return [[MLTableAlert alloc] initWithTitle:title
					 cancelButtonTitle:cancelBtnTitle
						  numberOfRows:rowsBlock
							  andCells:cellsBlock];
}

#pragma mark - MLTableAlert Initialization

-(id)initWithTitle:(NSString *)title tableCells:(NSArray *)tableCells
{
	if ( self = [super init] )
	{
		_title = title;
		_cancelButtonTitle = @"Cancel";
		self.aryTableCells = tableCells;
		_height = kMinAlertHeight;	// Defining default (and minimum) alert height
	}
	
	return self;
}

-(id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle numberOfRows:(MLTableAlertNumberOfRowsBlock)rowsBlock andCells:(MLTableAlertTableCellsBlock)cellsBlock
{
	// Throw exception if rowsBlock or cellsBlock is nil
	if (rowsBlock == nil || cellsBlock == nil)
	{
		[[NSException exceptionWithName:@"rowsBlock and cellsBlock Error" reason:@"These blocks MUST NOT be nil" userInfo:nil] raise];
		return nil;
	}
	
	self = [super init];
	if (self)
	{
		_numberOfRows = rowsBlock;
		_cells = cellsBlock;
		_title = title;
		_cancelButtonTitle = cancelButtonTitle;
		_height = kMinAlertHeight;	// Defining default (and minimum) alert height
	}
	
	return self;
}

#pragma mark - Actions

-(void)configureSelectionBlock:(MLTableAlertRowSelectionBlock)selBlock andCompletionBlock:(MLTableAlertCompletionBlock)comBlock
{
	self.selectionBlock = selBlock;
	self.completionBlock = comBlock;
}

-(void)createBackgroundView
{
	// reset cellSelected value
	self.cellSelected = NO;
	
	// Allocating controller for presenting MLTableAlert
	MLTableAlertController *controller = [[MLTableAlertController alloc] init];
	controller.view.backgroundColor = [UIColor clearColor];
	
	// Creating new UIWindow to manage MLTableAlert and MLTableAlertController
	self.appWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.appWindow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
	self.appWindow.rootViewController = controller;
	self.appWindow.alpha = 0.0;
	self.appWindow.windowLevel = UIWindowLevelStatusBar;
	self.appWindow.hidden = NO;
	[self.appWindow makeKeyAndVisible];
	
	// Adding MLTableAlert as subview of MLTableAlertController (controller)
	[controller.view addSubview:self];
	
	// setting options to MLTableAlert
	self.frame = self.superview.bounds;
	self.opaque = NO;
	
	// get background color darker
	[UIView animateWithDuration:0.2 animations:^{
		self.appWindow.alpha = 1.0;
	}];
}

-(void)animateIn
{
	// UIAlertView-like pop in animation
	self.alertBg.transform = CGAffineTransformMakeScale(0.6, 0.6);
	[UIView animateWithDuration:0.2 animations:^{
		self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
	} completion:^(BOOL finished){
		[UIView animateWithDuration:1.0/15.0 animations:^{
			self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
		} completion:^(BOOL finished){
			[UIView animateWithDuration:1.0/7.5 animations:^{
				self.alertBg.transform = CGAffineTransformIdentity;
			}];
		}];
	}];
}

-(void)animateOut
{
	[UIView animateWithDuration:1.0/7.5 animations:^{
		self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:1.0/15.0 animations:^{
			self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.3 animations:^{
				self.alertBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
				self.appWindow.alpha = 0.3;
			} completion:^(BOOL finished){
				// table alert not shown anymore
				[self removeFromSuperview];
				self.appWindow.hidden = YES;
				[self.appWindow resignKeyWindow];
			}];
		}];
	}];
}

-(void)show
{
	[self createBackgroundView];
	
	// alert view creation
	self.alertBg = [[UIView alloc] initWithFrame:CGRectZero];
	[self addSubview:self.alertBg];
	
	// setting alert background image
	UIImageView *alertBgImage = nil;
	if ( IS_IOS7 )
	{
		[self.alertBg setBackgroundColor:[UIColor colorWithRed:(221.f/255.f) green:(221.f/255.f) blue:(221.f/255.f) alpha:1]];
		[self.alertBg.layer setCornerRadius:5];
	}
	else
	{
		alertBgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MLTableAlertBackground.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:30]];
		[self.alertBg addSubview:alertBgImage];
	}
	
	// alert title creation
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	self.titleLabel.backgroundColor = [UIColor clearColor];
	self.titleLabel.textColor = IS_IOS7 ? [UIColor blackColor] : [UIColor whiteColor];
	self.titleLabel.shadowColor = IS_IOS7 ? [UIColor clearColor] : [[UIColor blackColor] colorWithAlphaComponent:0.75];
	self.titleLabel.shadowOffset = CGSizeMake(0, -1);
	self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
	self.titleLabel.frame = CGRectMake(kLateralInset, 15, kTableAlertWidth - kLateralInset * 2, 22);
	self.titleLabel.text = self.title;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	[self.alertBg addSubview:self.titleLabel];
	
	// table view creation
	self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	self.tableView.frame = CGRectMake(kLateralInset, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + kTitleLabelMargin, kTableAlertWidth - kLateralInset * 2, (self.height - kVerticalInset * 2) - self.titleLabel.frame.origin.y - self.titleLabel.frame.size.height - kTitleLabelMargin - (kCancelButtonMargin + kCancelButtonHeight)*(self.cancelButtonTitle ? 1 : 0));
	
#if 1
	CGRect frame = self.tableView.frame;
	frame.size.height -= 20;
	self.tableView.frame = frame;
#endif
	
	self.tableView.layer.cornerRadius = 6.0;
	self.tableView.layer.masksToBounds = YES;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.backgroundView = [[UIView alloc] init];
	[self.alertBg addSubview:self.tableView];
	
	// setting white-to-gray gradient as table view's background
	CAGradientLayer *tableGradient = [CAGradientLayer layer];
	tableGradient.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
	tableGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0] CGColor], nil];
	[self.tableView.backgroundView.layer insertSublayer:tableGradient atIndex:0];
	
	// adding inner shadow mask on table view
	UIImageView *maskShadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MLTableAlertShadowMask.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:7]];
	maskShadow.userInteractionEnabled = NO;
	maskShadow.layer.masksToBounds = YES;
	maskShadow.layer.cornerRadius = 5.0;
	maskShadow.frame = self.tableView.frame;
	[self.alertBg addSubview:maskShadow];
	
	// cancel button creation
	if (self.cancelButtonTitle)
	{
		self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.cancelButton.frame = CGRectMake(kLateralInset, self.tableView.frame.origin.y + self.tableView.frame.size.height + kCancelButtonMargin, kTableAlertWidth - kLateralInset * 2, kCancelButtonHeight);
		
		CGRect cancelButtonFrame = self.cancelButton.frame;
		cancelButtonFrame.size.width /= 2.0f;
		cancelButtonFrame.origin.x += cancelButtonFrame.size.width;
		[self.cancelButton setFrame:cancelButtonFrame];
		
		self.cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
		self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
		self.cancelButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
		self.cancelButton.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
		[self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
		[self.cancelButton setTitleColor:IS_IOS7 ? [UIColor colorWithRed:0 green:(122.f/255.f) blue:1 alpha:1] : [UIColor whiteColor] forState:UIControlStateNormal];
		[self.cancelButton setBackgroundColor:[UIColor clearColor]];
		[self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
		[self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButtonPressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
		self.cancelButton.opaque = NO;
		self.cancelButton.layer.cornerRadius = 5.0;
		[self.cancelButton addTarget:self action:@selector(dismissTableAlert) forControlEvents:UIControlEventTouchUpInside];
		[self.alertBg addSubview:self.cancelButton];
	}
	
#if 1
	self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.okButton.frame = CGRectMake(kLateralInset, self.tableView.frame.origin.y + self.tableView.frame.size.height + kCancelButtonMargin, kTableAlertWidth - kLateralInset * 2, kCancelButtonHeight);
	
	CGRect okButtonFrame = self.okButton.frame;
	okButtonFrame.size.width = okButtonFrame.size.width / 2.0f;
	[self.okButton setFrame:okButtonFrame];
	
	self.okButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.okButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
	self.okButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
	self.okButton.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
	[self.okButton setTitle:@"OK" forState:UIControlStateNormal];
	[self.okButton setTitleColor:IS_IOS7 ? [UIColor colorWithRed:0 green:(122.f/255.f) blue:1 alpha:1] : [UIColor whiteColor] forState:UIControlStateNormal];
	[self.okButton setBackgroundColor:[UIColor clearColor]];
	[self.okButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
	[self.okButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButtonPressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
	self.okButton.opaque = NO;
	self.okButton.layer.cornerRadius = 5.0;
	[self.okButton addTarget:self action:@selector(okBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.alertBg addSubview:self.okButton];
#endif
	
	// setting alert and alert background image frames
	self.alertBg.frame = CGRectMake((self.frame.size.width - kTableAlertWidth) / 2, (self.frame.size.height - self.height) / 2, kTableAlertWidth, self.height - kVerticalInset * 2);
	if ( !IS_IOS7 )
		alertBgImage.frame = CGRectMake(0.0, 0.0, kTableAlertWidth, self.height);
	
	// the alert will be the first responder so any other controls,
	// like the keyboard, will be dismissed before the alert
	[self becomeFirstResponder];
	
	// show the alert with animation
	[self animateIn];
}

- (void) okBtnClicked
{
	[self animateOut];
	
	[self.delegate mlTableAlertViewSelected:self];
}

-(void)dismissTableAlert
{
	// dismiss the alert with its animation
	[self animateOut];
	
	// perform actions contained in completionBlock if the
	// cancel button of the alert has been pressed
	// if completionBlock == nil, nothing is performed
//	if (self.completionBlock != nil)
//		if (!self.cellSelected)
//			self.completionBlock();
	
	[self.delegate mlTableAlertViewCancelled:self];
}

// Allows the alert to be first responder
-(BOOL)canBecomeFirstResponder
{
	return YES;
}

// Alert height setter
-(void)setHeight:(CGFloat)height
{
	if (height > kMinAlertHeight)
		_height = height;
	else
		_height = kMinAlertHeight;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// TODO: Allow multiple sections
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// according to the numberOfRows block code
//	return self.numberOfRows(section);
	return self.aryTableCells.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// according to the cells block code
//	return self.cells(self, indexPath);
	return self.aryTableCells[indexPath.row];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if ( ![cell.textLabel.text isEqualToString:@"No Equipment"] )
	{
		if (cell.accessoryType == UITableViewCellAccessoryNone)
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		else
			[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
