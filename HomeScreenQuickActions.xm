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


#import <dlfcn.h>
#include "HomeScreenQuickActions.h"

#define kIconController [%c(SBIconController) sharedInstance]
#define kIconManager [kIconController iconManager]
#define kFloatingDockController [kIconController floatingDockController]
#define kDismissFloatingDockIfPresented [kFloatingDockController _dismissFloatingDockIfPresentedAnimated:YES completionHandler:nil]
#define kPresentFloatingDockIfDismissed [kFloatingDockController _presentFloatingDockIfDismissedAnimated:YES completionHandler:nil]

NSMutableDictionary *tweakSettings;

static bool enableTweak;

static int uiStyle;

static bool showSeparators;

static bool reverseQuickActionsOrder;


//	Installed Applications (Native)
static bool appQuickActionDelete;
static NSString *appQuickActionDeleteTitle = @"";
static NSString *appQuickActionDeleteSubtitle = @"";

static bool appQuickActionEditHomeScreen;
static NSString *appQuickActionEditHomeScreenTitle = @"";
static NSString *appQuickActionEditHomeScreenSubtitle = @"";

static bool appQuickActionShare;
static NSString *appQuickActionShareTitle = @"";
static NSString *appQuickActionShareSubtitle = @"";

static bool appQuickActionShowAllWindows;
static NSString *appQuickActionShowAllWindowsTitle = @"";
static NSString *appQuickActionShowAllWindowsSubtitle = @"";

//	Installed Applications (Custom)
static bool appCustomQuickActionShareBundleID; // (Beta)
static NSString *appCustomQuickActionShareBundleIDTitle = @"";
static NSString *appCustomQuickActionShareBundleIDSubtitle = @"";

static bool appCustomQuickActionCopyBundleID;
static NSString *appCustomQuickActionCopyBundleIDTitle = @"";
static NSString *appCustomQuickActionCopyBundleIDSubtitle = @"";

static bool appCustomQuickActionOpenAppInFilza;
static NSString *appCustomQuickActionOpenAppInFilzaTitle = @"";
static NSString *appCustomQuickActionOpenAppInFilzaSubtitle = @"";

static bool appCustomQuickActionClearBadge;
static NSString *appCustomQuickActionClearBadgeTitle = @"";
static NSString *appCustomQuickActionClearBadgeSubtitle = @"";

static bool appCustomQuickActionClearCache;
static NSString *appCustomQuickActionClearCacheTitle = @"";
static NSString *appCustomQuickActionClearCacheSubtitle = @"";

static bool appCustomQuickActionReset;
static NSString *appCustomQuickActionResetTitle = @"";
static NSString *appCustomQuickActionResetSubtitle = @"";

static bool appCustomQuickActionOffload;
static NSString *appCustomQuickActionOffloadTitle = @"";
static NSString *appCustomQuickActionOffloadSubtitle = @"";

//	Offloaded Applications (Native)
static bool offloadedAppQuickActionEditHomeScreen;
static NSString *offloadedAppQuickActionEditHomeScreenTitle = @"";
static NSString *offloadedAppQuickActionEditHomeScreenSubtitle = @"";

//	Offloaded Applications (Custom)
static bool offloadedAppCustomQuickActionShareBundleID; // (Beta)
static NSString *offloadedAppCustomQuickActionShareBundleIDTitle = @"";
static NSString *offloadedAppCustomQuickActionShareBundleIDSubtitle = @"";

static bool offloadedAppCustomQuickActionCopyBundleID;
static NSString *offloadedAppCustomQuickActionCopyBundleIDTitle = @"";
static NSString *offloadedAppCustomQuickActionCopyBundleIDSubtitle = @"";

static bool offloadedAppCustomQuickActionOpenAppInFilza;
static NSString *offloadedAppCustomQuickActionOpenAppInFilzaTitle = @"";
static NSString *offloadedAppCustomQuickActionOpenAppInFilzaSubtitle = @"";

//	Folders (Native)
static bool folderQuickActionRemove;	//	iOS14
static NSString *folderQuickActionRemoveTitle = @"";
static NSString *folderQuickActionRemoveSubtitle = @"";

static bool folderQuickActionEditHomeScreen;
static NSString *folderQuickActionEditHomeScreenTitle = @"";
static NSString *folderQuickActionEditHomeScreenSubtitle = @"";

static bool folderQuickActionRename;
static NSString *folderQuickActionRenameTitle = @"";
static NSString *folderQuickActionRenameSubtitle = @"";

static bool folderQuickActionUnreadNotifications;

//	Folders (Custom)
static bool folderCustomQuickActionShareBundleID; // (Beta)
static NSString *folderCustomQuickActionShareBundleIDTitle = @"";
static NSString *folderCustomQuickActionShareBundleIDSubtitle = @"";

static bool folderCustomQuickActionCopyBundleID;
static NSString *folderCustomQuickActionCopyBundleIDTitle = @"";
static NSString *folderCustomQuickActionCopyBundleIDSubtitle = @"";

static bool folderCustomQuickActionClearBadge;
static NSString *folderCustomQuickActionClearBadgeTitle = @"";
static NSString *folderCustomQuickActionClearBadgeSubtitle = @"";

static bool folderCustomQuickActionClearCache; // (Beta)
static NSString *folderCustomQuickActionClearCacheTitle = @"";
static NSString *folderCustomQuickActionClearCacheSubtitle = @"";

static bool folderCustomQuickActionReset; // (Beta)
static NSString *folderCustomQuickActionResetTitle = @"";
static NSString *folderCustomQuickActionResetSubtitle = @"";

static bool folderCustomQuickActionOffload;
static NSString *folderCustomQuickActionOffloadTitle = @"";
static NSString *folderCustomQuickActionOffloadSubtitle = @"";

static bool folderCustomQuickActionAppList; // (Beta)
static int folderCustomQuickActionAppListMax;

//	Widgets (Native)
static bool widgetQuickActionRemove;	//	iOS14
static NSString *widgetQuickActionRemoveTitle = @"";
static NSString *widgetQuickActionRemoveSubtitle = @"";

static bool widgetQuickActionEditHomeScreen;	//	iOS14
static NSString *widgetQuickActionEditHomeScreenTitle = @"";
static NSString *widgetQuickActionEditHomeScreenSubtitle = @"";

static bool widgetQuickActionConfigure;	//	iOS14
static NSString *widgetQuickActionConfigureTitle = @"";
static NSString *widgetQuickActionConfigureSubtitle = @"";

static bool widgetStackQuickActionConfigure;	//	iOS14
static NSString *widgetStackQuickActionConfigureTitle = @"";
static NSString *widgetStackQuickActionConfigureSubtitle = @"";

static bool widgetsInQuickActions;	//	iOS13

//	Bookmarks (Native)
static bool bookmarkQuickActionDelete;
static NSString *bookmarkQuickActionDeleteTitle = @"";
static NSString *bookmarkQuickActionDeleteSubtitle = @"";

static bool bookmarkQuickActionShare;
static NSString *bookmarkQuickActionShareTitle = @"";
static NSString *bookmarkQuickActionShareSubtitle = @"";

static bool bookmarkQuickActionEditHomeScreen;
static NSString *bookmarkQuickActionEditHomeScreenTitle = @"";
static NSString *bookmarkQuickActionEditHomeScreenSubtitle = @"";

//	Visible in App Library (Native)
static bool appQuickActionAddToHomeScreen;	//	iOS14
static NSString *appQuickActionAddToHomeScreenTitle = @"";
static NSString *appQuickActionAddToHomeScreenSubtitle = @"";

//	Visible during downloading app (Native)
static bool appQuickActionPrioritizeDownload;
static NSString *appQuickActionPrioritizeDownloadTitle = @"";
static NSString *appQuickActionPrioritizeDownloadSubtitle = @"";

static bool appQuickActionPauseDownload;
static NSString *appQuickActionPauseDownloadTitle = @"";
static NSString *appQuickActionPauseDownloadSubtitle = @"";

static bool appQuickActionCancelDownload;
static NSString *appQuickActionCancelDownloadTitle = @"";
static NSString *appQuickActionCancelDownloadSubtitle = @"";

//	visible in iPad Dock recents/suggestions (Native)
static bool appQuickActionHide;
static NSString *appQuickActionHideTitle = @"";
static NSString *appQuickActionHideSubtitle = @"";

