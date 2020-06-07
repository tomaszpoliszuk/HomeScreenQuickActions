//#import <Preferences/PSViewController.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface PSControlTableCell : PSTableCell
- (UIControl *)control;
@end

@interface PSSwitchTableCell : PSControlTableCell
@end

@interface PSListController (HomeScreenQuickActions)
-(BOOL)containsSpecifier:(id)arg1;
@end

@interface HomeScreenQuickActionsMainSettings : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
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
