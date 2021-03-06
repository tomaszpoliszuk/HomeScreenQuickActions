#include "Headers.h"

@implementation HomeScreenQuickActionsSearchableListController

- (void)viewDidLoad {
	[super viewDidLoad];
	UISearchController *searchController = [UISearchController new];
	searchController.searchResultsUpdater = self;
	searchController.hidesNavigationBarDuringPresentation = NO;
	searchController.searchBar.delegate = self;
	searchController.obscuresBackgroundDuringPresentation = NO;
	self.navigationItem.searchController = searchController;
}

- (void)updateSearchResultsWithText:(NSString *)text {
	if (text.length == 0) {
		self.specifiers = self.originalSpecifiers;
		return;
	}
	NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(PSSpecifier *specifier, NSDictionary *bindings) {
		if ( specifier.cellType != PSGroupCell ) {
			NSString *appName = specifier.name;
			NSString *appID = [specifier.properties objectForKey:@"cellSubtitleText"];
			return ( ( [appName.lowercaseString rangeOfString:text.lowercaseString].location != NSNotFound ) || ( [appID.lowercaseString rangeOfString:text.lowercaseString].location != NSNotFound ) );
		}
		return YES;
	}];
	NSMutableArray *_specifiersFiltered = [NSMutableArray new];
	[_specifiersFiltered addObjectsFromArray:self.specifiersInstalledSystemGroup];
	[_specifiersFiltered addObjectsFromArray:self.specifiersInstalledUserGroup];
	self.specifiers = [[_specifiersFiltered filteredArrayUsingPredicate:predicate] mutableCopy];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)controller {
	[self updateSearchResultsWithText:controller.searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text {
	[self updateSearchResultsWithText:text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	self.specifiers = self.originalSpecifiers;
}

@end