void SettingsChanged() {
	CFArrayRef keyList = CFPreferencesCopyKeyList(
		CFSTR(packageName),
		kCFPreferencesCurrentUser,
		kCFPreferencesAnyHost
	);
	if(keyList) {
		tweakSettings = (
			NSMutableDictionary *)CFBridgingRelease(
			CFPreferencesCopyMultiple(
				keyList,
				CFSTR(packageName),
				kCFPreferencesCurrentUser,
				kCFPreferencesAnyHost
			)
		);
		CFRelease(keyList);
	} else {
		tweakSettings = nil;
	}
	if (!tweakSettings) {
		tweakSettings = [NSMutableDictionary dictionaryWithContentsOfFile:userSettingsFile];
	}

	enableTweak = [([tweakSettings objectForKey:@"enableTweak"] ?: @(YES)) boolValue];

	uiStyle = [([tweakSettings valueForKey:@"uiStyle"] ?: @(999)) integerValue];

	showSeparators = [([tweakSettings objectForKey:@"showSeparators"] ?: @(YES)) boolValue];

	reverseQuickActionsOrder = [([tweakSettings objectForKey:@"reverseQuickActionsOrder"] ?: @(NO)) boolValue];


//	Installed Applications (Native)
	appQuickActionDelete = [([tweakSettings objectForKey:@"appQuickActionDelete"] ?: @(YES)) boolValue];
	appQuickActionDeleteTitle = [tweakSettings objectForKey:@"appQuickActionDeleteTitle"];
	appQuickActionDeleteSubtitle = [tweakSettings objectForKey:@"appQuickActionDeleteSubtitle"];

	appQuickActionEditHomeScreen = [([tweakSettings objectForKey:@"appQuickActionEditHomeScreen"] ?: @(YES)) boolValue];
	appQuickActionEditHomeScreenTitle = [tweakSettings objectForKey:@"appQuickActionEditHomeScreenTitle"];
	appQuickActionEditHomeScreenSubtitle = [tweakSettings objectForKey:@"appQuickActionEditHomeScreenSubtitle"];

	appQuickActionShare = [([tweakSettings objectForKey:@"appQuickActionShare"] ?: @(YES)) boolValue];
	appQuickActionShareTitle = [tweakSettings objectForKey:@"appQuickActionShareTitle"];
	appQuickActionShareSubtitle = [tweakSettings objectForKey:@"appQuickActionShareSubtitle"];

	appQuickActionShowAllWindows = [([tweakSettings objectForKey:@"appQuickActionShowAllWindows"] ?: @(YES)) boolValue];
	appQuickActionShowAllWindowsTitle = [tweakSettings objectForKey:@"appQuickActionShowAllWindowsTitle"];
	appQuickActionShowAllWindowsSubtitle = [tweakSettings objectForKey:@"appQuickActionShowAllWindowsSubtitle"];

//	Installed Applications (Custom)
	appCustomQuickActionShareBundleID = [([tweakSettings objectForKey:@"appCustomQuickActionShareBundleID"] ?: @(NO)) boolValue]; // (Beta)
	appCustomQuickActionShareBundleIDTitle = [tweakSettings objectForKey:@"appCustomQuickActionShareBundleIDTitle"];
	appCustomQuickActionShareBundleIDSubtitle = [tweakSettings objectForKey:@"appCustomQuickActionShareBundleIDSubtitle"];

	appCustomQuickActionCopyBundleID = [([tweakSettings objectForKey:@"appCustomQuickActionCopyBundleID"] ?: @(NO)) boolValue];
	appCustomQuickActionCopyBundleIDTitle = [tweakSettings objectForKey:@"appCustomQuickActionCopyBundleIDTitle"];
	appCustomQuickActionCopyBundleIDSubtitle = [tweakSettings objectForKey:@"appCustomQuickActionCopyBundleIDSubtitle"];

	appCustomQuickActionOpenAppInFilza = [([tweakSettings objectForKey:@"appCustomQuickActionOpenAppInFilza"] ?: @(NO)) boolValue];
	appCustomQuickActionOpenAppInFilzaTitle = [tweakSettings objectForKey:@"appCustomQuickActionOpenAppInFilzaTitle"];
	appCustomQuickActionOpenAppInFilzaSubtitle = [tweakSettings objectForKey:@"appCustomQuickActionOpenAppInFilzaSubtitle"];

	appCustomQuickActionClearBadge = [([tweakSettings objectForKey:@"appCustomQuickActionClearBadge"] ?: @(NO)) boolValue];
	appCustomQuickActionClearBadgeTitle = [tweakSettings objectForKey:@"appCustomQuickActionClearBadgeTitle"];
	appCustomQuickActionClearBadgeSubtitle = [tweakSettings objectForKey:@"appCustomQuickActionClearBadgeSubtitle"];

	appCustomQuickActionClearCache = [([tweakSettings objectForKey:@"appCustomQuickActionClearCache"] ?: @(NO)) boolValue];
	appCustomQuickActionClearCacheTitle = [tweakSettings objectForKey:@"appCustomQuickActionClearCacheTitle"];
	appCustomQuickActionClearCacheSubtitle = [tweakSettings objectForKey:@"appCustomQuickActionClearCacheSubtitle"];

	appCustomQuickActionReset = [([tweakSettings objectForKey:@"appCustomQuickActionReset"] ?: @(NO)) boolValue];
	appCustomQuickActionResetTitle = [tweakSettings objectForKey:@"appCustomQuickActionResetTitle"];
	appCustomQuickActionResetSubtitle = [tweakSettings objectForKey:@"appCustomQuickActionResetSubtitle"];

	appCustomQuickActionOffload = [([tweakSettings objectForKey:@"appCustomQuickActionOffload"] ?: @(NO)) boolValue];
	appCustomQuickActionOffloadTitle = [tweakSettings objectForKey:@"appCustomQuickActionOffloadTitle"];
	appCustomQuickActionOffloadSubtitle = [tweakSettings objectForKey:@"appCustomQuickActionOffloadSubtitle"];

//	Offloaded Applications (Native)
	offloadedAppQuickActionEditHomeScreen = [([tweakSettings objectForKey:@"offloadedAppQuickActionEditHomeScreen"] ?: @(YES)) boolValue]; // (Beta)
	offloadedAppQuickActionEditHomeScreenTitle = [tweakSettings objectForKey:@"offloadedAppQuickActionEditHomeScreenTitle"];
	offloadedAppQuickActionEditHomeScreenSubtitle = [tweakSettings objectForKey:@"offloadedAppQuickActionEditHomeScreenSubtitle"];

//	Offloaded Applications (Custom)
	offloadedAppCustomQuickActionShareBundleID = [([tweakSettings objectForKey:@"offloadedAppCustomQuickActionShareBundleID"] ?: @(NO)) boolValue];
	offloadedAppCustomQuickActionShareBundleIDTitle = [tweakSettings objectForKey:@"offloadedAppCustomQuickActionShareBundleIDTitle"];
	offloadedAppCustomQuickActionShareBundleIDSubtitle = [tweakSettings objectForKey:@"offloadedAppCustomQuickActionShareBundleIDSubtitle"];

	offloadedAppCustomQuickActionCopyBundleID = [([tweakSettings objectForKey:@"offloadedAppCustomQuickActionCopyBundleID"] ?: @(NO)) boolValue];
	offloadedAppCustomQuickActionCopyBundleIDTitle = [tweakSettings objectForKey:@"offloadedAppCustomQuickActionCopyBundleIDTitle"];
	offloadedAppCustomQuickActionCopyBundleIDSubtitle = [tweakSettings objectForKey:@"offloadedAppCustomQuickActionCopyBundleIDSubtitle"];

	offloadedAppCustomQuickActionOpenAppInFilza = [([tweakSettings objectForKey:@"offloadedAppCustomQuickActionOpenAppInFilza"] ?: @(NO)) boolValue];
	offloadedAppCustomQuickActionOpenAppInFilzaTitle = [tweakSettings objectForKey:@"offloadedAppCustomQuickActionOpenAppInFilzaTitle"];
	offloadedAppCustomQuickActionOpenAppInFilzaSubtitle = [tweakSettings objectForKey:@"offloadedAppCustomQuickActionOpenAppInFilzaSubtitle"];

//	Folders (Native)
	folderQuickActionRemove = [([tweakSettings objectForKey:@"folderQuickActionRemove"] ?: @(YES)) boolValue];
	folderQuickActionRemoveTitle = [tweakSettings objectForKey:@"folderQuickActionRemoveTitle"];
	folderQuickActionRemoveSubtitle = [tweakSettings objectForKey:@"folderQuickActionRemoveSubtitle"];

	folderQuickActionEditHomeScreen = [([tweakSettings objectForKey:@"folderQuickActionEditHomeScreen"] ?: @(YES)) boolValue];
	folderQuickActionEditHomeScreenTitle = [tweakSettings objectForKey:@"folderQuickActionEditHomeScreenTitle"];
	folderQuickActionEditHomeScreenSubtitle = [tweakSettings objectForKey:@"folderQuickActionEditHomeScreenSubtitle"];

	folderQuickActionRename = [([tweakSettings objectForKey:@"folderQuickActionRename"] ?: @(YES)) boolValue];
	folderQuickActionRenameTitle = [tweakSettings objectForKey:@"folderQuickActionRenameTitle"];
	folderQuickActionRenameSubtitle = [tweakSettings objectForKey:@"folderQuickActionRenameSubtitle"];

	folderQuickActionUnreadNotifications = [([tweakSettings objectForKey:@"folderQuickActionUnreadNotifications"] ?: @(YES)) boolValue];

//	Folders (Custom)
	folderCustomQuickActionShareBundleID = [([tweakSettings objectForKey:@"folderCustomQuickActionShareBundleID"] ?: @(NO)) boolValue]; // (Beta)
	folderCustomQuickActionShareBundleIDTitle = [tweakSettings objectForKey:@"folderCustomQuickActionShareBundleIDTitle"];
	folderCustomQuickActionShareBundleIDSubtitle = [tweakSettings objectForKey:@"folderCustomQuickActionShareBundleIDSubtitle"];

	folderCustomQuickActionCopyBundleID = [([tweakSettings objectForKey:@"folderCustomQuickActionCopyBundleID"] ?: @(NO)) boolValue];
	folderCustomQuickActionCopyBundleIDTitle = [tweakSettings objectForKey:@"folderCustomQuickActionCopyBundleIDTitle"];
	folderCustomQuickActionCopyBundleIDSubtitle = [tweakSettings objectForKey:@"folderCustomQuickActionCopyBundleIDSubtitle"];

	folderCustomQuickActionClearBadge = [([tweakSettings objectForKey:@"folderCustomQuickActionClearBadge"] ?: @(NO)) boolValue];
	folderCustomQuickActionClearBadgeTitle = [tweakSettings objectForKey:@"folderCustomQuickActionClearBadgeTitle"];
	folderCustomQuickActionClearBadgeSubtitle = [tweakSettings objectForKey:@"folderCustomQuickActionClearBadgeSubtitle"];

	folderCustomQuickActionClearCache = [([tweakSettings objectForKey:@"folderCustomQuickActionClearCache"] ?: @(NO)) boolValue]; // (Beta)
	folderCustomQuickActionClearCacheTitle = [tweakSettings objectForKey:@"folderCustomQuickActionClearCacheTitle"];
	folderCustomQuickActionClearCacheSubtitle = [tweakSettings objectForKey:@"folderCustomQuickActionClearCacheSubtitle"];

	folderCustomQuickActionReset = [([tweakSettings objectForKey:@"folderCustomQuickActionReset"] ?: @(NO)) boolValue]; // (Beta)
	folderCustomQuickActionResetTitle = [tweakSettings objectForKey:@"folderCustomQuickActionResetTitle"];
	folderCustomQuickActionResetSubtitle = [tweakSettings objectForKey:@"folderCustomQuickActionResetSubtitle"];

	folderCustomQuickActionOffload = [([tweakSettings objectForKey:@"folderCustomQuickActionOffload"] ?: @(NO)) boolValue];
	folderCustomQuickActionOffloadTitle = [tweakSettings objectForKey:@"folderCustomQuickActionOffloadTitle"];
	folderCustomQuickActionOffloadSubtitle = [tweakSettings objectForKey:@"folderCustomQuickActionOffloadSubtitle"];

	folderCustomQuickActionAppList = [([tweakSettings objectForKey:@"folderCustomQuickActionAppList"] ?: @(NO)) boolValue]; // (Beta)
	folderCustomQuickActionAppListMax = [([tweakSettings valueForKey:@"folderCustomQuickActionAppListMax"] ?: @(6)) integerValue];

//	Widgets (Native)
	widgetQuickActionRemove = [([tweakSettings objectForKey:@"widgetQuickActionRemove"] ?: @(YES)) boolValue];
	widgetQuickActionRemoveTitle = [tweakSettings objectForKey:@"widgetQuickActionRemoveTitle"];
	widgetQuickActionRemoveSubtitle = [tweakSettings objectForKey:@"widgetQuickActionRemoveSubtitle"];

	widgetQuickActionEditHomeScreen = [([tweakSettings objectForKey:@"widgetQuickActionEditHomeScreen"] ?: @(YES)) boolValue];
	widgetQuickActionEditHomeScreenTitle = [tweakSettings objectForKey:@"widgetQuickActionEditHomeScreenTitle"];
	widgetQuickActionEditHomeScreenSubtitle = [tweakSettings objectForKey:@"widgetQuickActionEditHomeScreenSubtitle"];

	widgetQuickActionConfigure = [([tweakSettings objectForKey:@"widgetQuickActionConfigure"] ?: @(YES)) boolValue];
	widgetQuickActionConfigureTitle = [tweakSettings objectForKey:@"widgetQuickActionConfigureTitle"];
	widgetQuickActionConfigureSubtitle = [tweakSettings objectForKey:@"widgetQuickActionConfigureSubtitle"];

	widgetStackQuickActionConfigure = [([tweakSettings objectForKey:@"widgetStackQuickActionConfigure"] ?: @(YES)) boolValue];
	widgetStackQuickActionConfigureTitle = [tweakSettings objectForKey:@"widgetStackQuickActionConfigureTitle"];
	widgetStackQuickActionConfigureSubtitle = [tweakSettings objectForKey:@"widgetStackQuickActionConfigureSubtitle"];

	widgetsInQuickActions = [([tweakSettings objectForKey:@"widgetsInQuickActions"] ?: @(YES)) boolValue];

//	Bookmarks (Native)
	bookmarkQuickActionDelete = [([tweakSettings objectForKey:@"bookmarkQuickActionDelete"] ?: @(YES)) boolValue];
	bookmarkQuickActionDeleteTitle = [tweakSettings objectForKey:@"bookmarkQuickActionDeleteTitle"];
	bookmarkQuickActionDeleteSubtitle = [tweakSettings objectForKey:@"bookmarkQuickActionDeleteSubtitle"];

	bookmarkQuickActionShare = [([tweakSettings objectForKey:@"bookmarkQuickActionShare"] ?: @(NO)) boolValue];
	bookmarkQuickActionShareTitle = [tweakSettings objectForKey:@"bookmarkQuickActionShareTitle"];
	bookmarkQuickActionShareSubtitle = [tweakSettings objectForKey:@"bookmarkQuickActionShareSubtitle"];

	bookmarkQuickActionEditHomeScreen = [([tweakSettings objectForKey:@"bookmarkQuickActionEditHomeScreen"] ?: @(YES)) boolValue];
	bookmarkQuickActionEditHomeScreenTitle = [tweakSettings objectForKey:@"bookmarkQuickActionEditHomeScreenTitle"];
	bookmarkQuickActionEditHomeScreenSubtitle = [tweakSettings objectForKey:@"bookmarkQuickActionEditHomeScreenSubtitle"];

//	Visible in App Library (Native)
	appQuickActionAddToHomeScreen = [([tweakSettings objectForKey:@"appQuickActionAddToHomeScreen"] ?: @(YES)) boolValue];
	appQuickActionAddToHomeScreenTitle = [tweakSettings objectForKey:@"appQuickActionAddToHomeScreenTitle"];
	appQuickActionAddToHomeScreenSubtitle = [tweakSettings objectForKey:@"appQuickActionAddToHomeScreenSubtitle"];

//	Visible during downloading app (Native)
	appQuickActionPrioritizeDownload = [([tweakSettings objectForKey:@"appQuickActionPrioritizeDownload"] ?: @(YES)) boolValue];
	appQuickActionPrioritizeDownloadTitle = [tweakSettings objectForKey:@"appQuickActionPrioritizeDownloadTitle"];
	appQuickActionPrioritizeDownloadSubtitle = [tweakSettings objectForKey:@"appQuickActionPrioritizeDownloadSubtitle"];

	appQuickActionPauseDownload = [([tweakSettings objectForKey:@"appQuickActionPauseDownload"] ?: @(YES)) boolValue];
	appQuickActionPauseDownloadTitle = [tweakSettings objectForKey:@"appQuickActionPauseDownloadTitle"];
	appQuickActionPauseDownloadSubtitle = [tweakSettings objectForKey:@"appQuickActionPauseDownloadSubtitle"];

	appQuickActionCancelDownload = [([tweakSettings objectForKey:@"appQuickActionCancelDownload"] ?: @(YES)) boolValue];
	appQuickActionCancelDownloadTitle = [tweakSettings objectForKey:@"appQuickActionCancelDownloadTitle"];
	appQuickActionCancelDownloadSubtitle = [tweakSettings objectForKey:@"appQuickActionCancelDownloadSubtitle"];

//	visible in iPad Dock recents/suggestions (Native)
	appQuickActionHide = [([tweakSettings objectForKey:@"appQuickActionHide"] ?: @(YES)) boolValue];
	appQuickActionHideTitle = [tweakSettings objectForKey:@"appQuickActionHideTitle"];
	appQuickActionHideSubtitle = [tweakSettings objectForKey:@"appQuickActionHideSubtitle"];
}

