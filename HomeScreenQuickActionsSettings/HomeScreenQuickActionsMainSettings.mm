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

-(void)sourceCode {
	NSURL *sourceCode = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/HomeScreenQuickActions"];
	[[UIApplication sharedApplication] openURL:sourceCode options:@{} completionHandler:nil];
}

-(void)reportIssueAtGithub {
	NSURL *reportIssueAtGithub = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/HomeScreenQuickActions/issues/new"];
	[[UIApplication sharedApplication] openURL:reportIssueAtGithub options:@{} completionHandler:nil];
}

-(void)TomaszPoliszukAtGithub {
	UIApplication *application = [UIApplication sharedApplication];
	NSString *username = @"tomaszpoliszuk";
	NSURL *githubWebsite = [NSURL URLWithString:[@"https://github.com/" stringByAppendingString:username]];
	[application openURL:githubWebsite options:@{} completionHandler:nil];
}

-(void)TomaszPoliszukAtTwitter {
	UIApplication *application = [UIApplication sharedApplication];
	NSString *username = @"tomaszpoliszuk";
	NSURL *twitterWebsite = [NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:username]];
	[application openURL:twitterWebsite options:@{} completionHandler:nil];
}

@end
