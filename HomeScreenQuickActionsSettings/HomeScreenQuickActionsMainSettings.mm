//#import <Preferences/PSViewController.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface HomeScreenQuickActionsTableCell : PSTableCell
@end

@interface PSControlTableCell : PSTableCell
- (UIControl *)control;
@end

@interface PSSwitchTableCell : PSControlTableCell
@end

@interface HomeScreenQuickActionsSwitchTableCell : PSSwitchTableCell
@end

@interface PSListController (HomeScreenQuickActions)
-(BOOL)containsSpecifier:(id)arg1;
@end

@interface HomeScreenQuickActionsMainSettings : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@end

@implementation HomeScreenQuickActionsTableCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)identifier specifier:(id)specifier {
	return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier];
}
- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
	[super refreshCellContentsWithSpecifier:specifier];
	NSString *sublabel = [specifier propertyForKey:@"sublabel"];
	if (sublabel) {
		self.detailTextLabel.text = [sublabel description];
		self.detailTextLabel.textColor = [UIColor grayColor];
	}
}
@end

@implementation HomeScreenQuickActionsSwitchTableCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)identifier specifier:(id)specifier {
	return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier];
}
- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
	[super refreshCellContentsWithSpecifier:specifier];
	NSString *sublabel = [specifier propertyForKey:@"sublabel"];
	if (sublabel) {
		self.detailTextLabel.text = [sublabel description];
		self.detailTextLabel.textColor = [UIColor grayColor];
	}
}
@end

@implementation HomeScreenQuickActionsMainSettings
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

-(void)TweakSourceCode {
	NSURL *tweakSourceCode = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/HomeScreenQuickActions"];
	[[UIApplication sharedApplication] openURL:tweakSourceCode options:@{} completionHandler:nil];
}

-(void)TweakReportIssue {
	NSURL *tweakReportIssue = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/HomeScreenQuickActions/issues/new"];
	[[UIApplication sharedApplication] openURL:tweakReportIssue options:@{} completionHandler:nil];
}

-(void)TomaszPoliszukOnGithub {
	NSURL *tomaszPoliszukOnGithub = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/"];
	[[UIApplication sharedApplication] openURL:tomaszPoliszukOnGithub options:@{} completionHandler:nil];
}

@end
