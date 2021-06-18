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

@implementation HomeScreenQuickActionsRenameSettings
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Rename" target:self];
		if (iOSversion.majorVersion == 13) {
			removeSpecifiers = [[NSMutableArray alloc]init];
			for(PSSpecifier* specifier in _specifiers) {
				NSString* key = [specifier propertyForKey:@"key"];
				if(
					[key hasPrefix:@"widgetQuickActionGroup"]
					||
					[key hasPrefix:@"widgetQuickActionEditHomeScreen"]
					||
					[key hasPrefix:@"widgetQuickActionRemove"]
					||
					[key hasPrefix:@"widgetQuickActionConfigure"]
					||
					[key hasPrefix:@"widgetStackQuickActionConfigure"]
					||
					[key hasPrefix:@"visibleinAppLibrary"]
					||
					[key hasPrefix:@"appQuickActionAddToHomeScreen"]
					||
					[key hasPrefix:@"folderQuickActionRemove"]
				) {
					[removeSpecifiers addObject:specifier];
				}
			}
			[_specifiers removeObjectsInArray:removeSpecifiers];
		}
	}
	return _specifiers;
}
@end