static void receivedNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	SettingsChanged();
}

static void ShowMessage( NSString *title, NSString *message ) {
	UIWindow *currentAlertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	currentAlertWindow.windowLevel = UIWindowLevelAlert + 13;
	currentAlertWindow.rootViewController = [[UIViewController alloc] init];
	UIAlertController *currentAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
		currentAlertWindow.hidden = YES;
	}];
	[currentAlert addAction:cancel];
	[currentAlertWindow makeKeyAndVisible];
	[currentAlertWindow.rootViewController presentViewController:currentAlert animated:YES completion:nil];
}

static void ClearDirectoryURLContents(NSURL *url) {
//	this part is from https://github.com/rpetrich/CacheClearer/blob/216dd186aface6243ca94810bf9fbadc5f8c3066/Tweak.x#L25-L33
	NSFileManager *fm = [NSFileManager defaultManager];
	NSDirectoryEnumerator *enumerator = [fm enumeratorAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants errorHandler:nil];
	NSURL *child;
	while ((child = [enumerator nextObject])) {
		[fm removeItemAtURL:child error:NULL];
	}
}

%hook SBIconView
- (void)setApplicationShortcutItems:(NSArray *)arg1 {
	NSString* bundleId;
	if([self respondsToSelector:@selector(applicationBundleIdentifierForShortcuts)]) {
		bundleId = [self applicationBundleIdentifierForShortcuts];
	}
	NSString* applicationBundleID;
	if([[self icon] respondsToSelector:@selector(applicationBundleID)]) {
		applicationBundleID = [[self icon] applicationBundleID];
	}
	if ( enableTweak ) {
		NSMutableArray *shortcutItems = [[NSMutableArray alloc] init];
		LSApplicationProxy *applicationProxy = [%c(LSApplicationProxy) applicationProxyForIdentifier:applicationBundleID];
		bool isInstalled = applicationProxy.isInstalled;
		bool isDeletable = applicationProxy.isDeletable;
		bool haveBadge = [[self icon] badgeValue];
		for (SBSApplicationShortcutItem *shortcutItem in arg1) {
//	Apple uses both prefixes for system shortcuts:
//	- com.apple.springboardhome.application-shotcut-item - with typo "shotcut" name
//	- com.apple.springboardhome.application-shortcut-item - with correct "shortcut" name
//	- so let's detect both of them in one run:
			if ( [shortcutItem.type hasPrefix:@"com.apple.springboardhome.application-"] ) {
				if ( [shortcutItem.type hasSuffix:@"delete-app"] ) {
					if ( appQuickActionDelete && [[self icon] isApplicationIcon] && !([self displayedLabelAccessoryType] == 3) ) {
						if ( appQuickActionDeleteTitle.length > 0 ) {
							shortcutItem.localizedTitle = appQuickActionDeleteTitle;
						}
						if ( appQuickActionDeleteSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = appQuickActionDeleteSubtitle;
						}
						[shortcutItems addObject: shortcutItem];
						continue;
					}
					if ( bookmarkQuickActionDelete && [[self icon] isBookmarkIcon] ) {
						[shortcutItems addObject: shortcutItem];
						if ( bookmarkQuickActionDeleteTitle.length > 0 ) {
							shortcutItem.localizedTitle = bookmarkQuickActionDeleteTitle;
						}
						if ( bookmarkQuickActionDeleteSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = bookmarkQuickActionDeleteSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"rearrange-icons"] ) {
					if ( appQuickActionEditHomeScreen && [[self icon] isApplicationIcon] && !([self displayedLabelAccessoryType] == 3) ) {
						if ( appQuickActionEditHomeScreenTitle.length > 0 ) {
							shortcutItem.localizedTitle = appQuickActionEditHomeScreenTitle;
						}
						if ( appQuickActionEditHomeScreenSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = appQuickActionEditHomeScreenSubtitle;
						}
						[shortcutItems addObject: shortcutItem];
						continue;
					}
					if ( offloadedAppQuickActionEditHomeScreen && ([self displayedLabelAccessoryType] == 3) ) {
						[shortcutItems addObject: shortcutItem];
						if ( offloadedAppQuickActionEditHomeScreenTitle.length > 0 ) {
							shortcutItem.localizedTitle = offloadedAppQuickActionEditHomeScreenTitle;
						}
						if ( offloadedAppQuickActionEditHomeScreenSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = offloadedAppQuickActionEditHomeScreenSubtitle;
						}
					}
					if ( folderQuickActionEditHomeScreen && [self isFolderIcon] ) {
						[shortcutItems addObject: shortcutItem];
						if ( folderQuickActionEditHomeScreenTitle.length > 0 ) {
							shortcutItem.localizedTitle = folderQuickActionEditHomeScreenTitle;
						}
						if ( folderQuickActionEditHomeScreenSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = folderQuickActionEditHomeScreenSubtitle;
						}
					}
					if ( iOSversion.majorVersion > 13 ) {
						if ( widgetQuickActionEditHomeScreen && ( [[self icon] isWidgetIcon] || [[self icon] isWidgetStackIcon] ) ) {
							[shortcutItems addObject: shortcutItem];
							if ( widgetQuickActionEditHomeScreenTitle.length > 0 ) {
								shortcutItem.localizedTitle = widgetQuickActionEditHomeScreenTitle;
							}
							if ( widgetQuickActionEditHomeScreenSubtitle.length > 0 ) {
								shortcutItem.localizedSubtitle = widgetQuickActionEditHomeScreenSubtitle;
							}
						}
					}
					if ( bookmarkQuickActionEditHomeScreen && [[self icon] isBookmarkIcon] ) {
						[shortcutItems addObject: shortcutItem];
						if ( bookmarkQuickActionEditHomeScreenTitle.length > 0 ) {
							shortcutItem.localizedTitle = bookmarkQuickActionEditHomeScreenTitle;
						}
						if ( bookmarkQuickActionEditHomeScreenSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = bookmarkQuickActionEditHomeScreenSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"item.share"] ) {
					if ( appQuickActionShare && [[self icon] isApplicationIcon] && !([self displayedLabelAccessoryType] == 3) ) {
						if ( appQuickActionShareTitle.length > 0 ) {
							shortcutItem.localizedTitle = appQuickActionShareTitle;
						}
						if ( appQuickActionShareSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = appQuickActionShareSubtitle;
						}
						[shortcutItems addObject: shortcutItem];
						continue;
					}
					if ( bookmarkQuickActionShare && [[self icon] isBookmarkIcon] ) {
						[shortcutItems addObject: shortcutItem];
						if ( bookmarkQuickActionShareTitle.length > 0 ) {
							shortcutItem.localizedTitle = bookmarkQuickActionShareTitle;
						}
						if ( bookmarkQuickActionShareSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = bookmarkQuickActionShareSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"rename-folder"] ) {
					if ( folderQuickActionRename ) {
						[shortcutItems addObject: shortcutItem];
						if ( folderQuickActionRenameTitle.length > 0 ) {
							shortcutItem.localizedTitle = folderQuickActionRenameTitle;
						}
						if ( folderQuickActionRenameSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = folderQuickActionRenameSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"hide-folder"] ) {
					if ( folderQuickActionRemove ) {
						[shortcutItems addObject: shortcutItem];
						if ( folderQuickActionRemoveTitle.length > 0 ) {
							shortcutItem.localizedTitle = folderQuickActionRemoveTitle;
						}
						if ( folderQuickActionRemoveSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = folderQuickActionRemoveSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"unread-notifications"] ) {
					if ( folderQuickActionUnreadNotifications ) {
						[shortcutItems addObject: shortcutItem];
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"remove-app"] ) {
					if ( appQuickActionDelete && [[self icon] isApplicationIcon] && !([self displayedLabelAccessoryType] == 3) ) {
						if ( appQuickActionDeleteTitle.length > 0 ) {
							shortcutItem.localizedTitle = appQuickActionDeleteTitle;
						}
						if ( appQuickActionDeleteSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = appQuickActionDeleteSubtitle;
						}
						[shortcutItems addObject: shortcutItem];
						continue;
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"remove-widget"] ) {
					if ( widgetQuickActionRemove ) {
						[shortcutItems addObject: shortcutItem];
						if ( widgetQuickActionRemoveTitle.length > 0 ) {
							shortcutItem.localizedTitle = widgetQuickActionRemoveTitle;
						}
						if ( widgetQuickActionRemoveSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = widgetQuickActionRemoveSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"configure-widget"] ) {
					if ( widgetQuickActionConfigure ) {
						[shortcutItems addObject: shortcutItem];
						if ( widgetQuickActionConfigureTitle.length > 0 ) {
							shortcutItem.localizedTitle = widgetQuickActionConfigureTitle;
						}
						if ( widgetQuickActionConfigureSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = widgetQuickActionConfigureSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"configure-stack"] ) {
					if ( widgetStackQuickActionConfigure ) {
						[shortcutItems addObject: shortcutItem];
						if ( widgetStackQuickActionConfigureTitle.length > 0 ) {
							shortcutItem.localizedTitle = widgetStackQuickActionConfigureTitle;
						}
						if ( widgetStackQuickActionConfigureSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = widgetStackQuickActionConfigureSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"add-to-home-screen"] ) {
					if ( appQuickActionAddToHomeScreen ) {
						[shortcutItems addObject: shortcutItem];
						if ( appQuickActionAddToHomeScreenTitle.length > 0 ) {
							shortcutItem.localizedTitle = appQuickActionAddToHomeScreenTitle;
						}
						if ( appQuickActionAddToHomeScreenSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = appQuickActionAddToHomeScreenSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"prioritize-download"] ) {
					if ( appQuickActionPrioritizeDownload ) {
						[shortcutItems addObject: shortcutItem];
						if ( appQuickActionPrioritizeDownloadTitle.length > 0 ) {
							shortcutItem.localizedTitle = appQuickActionPrioritizeDownloadTitle;
						}
						if ( appQuickActionPrioritizeDownloadSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = appQuickActionPrioritizeDownloadSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"pause-download"] ) {
					if ( appQuickActionPauseDownload ) {
						[shortcutItems addObject: shortcutItem];
						if ( appQuickActionPauseDownloadTitle.length > 0 ) {
							shortcutItem.localizedTitle = appQuickActionPauseDownloadTitle;
						}
						if ( appQuickActionPauseDownloadSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = appQuickActionPauseDownloadSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"cancel-download"] ) {
					if ( appQuickActionCancelDownload ) {
						[shortcutItems addObject: shortcutItem];
						if ( appQuickActionCancelDownloadTitle.length > 0 ) {
							shortcutItem.localizedTitle = appQuickActionCancelDownloadTitle;
						}
						if ( appQuickActionCancelDownloadSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = appQuickActionCancelDownloadSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"hide-app"] || [shortcutItem.type hasSuffix:@"hide-app-suggestion"] ) {
					if ( appQuickActionHide ) {
						[shortcutItems addObject: shortcutItem];
						if ( appQuickActionHideTitle.length > 0 ) {
							shortcutItem.localizedTitle = appQuickActionHideTitle;
						}
						if ( appQuickActionHideSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = appQuickActionHideSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"show-all-windows"] ) {
					if ( appQuickActionShowAllWindows ) {
						[shortcutItems addObject: shortcutItem];
						if ( appQuickActionShowAllWindowsTitle.length > 0 ) {
							shortcutItem.localizedTitle = appQuickActionShowAllWindowsTitle;
						}
						if ( appQuickActionShowAllWindowsSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = appQuickActionShowAllWindowsSubtitle;
						}
					}
					continue;
				}
			}
			bool appSpecificQuickActions = [([tweakSettings objectForKey:[NSString stringWithFormat:@"appSpecificQuickActions-%@", applicationBundleID]] ?: @(YES)) boolValue];
			if ( appSpecificQuickActions && [[self icon] isApplicationIcon] ) {
				[shortcutItems addObject: shortcutItem];
			}
		}
		if ( appCustomQuickActionShareBundleID && applicationBundleID && !([self displayedLabelAccessoryType] == 3) ) {
			SBSApplicationShortcutItem *appCustomQuickActionShareBundleIDItem = [%c(SBSApplicationShortcutItem) alloc];
			appCustomQuickActionShareBundleIDItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.share-bundle-id";
			if ( appCustomQuickActionShareBundleIDTitle.length > 0 ) {
				appCustomQuickActionShareBundleIDItem.localizedTitle = appCustomQuickActionShareBundleIDTitle;
			} else {
				appCustomQuickActionShareBundleIDItem.localizedTitle = @"Share Bundle ID";
			}
			if ( appCustomQuickActionShareBundleIDSubtitle.length > 0 ) {
				appCustomQuickActionShareBundleIDItem.localizedSubtitle = appCustomQuickActionShareBundleIDSubtitle;
			} else {
				appCustomQuickActionShareBundleIDItem.localizedSubtitle = applicationBundleID;
			}
			appCustomQuickActionShareBundleIDItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"square.and.arrow.up"];
			[shortcutItems addObject: appCustomQuickActionShareBundleIDItem];
		}
		if ( appCustomQuickActionCopyBundleID && applicationBundleID && !([self displayedLabelAccessoryType] == 3) ) {
			SBSApplicationShortcutItem *appCustomQuickActionCopyBundleIDItem = [%c(SBSApplicationShortcutItem) alloc];
			appCustomQuickActionCopyBundleIDItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.copy-bundle-id";
			if ( appCustomQuickActionCopyBundleIDTitle.length > 0 ) {
				appCustomQuickActionCopyBundleIDItem.localizedTitle = appCustomQuickActionCopyBundleIDTitle;
			} else {
				appCustomQuickActionCopyBundleIDItem.localizedTitle = @"Copy Bundle ID";
			}
			if ( appCustomQuickActionCopyBundleIDSubtitle.length > 0 ) {
				appCustomQuickActionCopyBundleIDItem.localizedSubtitle = appCustomQuickActionCopyBundleIDSubtitle;
			} else {
				appCustomQuickActionCopyBundleIDItem.localizedSubtitle = applicationBundleID;
			}
			appCustomQuickActionCopyBundleIDItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"doc.on.clipboard"];
			[shortcutItems addObject: appCustomQuickActionCopyBundleIDItem];
		}
		if ( appCustomQuickActionOpenAppInFilza && applicationBundleID && !([self displayedLabelAccessoryType] == 3) ) {
			SBSApplicationShortcutItem *appCustomQuickActionOpenAppInFilzaItem = [%c(SBSApplicationShortcutItem) alloc];
			appCustomQuickActionOpenAppInFilzaItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.open-app-in-filza";
			if ( appCustomQuickActionOpenAppInFilzaTitle.length > 0 ) {
				appCustomQuickActionOpenAppInFilzaItem.localizedTitle = appCustomQuickActionOpenAppInFilzaTitle;
			} else {
				appCustomQuickActionOpenAppInFilzaItem.localizedTitle = @"Open App in Filza";
			}
			if ( appCustomQuickActionOpenAppInFilzaSubtitle.length > 0 ) {
				appCustomQuickActionOpenAppInFilzaItem.localizedSubtitle = appCustomQuickActionOpenAppInFilzaSubtitle;
			}
			appCustomQuickActionOpenAppInFilzaItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"folder"];
			[shortcutItems addObject: appCustomQuickActionOpenAppInFilzaItem];
		}
		if ( appCustomQuickActionClearBadge && applicationBundleID ) {
			SBSApplicationShortcutItem *appCustomQuickActionClearBadgeItem = [%c(SBSApplicationShortcutItem) alloc];
			appCustomQuickActionClearBadgeItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.clear-badge";
			if ( appCustomQuickActionClearBadgeTitle.length > 0 ) {
				appCustomQuickActionClearBadgeItem.localizedTitle = appCustomQuickActionClearBadgeTitle;
			} else {
				appCustomQuickActionClearBadgeItem.localizedTitle = @"Clear Badge";
			}
			if ( appCustomQuickActionClearBadgeSubtitle.length > 0 ) {
				appCustomQuickActionClearBadgeItem.localizedSubtitle = appCustomQuickActionClearBadgeSubtitle;
			}
			appCustomQuickActionClearBadgeItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"app.badge"];
			if ( haveBadge ) {
				[shortcutItems addObject: appCustomQuickActionClearBadgeItem];
			}
		}
		if ( appCustomQuickActionClearCache && applicationBundleID ) {
			SBSApplicationShortcutItem *appCustomQuickActionClearCacheItem = [%c(SBSApplicationShortcutItem) alloc];
			appCustomQuickActionClearCacheItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.clear-cache";
			if ( appCustomQuickActionClearCacheTitle.length > 0 ) {
				appCustomQuickActionClearCacheItem.localizedTitle = appCustomQuickActionClearCacheTitle;
			} else {
				appCustomQuickActionClearCacheItem.localizedTitle = @"Clear App Cache";
			}
			if ( appCustomQuickActionClearCacheSubtitle.length > 0 ) {
				appCustomQuickActionClearCacheItem.localizedSubtitle = appCustomQuickActionClearCacheSubtitle;
			}
			appCustomQuickActionClearCacheItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"arrow.counterclockwise"];
			if ( isDeletable && isInstalled ) {
				[shortcutItems addObject: appCustomQuickActionClearCacheItem];
			}
		}
		if ( appCustomQuickActionReset && applicationBundleID ) {
			SBSApplicationShortcutItem *appCustomQuickActionResetItem = [%c(SBSApplicationShortcutItem) alloc];
			appCustomQuickActionResetItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.reset-app";
			if ( appCustomQuickActionResetTitle.length > 0 ) {
				appCustomQuickActionResetItem.localizedTitle = appCustomQuickActionResetTitle;
			} else {
				appCustomQuickActionResetItem.localizedTitle = @"Reset App";
			}
			if ( appCustomQuickActionResetSubtitle.length > 0 ) {
				appCustomQuickActionResetItem.localizedSubtitle = appCustomQuickActionResetSubtitle;
			}
			appCustomQuickActionResetItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"arrow.2.squarepath"];
			if ( isDeletable && isInstalled ) {
				[shortcutItems addObject: appCustomQuickActionResetItem];
			}
		}
		if ( appCustomQuickActionOffload && applicationBundleID ) {
			SBSApplicationShortcutItem *appCustomQuickActionOffloadItem = [%c(SBSApplicationShortcutItem) alloc];
			appCustomQuickActionOffloadItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.offload-app";

			NSNumber *staticDiskUsage = 0;
			staticDiskUsage = applicationProxy.staticDiskUsage;

			if ( appCustomQuickActionOffloadTitle.length > 0 ) {
				appCustomQuickActionOffloadItem.localizedTitle = appCustomQuickActionOffloadTitle;
			} else {
				appCustomQuickActionOffloadItem.localizedTitle = @"Offload App";
			}
			if ( appCustomQuickActionOffloadSubtitle.length > 0 ) {
				appCustomQuickActionOffloadItem.localizedSubtitle = appCustomQuickActionOffloadSubtitle;
			} else {
				appCustomQuickActionOffloadItem.localizedSubtitle = [NSByteCountFormatter stringFromByteCount:[staticDiskUsage doubleValue] countStyle:NSByteCountFormatterCountStyleDecimal];
			}
			appCustomQuickActionOffloadItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"icloud.and.arrow.down"];
			if ( isDeletable && isInstalled ) {
				[shortcutItems addObject: appCustomQuickActionOffloadItem];
			}
		}
		if ( folderCustomQuickActionShareBundleID && [self isFolderIcon] ) {
			SBSApplicationShortcutItem *folderCustomQuickActionShareBundleIDItem = [%c(SBSApplicationShortcutItem) alloc];
			folderCustomQuickActionShareBundleIDItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.share-bundle-id";
			if ( folderCustomQuickActionShareBundleIDTitle.length > 0 ) {
				folderCustomQuickActionShareBundleIDItem.localizedTitle = folderCustomQuickActionShareBundleIDTitle;
			} else {
				folderCustomQuickActionShareBundleIDItem.localizedTitle = @"Share Bundle IDs";
			}
			if ( folderCustomQuickActionShareBundleIDSubtitle.length > 0 ) {
				folderCustomQuickActionShareBundleIDItem.localizedSubtitle = folderCustomQuickActionShareBundleIDSubtitle;
			}
			folderCustomQuickActionShareBundleIDItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"square.and.arrow.up"];

			[shortcutItems addObject: folderCustomQuickActionShareBundleIDItem];
		}
		if ( folderCustomQuickActionCopyBundleID && [self isFolderIcon] ) {
			SBSApplicationShortcutItem *folderCustomQuickActionCopyBundleIDItem = [%c(SBSApplicationShortcutItem) alloc];
			folderCustomQuickActionCopyBundleIDItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.copy-bundle-id";
			if ( folderCustomQuickActionCopyBundleIDTitle.length > 0 ) {
				folderCustomQuickActionCopyBundleIDItem.localizedTitle = folderCustomQuickActionCopyBundleIDTitle;
			} else {
				folderCustomQuickActionCopyBundleIDItem.localizedTitle = @"Copy Bundle IDs";
			}
			if ( folderCustomQuickActionCopyBundleIDSubtitle.length > 0 ) {
				folderCustomQuickActionCopyBundleIDItem.localizedSubtitle = folderCustomQuickActionCopyBundleIDSubtitle;
			}
			folderCustomQuickActionCopyBundleIDItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"doc.on.clipboard"];
			[shortcutItems addObject: folderCustomQuickActionCopyBundleIDItem];
		}
		if ( folderCustomQuickActionClearBadge && [self isFolderIcon] ) {
			SBSApplicationShortcutItem *folderCustomQuickActionClearBadgeItem = [%c(SBSApplicationShortcutItem) alloc];
			folderCustomQuickActionClearBadgeItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.clear-badge";
			if ( folderCustomQuickActionClearBadgeTitle.length > 0 ) {
				folderCustomQuickActionClearBadgeItem.localizedTitle = folderCustomQuickActionClearBadgeTitle;
			} else {
				folderCustomQuickActionClearBadgeItem.localizedTitle = @"Clear Badges";
			}
			if ( folderCustomQuickActionClearBadgeSubtitle.length > 0 ) {
				folderCustomQuickActionClearBadgeItem.localizedSubtitle = folderCustomQuickActionClearBadgeSubtitle;
			}
			folderCustomQuickActionClearBadgeItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"app.badge"];
			if ( haveBadge ) {
				[shortcutItems addObject: folderCustomQuickActionClearBadgeItem];
			}
		}
		if ( folderCustomQuickActionClearCache && [self isFolderIcon] ) {
			SBSApplicationShortcutItem *folderCustomQuickActionClearCacheItem = [%c(SBSApplicationShortcutItem) alloc];
			folderCustomQuickActionClearCacheItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.clear-cache";
			if ( folderCustomQuickActionClearCacheTitle.length > 0 ) {
				folderCustomQuickActionClearCacheItem.localizedTitle = folderCustomQuickActionClearCacheTitle;
			} else {
				folderCustomQuickActionClearCacheItem.localizedTitle = @"Clear Apps Cache";
			}
			if ( folderCustomQuickActionClearCacheSubtitle.length > 0 ) {
				folderCustomQuickActionClearCacheItem.localizedSubtitle = folderCustomQuickActionClearCacheSubtitle;
			}
			folderCustomQuickActionClearCacheItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"arrow.counterclockwise"];
			NSNumber *canCleanCache = 0;
			for ( SBIcon *icon in [[[self folderIcon] folder] icons] ) {
				LSApplicationProxy *applicationProxy = [%c(LSApplicationProxy) applicationProxyForIdentifier:[icon applicationBundleID]];
				bool isInstalled = applicationProxy.isInstalled;
				bool isDeletable = applicationProxy.isDeletable;
				if ( isDeletable && isInstalled ) {
					canCleanCache = [NSNumber numberWithFloat:([canCleanCache doubleValue] + 1)];
				}
			}
			if ( [canCleanCache integerValue] > 0 ) {
				[shortcutItems addObject: folderCustomQuickActionClearCacheItem];
			}
		}
		if ( folderCustomQuickActionReset && [self isFolderIcon] ) {
			SBSApplicationShortcutItem *folderCustomQuickActionResetItem = [%c(SBSApplicationShortcutItem) alloc];
			folderCustomQuickActionResetItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.reset-app";
			if ( folderCustomQuickActionResetTitle.length > 0 ) {
				folderCustomQuickActionResetItem.localizedTitle = folderCustomQuickActionResetTitle;
			} else {
				folderCustomQuickActionResetItem.localizedTitle = @"Reset Apps";
			}
			if ( folderCustomQuickActionResetSubtitle.length > 0 ) {
				folderCustomQuickActionResetItem.localizedSubtitle = folderCustomQuickActionResetSubtitle;
			}
			folderCustomQuickActionResetItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"arrow.2.squarepath"];
			NSNumber *canfolderCustomQuickActionReset = 0;
			for ( SBIcon *icon in [[[self folderIcon] folder] icons] ) {
				LSApplicationProxy *applicationProxy = [%c(LSApplicationProxy) applicationProxyForIdentifier:[icon applicationBundleID]];
				bool isInstalled = applicationProxy.isInstalled;
				bool isDeletable = applicationProxy.isDeletable;
				if ( isDeletable && isInstalled ) {
					canfolderCustomQuickActionReset = [NSNumber numberWithFloat:([canfolderCustomQuickActionReset doubleValue] + 1)];
				}
			}
			if ( [canfolderCustomQuickActionReset integerValue] > 0 ) {
				[shortcutItems addObject: folderCustomQuickActionResetItem];
			}
		}
		if ( folderCustomQuickActionOffload && [self isFolderIcon] ) {
			SBSApplicationShortcutItem *folderCustomQuickActionOffloadItem = [%c(SBSApplicationShortcutItem) alloc];
			folderCustomQuickActionOffloadItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.offload-app";
			NSNumber *staticDiskUsage = 0;
			for ( SBIcon *icon in [[[self folderIcon] folder] icons] ) {
				LSApplicationProxy *applicationProxy = [%c(LSApplicationProxy) applicationProxyForIdentifier:[icon applicationBundleID]];
				bool isInstalled = applicationProxy.isInstalled;
				bool isDeletable = applicationProxy.isDeletable;
				if ( isDeletable && isInstalled ) {
					staticDiskUsage = [NSNumber numberWithFloat:([staticDiskUsage doubleValue] + [applicationProxy.staticDiskUsage doubleValue])];
				}
			}
			if ( folderCustomQuickActionOffloadTitle.length > 0 ) {
				folderCustomQuickActionOffloadItem.localizedTitle = folderCustomQuickActionOffloadTitle;
			} else {
				folderCustomQuickActionOffloadItem.localizedTitle = @"Offload Apps";
			}
			if ( folderCustomQuickActionOffloadSubtitle.length > 0 ) {
				folderCustomQuickActionOffloadItem.localizedSubtitle = folderCustomQuickActionOffloadSubtitle;
			} else {
				folderCustomQuickActionOffloadItem.localizedSubtitle = [NSByteCountFormatter stringFromByteCount:[staticDiskUsage doubleValue] countStyle:NSByteCountFormatterCountStyleDecimal];
			}
			folderCustomQuickActionOffloadItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"icloud.and.arrow.down"];
			if ( [staticDiskUsage integerValue] > 0 ) {
				[shortcutItems addObject: folderCustomQuickActionOffloadItem];
			}
		}
		if ( folderCustomQuickActionAppList && [self isFolderIcon] ) {
			int iconsCount = 0;
			for ( SBBookmarkIcon *icon in [[[self folderIcon] folder] icons] ) {
				SBSApplicationShortcutItem *folderCustomQuickActionAppListItem = [%c(SBSApplicationShortcutItem) alloc];
				NSString* itemID = @"";
				NSString* itemType = @"";
				if ( [icon isApplicationIcon] ) {
					itemID = [icon applicationBundleID];
					itemType = @".app.";

					UIImage *appIcon = [UIImage _applicationIconImageForBundleIdentifier:itemID format:0 scale:([UIScreen mainScreen].scale)];
					[folderCustomQuickActionAppListItem setIcon:[[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImageData:UIImagePNGRepresentation(appIcon) dataType:0 isTemplate:0]];
				}
				if ( [icon isBookmarkIcon] ) {
					itemID = [NSString stringWithFormat:@"%@", [[icon webClip] pageURL]];
					itemType = @".bookmark.";
					UIImage *appIcon = [[icon webClip] iconImage];
					[folderCustomQuickActionAppListItem setIcon:[[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImageData:UIImagePNGRepresentation(appIcon) dataType:0 isTemplate:0]];
				}
				if ( itemID.length > 0 && itemType.length > 0 ) {
					iconsCount++;
					NSString *itemSuffix = [itemType stringByAppendingString:itemID];
					folderCustomQuickActionAppListItem.type = [@"com.tomaszpoliszuk.springboardhome.application-shortcut-item" stringByAppendingString:itemSuffix];
					folderCustomQuickActionAppListItem.localizedTitle = [icon displayName];
					[shortcutItems addObject: folderCustomQuickActionAppListItem];
				}
				if ( iconsCount >= folderCustomQuickActionAppListMax ) {
					break;
				}
			}
		}
		%orig(shortcutItems);
	} else {
		%orig;
	}
}
- (NSArray *)effectiveApplicationShortcutItems {
	NSArray *origValue = %orig;
	NSString* applicationBundleID;
	if([[self icon] respondsToSelector:@selector(applicationBundleID)]) {
		applicationBundleID = [[self icon] applicationBundleID];
	}
	if ( enableTweak ) {
		NSMutableArray *shortcutItems = [NSMutableArray arrayWithArray:origValue];
		if ( offloadedAppCustomQuickActionShareBundleID && applicationBundleID && ([self displayedLabelAccessoryType] == 3) ) {
			SBSApplicationShortcutItem *offloadedAppCustomQuickActionShareBundleIDItem = [%c(SBSApplicationShortcutItem) alloc];
			offloadedAppCustomQuickActionShareBundleIDItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.share-bundle-id";
			if ( offloadedAppCustomQuickActionShareBundleIDTitle.length > 0 ) {
				offloadedAppCustomQuickActionShareBundleIDItem.localizedTitle = offloadedAppCustomQuickActionShareBundleIDTitle;
			} else {
				offloadedAppCustomQuickActionShareBundleIDItem.localizedTitle = @"Share Bundle ID";
			}
			if ( offloadedAppCustomQuickActionShareBundleIDSubtitle.length > 0 ) {
				offloadedAppCustomQuickActionShareBundleIDItem.localizedSubtitle = offloadedAppCustomQuickActionShareBundleIDSubtitle;
			} else {
				offloadedAppCustomQuickActionShareBundleIDItem.localizedSubtitle = applicationBundleID;
			}
			offloadedAppCustomQuickActionShareBundleIDItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"square.and.arrow.up"];

			[shortcutItems addObject: offloadedAppCustomQuickActionShareBundleIDItem];
		}
		if ( offloadedAppCustomQuickActionCopyBundleID && applicationBundleID && ([self displayedLabelAccessoryType] == 3) ) {
			SBSApplicationShortcutItem *offloadedAppCustomQuickActionCopyBundleIDItem = [%c(SBSApplicationShortcutItem) alloc];
			offloadedAppCustomQuickActionCopyBundleIDItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.copy-bundle-id";
			if ( offloadedAppCustomQuickActionCopyBundleIDTitle.length > 0 ) {
				offloadedAppCustomQuickActionCopyBundleIDItem.localizedTitle = offloadedAppCustomQuickActionCopyBundleIDTitle;
			} else {
				offloadedAppCustomQuickActionCopyBundleIDItem.localizedTitle = @"Copy Bundle ID";
			}
			if ( offloadedAppCustomQuickActionCopyBundleIDSubtitle.length > 0 ) {
				offloadedAppCustomQuickActionCopyBundleIDItem.localizedSubtitle = offloadedAppCustomQuickActionCopyBundleIDSubtitle;
			} else {
				offloadedAppCustomQuickActionCopyBundleIDItem.localizedSubtitle = applicationBundleID;
			}
			offloadedAppCustomQuickActionCopyBundleIDItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"doc.on.clipboard"];

			[shortcutItems addObject: offloadedAppCustomQuickActionCopyBundleIDItem];
		}
		if ( offloadedAppCustomQuickActionOpenAppInFilza && applicationBundleID && ([self displayedLabelAccessoryType] == 3) ) {
			SBSApplicationShortcutItem *offloadedAppCustomQuickActionOpenAppInFilzaItem = [%c(SBSApplicationShortcutItem) alloc];
			offloadedAppCustomQuickActionOpenAppInFilzaItem.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.open-app-in-filza";
			if ( offloadedAppCustomQuickActionOpenAppInFilzaTitle.length > 0 ) {
				offloadedAppCustomQuickActionOpenAppInFilzaItem.localizedTitle = offloadedAppCustomQuickActionOpenAppInFilzaTitle;
			} else {
				offloadedAppCustomQuickActionOpenAppInFilzaItem.localizedTitle = @"Open App in Filza";
			}
			if ( offloadedAppCustomQuickActionOpenAppInFilzaSubtitle.length > 0 ) {
				offloadedAppCustomQuickActionOpenAppInFilzaItem.localizedSubtitle = offloadedAppCustomQuickActionOpenAppInFilzaSubtitle;
			}
			offloadedAppCustomQuickActionOpenAppInFilzaItem.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"folder"];
			[shortcutItems addObject: offloadedAppCustomQuickActionOpenAppInFilzaItem];
		}
		NSArray *outputShortcutItems = [shortcutItems copy];
		return outputShortcutItems;
	}
	return origValue;
}

