/* Home Screen Quick Actions - Control Home Screen Quick Actions on iOS/iPadOS
 * Copyright (C) 2020 Tomasz Poliszuk
 *
 * Home Screen Quick Actions is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Home Screen Quick Actions is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Home Screen Quick Actions. If not, see <https://www.gnu.org/licenses/>.
 */


#include <Preferences/PSListController.h>
#include <Preferences/PSSpecifier.h>
#import "../HomeScreenQuickActions.h"

@interface HomeScreenQuickActionsSearchableListController : PSListController <UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, retain) NSMutableArray *originalSpecifiers;
@property (nonatomic, retain) NSMutableArray *specifiersInstalledSystemGroup;
@property (nonatomic, retain) NSMutableArray *specifiersInstalledUserGroup;
@end

@interface HomeScreenQuickActionsApplicationSpecificQuickActions : HomeScreenQuickActionsSearchableListController
@end

@interface HomeScreenQuickActionsRootSettings : PSListController {
	NSMutableArray *removeSpecifiers;
}
@end

@interface HomeScreenQuickActionsRenameSettings : PSListController {
	NSMutableArray *removeSpecifiers;
}
@end

