/* Home Screen Quick Actions - Control Home Screen Quick Actions on iOS/iPadOS
 * Copyright (C) 2020 Tomasz Poliszuk
 *
 * Home Screen Quick Actions is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3 of the License.
 *
 * Home Screen Quick Actions is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Home Screen Quick Actions. If not, see <https://www.gnu.org/licenses/>.
 */


#include "Headers.h"

@implementation HomeScreenQuickActionsApplicationSpecificQuickActions

- (NSString *)title {
	return @"Select app";
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		// TODO: complete this list.
		NSArray *internalApps = [NSArray arrayWithContentsOfFile:@"/Library/PreferenceBundles/HomeScreenQuickActionsSettings.bundle/InternalApps.plist"];
		_specifiers = [NSMutableArray new];
		NSMutableArray *_specifiersInstalledSystemGroup = [NSMutableArray new];
		NSMutableArray *_specifiersInstalledSystemApps = [NSMutableArray new];
		NSMutableArray *_specifiersInstalledUserGroup = [NSMutableArray new];
		NSMutableArray *_specifiersInstalledUserApps = [NSMutableArray new];

		// ugly, but much simpler way of getting the default icon
		UIImage *defaultIcon = [UIImage _applicationIconImageForBundleIdentifier:@"com.apple.DemoApp" format:0 scale:[UIScreen mainScreen].scale];
		for (LSApplicationProxy *applicationProxy in [[NSClassFromString(@"LSApplicationWorkspace") defaultWorkspace] allApplications]) {
			if ([internalApps containsObject:applicationProxy.applicationIdentifier]) continue;
			NSString *title = applicationProxy.localizedName;
			if ( [applicationProxy.applicationIdentifier isEqualToString:@"com.apple.CarPlaySettings"] ) {
				title = [title stringByAppendingString:@" - CarPlay"];
			}
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:title target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
			[specifier setProperty:defaultIcon forKey:@"iconImage"];
			[specifier setProperty:applicationProxy.applicationIdentifier forKey:@"appBundleID"];
			[specifier setProperty:NSClassFromString(@"PSSubtitleSwitchTableCell") forKey:@"cellClass"];
			[specifier setProperty:applicationProxy.applicationIdentifier forKey:@"cellSubtitleText"];
			[specifier setProperty:@"com.tomaszpoliszuk.homescreenquickactions" forKey:@"defaults"];
			[specifier setProperty:@"1" forKey:@"default"];
			[specifier setProperty:@"com.tomaszpoliszuk.homescreenquickactions.settingschanged" forKey:@"PostNotification"];
			[specifier setProperty:[NSString stringWithFormat:@"appSpecificQuickActions-%@", applicationProxy.applicationIdentifier] forKey:@"key"];

			bool isInstalled = applicationProxy.isInstalled;
			bool isSystemApp = [applicationProxy.applicationType isEqualToString:@"System"];

			if ( isInstalled && isSystemApp ) {
				[_specifiersInstalledSystemApps addObject:specifier];
			} else if ( isInstalled && !isSystemApp ) {
				[_specifiersInstalledUserApps addObject:specifier];
			} else {
				continue;
			}
		}

		if ( _specifiersInstalledSystemApps.count > 0 ) {
			[_specifiersInstalledSystemGroup addObject:[PSSpecifier groupSpecifierWithName:@"System Apps"]];
			[_specifiersInstalledSystemApps sortUsingComparator:^NSComparisonResult(PSSpecifier *a, PSSpecifier *b) {
				return [a.name localizedCaseInsensitiveCompare:b.name];
			}];
			[_specifiersInstalledSystemGroup addObjectsFromArray:_specifiersInstalledSystemApps];
			self.specifiersInstalledSystemGroup = [_specifiersInstalledSystemGroup mutableCopy];
			[_specifiers addObjectsFromArray:_specifiersInstalledSystemGroup];
		}
		if ( _specifiersInstalledUserApps.count > 0 ) {
			[_specifiersInstalledUserGroup addObject:[PSSpecifier groupSpecifierWithName:@"User Apps"]];
			[_specifiersInstalledUserApps sortUsingComparator:^NSComparisonResult(PSSpecifier *a, PSSpecifier *b) {
				return [a.name localizedCaseInsensitiveCompare:b.name];
			}];
			[_specifiersInstalledUserGroup addObjectsFromArray:_specifiersInstalledUserApps];
			self.specifiersInstalledUserGroup = [_specifiersInstalledUserGroup mutableCopy];
			[_specifiers addObjectsFromArray:_specifiersInstalledUserGroup];
		}

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			for (PSSpecifier *specifier in _specifiers) {
				[specifier setProperty:[UIImage _applicationIconImageForBundleIdentifier:[specifier propertyForKey:@"appBundleID"] format:0 scale:[UIScreen mainScreen].scale] forKey:@"iconImage"];
				dispatch_async(dispatch_get_main_queue(), ^{
					[[specifier propertyForKey:@"cellObject"] refreshCellContentsWithSpecifier:specifier];
				});
			}
		});
		self.originalSpecifiers = [_specifiers mutableCopy];
	}
	return _specifiers;
}
@end