- (bool)shouldActivateApplicationShortcutItem:(SBSApplicationShortcutItem*)arg1 atIndex:(unsigned long long)arg2 {
	bool origValue = %orig;
	NSString* applicationBundleID = [[self icon] applicationBundleID];
	if( ( [[self icon] respondsToSelector:@selector(applicationBundleID)] || [self isFolderIcon] ) && [[arg1 type] isEqualToString:@"com.tomaszpoliszuk.springboardhome.application-shortcut-item.copy-bundle-id"] ) {
		NSString *stringForPasteboard = @"";
		if ( [self isFolderIcon] ) {
			for ( SBIcon *icon in [[[self folderIcon] folder] icons] ) {
				stringForPasteboard = [stringForPasteboard stringByAppendingString:[icon applicationBundleID]];
				stringForPasteboard = [stringForPasteboard stringByAppendingString:@"\n"];
			}
		} else {
			stringForPasteboard = applicationBundleID;
		}
		[UIPasteboard generalPasteboard].string = stringForPasteboard;
		return NO;
	} else if( ( [[self icon] respondsToSelector:@selector(applicationBundleID)] || [self isFolderIcon] ) && [[arg1 type] isEqualToString:@"com.tomaszpoliszuk.springboardhome.application-shortcut-item.offload-app"] ) {
		NSString *title = @"";
		NSMutableArray *appsToOffload = [[NSMutableArray alloc] init];
		NSNumber *staticDiskUsage = 0;
		if ( [self isFolderIcon] ) {
			title = [[self folderIcon] folder].displayName;
			for ( SBIcon *icon in [[[self folderIcon] folder] icons] ) {
				LSApplicationProxy *applicationProxy = [%c(LSApplicationProxy) applicationProxyForIdentifier:[icon applicationBundleID]];
				staticDiskUsage = [NSNumber numberWithFloat:([staticDiskUsage doubleValue] + [applicationProxy.staticDiskUsage doubleValue])];
				[appsToOffload addObject: [icon applicationBundleID]];
			}
			UIWindow *currentAlertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
			currentAlertWindow.windowLevel = UIWindowLevelAlert + 13;
			currentAlertWindow.rootViewController = [[UIViewController alloc] init];
			UIAlertController *currentAlert = [UIAlertController alertControllerWithTitle:@"Offload Apps" message:[NSString stringWithFormat:@"Do you want to Offload Apps in %@ folder?", title] preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
				currentAlertWindow.hidden = YES;
				for ( NSString *applicationBundleID in appsToOffload ) {
					dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
						[%c(IXAppInstallCoordinator) demoteAppToPlaceholderWithBundleID:applicationBundleID forReason:2 waitForDeletion:1 completion:nil];
					});
				}
				NSString *message = [NSString stringWithFormat:@"Applications in %@ folder are now offloaded. Reclaimed %@.", title, [NSByteCountFormatter stringFromByteCount:[[NSNumber numberWithDouble:[staticDiskUsage doubleValue]] doubleValue] countStyle:NSByteCountFormatterCountStyleDecimal]];

				ShowMessage( title, message );
			}];
			UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
				currentAlertWindow.hidden = YES;
			}];
			[currentAlert addAction:confirm];
			[currentAlert addAction:cancel];
			[currentAlertWindow makeKeyAndVisible];
			[currentAlertWindow.rootViewController presentViewController:currentAlert animated:YES completion:nil];
		} else {
			LSApplicationProxy *applicationProxy = [%c(LSApplicationProxy) applicationProxyForIdentifier:applicationBundleID];
			title = applicationProxy.localizedName;
			staticDiskUsage = applicationProxy.staticDiskUsage;
			UIWindow *currentAlertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
			currentAlertWindow.windowLevel = UIWindowLevelAlert + 13;
			currentAlertWindow.rootViewController = [[UIViewController alloc] init];
			UIAlertController *currentAlert = [UIAlertController alertControllerWithTitle:@"Offload App" message:[NSString stringWithFormat:@"Do you want to Offload %@?", title] preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
				currentAlertWindow.hidden = YES;
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
					[%c(IXAppInstallCoordinator) demoteAppToPlaceholderWithBundleID:applicationBundleID forReason:2 waitForDeletion:1 completion:nil];
				});
				NSString *message = [NSString stringWithFormat:@"%@ is now offloaded. Reclaimed %@.", title, [NSByteCountFormatter stringFromByteCount:[[NSNumber numberWithDouble:[staticDiskUsage doubleValue]] doubleValue] countStyle:NSByteCountFormatterCountStyleDecimal]];

				ShowMessage( title, message );
			}];
			UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
				currentAlertWindow.hidden = YES;
			}];
			[currentAlert addAction:confirm];
			[currentAlert addAction:cancel];
			[currentAlertWindow makeKeyAndVisible];
			[currentAlertWindow.rootViewController presentViewController:currentAlert animated:YES completion:nil];
		}
		return NO;
	} else if ( ( [[self icon] respondsToSelector:@selector(applicationBundleID)] || [self isFolderIcon] ) && [[arg1 type] isEqualToString:@"com.tomaszpoliszuk.springboardhome.application-shortcut-item.clear-badge"] ) {
		if ( [self isFolderIcon] ) {
			for ( SBIcon *icon in [[[self folderIcon] folder] icons] ) {
				SBApplication *application = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:[icon applicationBundleID]];
				[application setBadgeValue:nil];
			}
		} else {
			SBApplication *application = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:applicationBundleID];
			[application setBadgeValue:nil];
		}
		return NO;
	} else if ( [[self icon] respondsToSelector:@selector(applicationBundleID)] && [[arg1 type] isEqualToString:@"com.tomaszpoliszuk.springboardhome.application-shortcut-item.clear-cache"] ) {
//	this part is from https://github.com/rpetrich/CacheClearer/blob/216dd186aface6243ca94810bf9fbadc5f8c3066/Tweak.x#L67-L88
		NSString *title = @"";
		NSString *message = @"";
		NSNumber *originalDynamicSize = 0;
		NSNumber *newDynamicSize = 0;
		if ( [self isFolderIcon] ) {
			title = [[self folderIcon] folder].displayName;
			for ( SBIcon *icon in [[[self folderIcon] folder] icons] ) {
				LSApplicationProxy *applicationProxy = [%c(LSApplicationProxy) applicationProxyForIdentifier:[icon applicationBundleID]];
				NSURL *dataContainer = applicationProxy.dataContainerURL;
				originalDynamicSize = [NSNumber numberWithFloat:([originalDynamicSize doubleValue] + [applicationProxy.dynamicDiskUsage doubleValue])];
				ClearDirectoryURLContents([dataContainer URLByAppendingPathComponent:@"tmp" isDirectory:YES]);
				ClearDirectoryURLContents([[dataContainer URLByAppendingPathComponent:@"Library" isDirectory:YES] URLByAppendingPathComponent:@"Caches" isDirectory:YES]);
				ClearDirectoryURLContents([[[dataContainer URLByAppendingPathComponent:@"Library" isDirectory:YES] URLByAppendingPathComponent:@"Application Support" isDirectory:YES] URLByAppendingPathComponent:@"Dropbox" isDirectory:YES]);
				LSApplicationProxy *applicationProxyNew = [%c(LSApplicationProxy) applicationProxyForIdentifier:applicationBundleID];
				newDynamicSize = [NSNumber numberWithFloat:([newDynamicSize doubleValue] + [applicationProxyNew.dynamicDiskUsage doubleValue])];
			}
			if ([newDynamicSize isEqualToNumber:originalDynamicSize] && [newDynamicSize integerValue] > 0 ) {
				message = [NSString stringWithFormat:@"Cache for Applications in %@ was already empty, no disk space was reclaimed.", title];
			} else {
				message = [NSString stringWithFormat:@"Reclaimed %@. \n Applications in %@ folder may use more data or run slower on next launch to repopulate the cache.", [NSByteCountFormatter stringFromByteCount:[[NSNumber numberWithDouble:[originalDynamicSize doubleValue] - [newDynamicSize doubleValue]] doubleValue] countStyle:NSByteCountFormatterCountStyleDecimal], title];
			}
		} else {
			LSApplicationProxy *applicationProxy = [%c(LSApplicationProxy) applicationProxyForIdentifier:applicationBundleID];
			NSURL *dataContainer = applicationProxy.dataContainerURL;
			title = applicationProxy.localizedName;
			originalDynamicSize = applicationProxy.dynamicDiskUsage;
			ClearDirectoryURLContents([dataContainer URLByAppendingPathComponent:@"tmp" isDirectory:YES]);
			ClearDirectoryURLContents([[dataContainer URLByAppendingPathComponent:@"Library" isDirectory:YES] URLByAppendingPathComponent:@"Caches" isDirectory:YES]);
			ClearDirectoryURLContents([[[dataContainer URLByAppendingPathComponent:@"Library" isDirectory:YES] URLByAppendingPathComponent:@"Application Support" isDirectory:YES] URLByAppendingPathComponent:@"Dropbox" isDirectory:YES]);
			LSApplicationProxy *applicationProxyNew = [%c(LSApplicationProxy) applicationProxyForIdentifier:applicationBundleID];
			newDynamicSize = applicationProxyNew.dynamicDiskUsage;
			if ([newDynamicSize isEqualToNumber:originalDynamicSize]) {
				message = [NSString stringWithFormat:@"Cache for %@ was already empty, no disk space was reclaimed.", title];
			} else {
				message = [NSString stringWithFormat:@"Reclaimed %@. \n %@ may use more data or run slower on next launch to repopulate the cache.", [NSByteCountFormatter stringFromByteCount:[[NSNumber numberWithDouble:[originalDynamicSize doubleValue] - [newDynamicSize doubleValue]] doubleValue] countStyle:NSByteCountFormatterCountStyleDecimal], title];
			}
		}
		ShowMessage( title, message );
		return NO;
	} else if ( [[self icon] respondsToSelector:@selector(applicationBundleID)] && [[arg1 type] isEqualToString:@"com.tomaszpoliszuk.springboardhome.application-shortcut-item.reset-app"] ) {
//	this part is from https://github.com/rpetrich/CacheClearer/blob/216dd186aface6243ca94810bf9fbadc5f8c3066/Tweak.x#L42-L65
		NSString *title = @"";
		NSMutableArray *appsToReset = [[NSMutableArray alloc] init];
		NSNumber *originalDynamicSize = 0;
		if ( [self isFolderIcon] ) {
			title = [[self folderIcon] folder].displayName;
			for ( SBIcon *icon in [[[self folderIcon] folder] icons] ) {
				LSApplicationProxy *applicationProxy = [%c(LSApplicationProxy) applicationProxyForIdentifier:[icon applicationBundleID]];
				NSURL *dataContainer = applicationProxy.dataContainerURL;
				[appsToReset addObject:dataContainer];
				originalDynamicSize = [NSNumber numberWithFloat:([originalDynamicSize doubleValue] + [applicationProxy.dynamicDiskUsage doubleValue])];
			}
			LSApplicationProxy *applicationProxyNew = [%c(LSApplicationProxy) applicationProxyForIdentifier:applicationBundleID];
			UIWindow *currentAlertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
			currentAlertWindow.windowLevel = UIWindowLevelAlert + 13;
			currentAlertWindow.rootViewController = [[UIViewController alloc] init];
			UIAlertController *currentAlert = [UIAlertController alertControllerWithTitle:@"Reset Apps" message:[NSString stringWithFormat:@"Do you want to Reset Apps in %@ folder?", title] preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
				currentAlertWindow.hidden = YES;

				NSNumber *newDynamicSize = 0;
				for ( NSURL *dataContainer in appsToReset ) {

					ClearDirectoryURLContents([dataContainer URLByAppendingPathComponent:@"tmp" isDirectory:YES]);
					NSURL *libraryURL = [dataContainer URLByAppendingPathComponent:@"Library" isDirectory:YES];
					ClearDirectoryURLContents(libraryURL);
					[[NSFileManager defaultManager] createDirectoryAtURL:[libraryURL URLByAppendingPathComponent:@"Preferences" isDirectory:YES] withIntermediateDirectories:YES attributes:nil error:NULL];
					ClearDirectoryURLContents([dataContainer URLByAppendingPathComponent:@"Documents" isDirectory:YES]);

					newDynamicSize = [NSNumber numberWithFloat:([newDynamicSize doubleValue] + [applicationProxyNew.dynamicDiskUsage doubleValue])];

				}
				NSString *message = @"";
				if ([newDynamicSize isEqualToNumber:originalDynamicSize] && [newDynamicSize integerValue] > 0 ) {
					message = [NSString stringWithFormat:@"Applications in %@ were already reset, no disk space was reclaimed.", title];
				} else {
					message = [NSString stringWithFormat:@"Applications in %@ folder are now restored to a fresh state. Reclaimed %@.", title, [NSByteCountFormatter stringFromByteCount:[[NSNumber numberWithDouble:[originalDynamicSize doubleValue] - [newDynamicSize doubleValue]] doubleValue] countStyle:NSByteCountFormatterCountStyleDecimal]];
				}
				ShowMessage( title, message );
			}];
			UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
				currentAlertWindow.hidden = YES;
			}];
			[currentAlert addAction:confirm];
			[currentAlert addAction:cancel];
			[currentAlertWindow makeKeyAndVisible];
			[currentAlertWindow.rootViewController presentViewController:currentAlert animated:YES completion:nil];

		} else {
			LSApplicationProxy *applicationProxy = [%c(LSApplicationProxy) applicationProxyForIdentifier:applicationBundleID];
			NSURL *dataContainer = applicationProxy.dataContainerURL;
			title = applicationProxy.localizedName;
			originalDynamicSize = applicationProxy.dynamicDiskUsage;

			UIWindow *currentAlertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
			currentAlertWindow.windowLevel = UIWindowLevelAlert + 13;
			currentAlertWindow.rootViewController = [[UIViewController alloc] init];

			UIAlertController *currentAlert = [UIAlertController alertControllerWithTitle:@"Reset App" message:[NSString stringWithFormat:@"Do you want to Reset %@?", title] preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
				currentAlertWindow.hidden = YES;
				NSNumber *newDynamicSize = 0;
				ClearDirectoryURLContents([dataContainer URLByAppendingPathComponent:@"tmp" isDirectory:YES]);
				NSURL *libraryURL = [dataContainer URLByAppendingPathComponent:@"Library" isDirectory:YES];
				ClearDirectoryURLContents(libraryURL);
				[[NSFileManager defaultManager] createDirectoryAtURL:[libraryURL URLByAppendingPathComponent:@"Preferences" isDirectory:YES] withIntermediateDirectories:YES attributes:nil error:NULL];
				ClearDirectoryURLContents([dataContainer URLByAppendingPathComponent:@"Documents" isDirectory:YES]);
				LSApplicationProxy *applicationProxyNew = [%c(LSApplicationProxy) applicationProxyForIdentifier:applicationBundleID];
				newDynamicSize = applicationProxyNew.dynamicDiskUsage;
				NSString *message = @"";
				if ([newDynamicSize isEqualToNumber:originalDynamicSize]) {
					message = [NSString stringWithFormat:@"%@ was already reset, no disk space was reclaimed.", title];
				} else {
					message = [NSString stringWithFormat:@"%@ is now restored to a fresh state. Reclaimed %@.", title, [NSByteCountFormatter stringFromByteCount:[[NSNumber numberWithDouble:[originalDynamicSize doubleValue] - [newDynamicSize doubleValue]] doubleValue] countStyle:NSByteCountFormatterCountStyleDecimal]];
				}
				ShowMessage( title, message );
			}];
			UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
				currentAlertWindow.hidden = YES;
			}];
			[currentAlert addAction:confirm];
			[currentAlert addAction:cancel];
			[currentAlertWindow makeKeyAndVisible];
			[currentAlertWindow.rootViewController presentViewController:currentAlert animated:YES completion:nil];
		}
		return NO;
	} else if ( [self respondsToSelector:@selector(applicationBundleIdentifierForShortcuts)] && [[arg1 type] isEqualToString:@"com.tomaszpoliszuk.springboardhome.application-shortcut-item.open-app-in-filza"] ) {
		LSApplicationProxy *applicationProxy = [%c(LSApplicationProxy) applicationProxyForIdentifier:applicationBundleID];
//	appStoreReceiptURL		->		opens application app store receipt folder (StoreKit)
//	bundleContainerURL		->		opens applications container and selects application
//	bundleURL				->		opens applications container and selects application
//	containerURL			->		opens applications data container and selects application data folder
//	dataContainerURL		->		opens applications data container and selects application data folder
//	groupContainerURLs		->		opens applications group container and selects application group folder - warning! it's NSDictionary
		NSString *pathInFilza = [@"filza://view" stringByAppendingString:applicationProxy.bundleURL.path];
		[[%c(SpringBoard) sharedApplication] applicationOpenURL:[NSURL URLWithString:[pathInFilza stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
		return NO;
	} else if ( [[self icon] respondsToSelector:@selector(applicationBundleID)] && [[arg1 type] hasPrefix:@"com.tomaszpoliszuk.springboardhome.application-shortcut-item.app."] ) {
		NSArray *arraySplitToString = [[arg1 type] componentsSeparatedByString:@".app."];
		NSString *bundleID = [arraySplitToString objectAtIndex:1];
		[[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleID suspended:NO];
		return NO;
	} else if ( [[self icon] respondsToSelector:@selector(applicationBundleID)] && [[arg1 type] hasPrefix:@"com.tomaszpoliszuk.springboardhome.application-shortcut-item.bookmark."] ) {
		NSArray *arraySplitToString = [[arg1 type] componentsSeparatedByString:@".bookmark."];
		NSString *bundleURL = [arraySplitToString objectAtIndex:1];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:bundleURL] options:@{} completionHandler:nil];
		return NO;
	} else if( ( [[self icon] respondsToSelector:@selector(applicationBundleID)] || [self isFolderIcon] ) && [[arg1 type] isEqualToString:@"com.tomaszpoliszuk.springboardhome.application-shortcut-item.share-bundle-id"] ) {
		NSString *stringToShare = @"";
		if ( [self isFolderIcon] ) {
			for ( SBBookmarkIcon *icon in [[[self folderIcon] folder] icons] ) {
				if ( ![icon isBookmarkIcon] ) {
					stringToShare = [stringToShare stringByAppendingString:[icon applicationBundleID]];
					stringToShare = [stringToShare stringByAppendingString:@"\n"];
				}
			}
		} else {
			stringToShare = applicationBundleID;
		}
		if (%c(UIActivityViewController)) {
			UIActivityViewController *activityViewController = [[%c(UIActivityViewController) alloc] initWithActivityItems:[NSArray arrayWithObjects:stringToShare, nil, nil] applicationActivities:nil];
			[self.window.rootViewController presentViewController:activityViewController animated:YES completion:nil];
		}
		return NO;
	}
	return origValue;
}
%end

%hook SBBookmarkIcon
- (bool)displaysShareBookmarkShortcutItem {
	bool origValue = %orig;
	if ( enableTweak ) {
		return bookmarkQuickActionShare;
	}
	return origValue;
}
%end

%hook SBHHomeScreenSettings
-(bool)showWidgets {
	bool origValue = %orig;
	if ( enableTweak ) {
		return widgetsInQuickActions;
	}
	return origValue;
}
%end

%hook _UIContextMenuActionsListView
- (bool)reversesActionOrder {
	bool origValue = %orig;
	if ( enableTweak ) {
		return reverseQuickActionsOrder;
	}
	return origValue;
}
%new
-(void)updateTraitOverride {
	if ( enableTweak && uiStyle != 999 ) {
		[self setOverrideUserInterfaceStyle:uiStyle];
	}
}
-(void)didMoveToWindow {
	if ( enableTweak && uiStyle != 999 ) {
		[self setOverrideUserInterfaceStyle:uiStyle];
	}
	%orig;
}
%end

%hook SBHIconViewContextMenuWrapperViewController
-(void)viewDidLoad {
//	this part is from https://github.com/EthanRDoesMC/Dawn tweak made by https://github.com/EthanRDoesMC
	if ( enableTweak && uiStyle != 999 ) {
		[self setOverrideUserInterfaceStyle:uiStyle];
	}
	%orig;
}
%end

%hook UIActivityContentViewController
- (void)viewWillAppear:(bool)arg1 {
	%orig;
	if ( enableTweak ) {
		kDismissFloatingDockIfPresented;
	}
}
- (void)viewWillDisappear:(bool)arg1 {
	%orig;
	if ( enableTweak ) {
		kPresentFloatingDockIfDismissed;
	}
}
%end

%hook SKRemoteProductActivityViewController
- (void)viewWillAppear:(bool)arg1 {
	%orig;
	if ( enableTweak ) {
		kDismissFloatingDockIfPresented;
	}
}
- (void)viewWillDisappear:(bool)arg1 {
	%orig;
	if ( enableTweak ) {
		kPresentFloatingDockIfDismissed;
	}
}
%end

%hook _UIInterfaceActionVibrantSeparatorView
- (void)layoutSubviews {
	if ( enableTweak && !showSeparators && iOSversion.majorVersion == 13 ) {
		if (
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBIconController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatingDockRootViewController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatyFolderController)]
		) {
			self.hidden = YES;
			[self setHidden:YES];
			[self setAlpha:0];
			self.alpha = 0;
		}
	}
	%orig;
}
%end

%hook _UIInterfaceActionBlankSeparatorView
- (void)layoutSubviews {
	if ( enableTweak && !showSeparators && iOSversion.majorVersion == 13 ) {
		if (
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBIconController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatingDockRootViewController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatyFolderController)]
		) {
			self.hidden = YES;
			[self setHidden:YES];
			[self setAlpha:0];
			self.alpha = 0;
		}
	}
	%orig;
}
%end

%hook _UIContextMenuActionsListSeparatorView
- (void)_updateMaskingUsingAttributes:(id)arg1 {
	if ( enableTweak && !showSeparators && iOSversion.majorVersion > 13 ) {
		if (
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBIconController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatingDockRootViewController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatyFolderController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBHLibraryViewController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBHomeScreenOverlayViewController)]
		) {
			self.hidden = YES;
			[self setHidden:YES];
			[self setAlpha:0];
			self.alpha = 0;
		}
	}
	%orig;
}
%end

%hook UICollectionReusableView
- (void)layoutSubviews {
	if ( enableTweak && !showSeparators && iOSversion.majorVersion > 13 ) {
		if (
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBIconController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatingDockRootViewController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatyFolderController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBHLibraryViewController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBHomeScreenOverlayViewController)]
		) {
			if ( [self.reuseIdentifier isEqual:@"kContextMenuItemSeparator"] ) {
				[self setHidden:YES];
				self.hidden = YES;
				[self setAlpha:0];
				self.alpha = 0;
			}
		}
	}
	%orig;
}
%end

%ctor {
	SettingsChanged();
	CFNotificationCenterAddObserver(
		CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		receivedNotification,
		CFSTR("com.tomaszpoliszuk.homescreenquickactions.settingschanged"),
		NULL,
		CFNotificationSuspensionBehaviorDeliverImmediately
	);
	%init;
}
