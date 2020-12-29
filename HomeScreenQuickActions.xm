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


@interface UIView (HomeScreenQuickActions)
-(id)_viewControllerForAncestor;
@end

@interface SBIconView : UIView
@property (nonatomic, readonly, copy) NSString *applicationBundleIdentifierForShortcuts;
@end

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *localizedSubtitle;
@end

@interface UIInterfaceActionGroupView : UIView
@end
@interface _UIContextMenuActionsListView : UIInterfaceActionGroupView
@end

@interface _UIInterfaceActionBlankSeparatorView : UIView
@end

@interface _UIInterfaceActionVibrantSeparatorView : UIView
@end

@interface _UIContextMenuActionsListSeparatorView : UICollectionReusableView
@end

@interface SBHIconViewContextMenuWrapperViewController : UIViewController
@end

static NSOperatingSystemVersion iOSversion = [[NSProcessInfo processInfo] operatingSystemVersion];

NSString *domainString = @"com.tomaszpoliszuk.homescreenquickactions";

NSUserDefaults *tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:domainString];

static id bundleId;

static bool enableTweak;

static int uiStyle;

static bool showSeparators;

static bool reverseQuickActionsOrder;

static bool quickActionEditHomeScreen;
static NSString *quickActionEditHomeScreenTitle = @"";
static NSString *quickActionEditHomeScreenSubtitle = @"";

static bool quickActionRenameFolder;
static NSString *quickActionRenameFolderTitle = @"";
static NSString *quickActionRenameFolderSubtitle = @"";

static bool quickActionShare;
static NSString *quickActionShareTitle = @"";
static NSString *quickActionShareSubtitle = @"";

//	visible during downloading app
static bool quickActionPrioritizeDownload;
static NSString *quickActionPrioritizeDownloadTitle = @"";
static NSString *quickActionPrioritizeDownloadSubtitle = @"";

static bool quickActionPauseDownload;
static NSString *quickActionPauseDownloadTitle = @"";
static NSString *quickActionPauseDownloadSubtitle = @"";

static bool quickActionCancelDownload;
static NSString *quickActionCancelDownloadTitle = @"";
static NSString *quickActionCancelDownloadSubtitle = @"";

//	visible in iPad Dock recents/suggestions
static bool quickActionHideApp;
static NSString *quickActionHideAppTitle = @"";
static NSString *quickActionHideAppSubtitle = @"";

//	iOS13
static bool quickActionWidgets;
static bool quickActionDeleteApp;
static NSString *quickActionDeleteAppTitle = @"";
static NSString *quickActionDeleteAppSubtitle = @"";

//	iOS14
static bool quickActionHideFolder;
static NSString *quickActionHideFolderTitle = @"";
static NSString *quickActionHideFolderSubtitle = @"";

static bool quickActionRemoveApp;
static NSString *quickActionRemoveAppTitle = @"";
static NSString *quickActionRemoveAppSubtitle = @"";

static bool quickActionRemoveWidget;
static NSString *quickActionRemoveWidgetTitle = @"";
static NSString *quickActionRemoveWidgetSubtitle = @"";

static bool quickActionConfigureWidget;
static NSString *quickActionConfigureWidgetTitle = @"";
static NSString *quickActionConfigureWidgetSubtitle = @"";

static bool quickActionConfigureStack;
static NSString *quickActionConfigureStackTitle = @"";
static NSString *quickActionConfigureStackSubtitle = @"";

static bool quickActionAddToHomeScreen;
static NSString *quickActionAddToHomeScreenTitle = @"";
static NSString *quickActionAddToHomeScreenSubtitle = @"";

//	Custom Actions
static bool copyBundleID;
static NSString *copyBundleIDTitle = @"";
static NSString *copyBundleIDSubtitle = @"";

void TweakSettingsChanged() {

	enableTweak = [([tweakSettings objectForKey:@"enableTweak"] ?: @(YES)) boolValue];

	uiStyle = [([tweakSettings valueForKey:@"uiStyle"] ?: @(999)) integerValue];

	showSeparators = [([tweakSettings objectForKey:@"showSeparators"] ?: @(YES)) boolValue];

	reverseQuickActionsOrder = [([tweakSettings objectForKey:@"reverseQuickActionsOrder"] ?: @(NO)) boolValue];

	quickActionEditHomeScreen = [([tweakSettings objectForKey:@"quickActionEditHomeScreen"] ?: @(YES)) boolValue];
	quickActionEditHomeScreenTitle = [tweakSettings objectForKey:@"quickActionEditHomeScreenTitle"];
	quickActionEditHomeScreenSubtitle = [tweakSettings objectForKey:@"quickActionEditHomeScreenSubtitle"];

	quickActionRenameFolder = [([tweakSettings objectForKey:@"quickActionRenameFolder"] ?: @(YES)) boolValue];
	quickActionRenameFolderTitle = [tweakSettings objectForKey:@"quickActionRenameFolderTitle"];
	quickActionRenameFolderSubtitle = [tweakSettings objectForKey:@"quickActionRenameFolderSubtitle"];

	quickActionShare = [([tweakSettings objectForKey:@"quickActionShare"] ?: @(NO)) boolValue];
	quickActionShareTitle = [tweakSettings objectForKey:@"quickActionShareTitle"];
	quickActionShareSubtitle = [tweakSettings objectForKey:@"quickActionShareSubtitle"];

	quickActionPrioritizeDownload = [([tweakSettings objectForKey:@"quickActionPrioritizeDownload"] ?: @(YES)) boolValue];
	quickActionPrioritizeDownloadTitle = [tweakSettings objectForKey:@"quickActionPrioritizeDownloadTitle"];
	quickActionPrioritizeDownloadSubtitle = [tweakSettings objectForKey:@"quickActionPrioritizeDownloadSubtitle"];

	quickActionPauseDownload = [([tweakSettings objectForKey:@"quickActionPauseDownload"] ?: @(YES)) boolValue];
	quickActionPauseDownloadTitle = [tweakSettings objectForKey:@"quickActionPauseDownloadTitle"];
	quickActionPauseDownloadSubtitle = [tweakSettings objectForKey:@"quickActionPauseDownloadSubtitle"];

	quickActionCancelDownload = [([tweakSettings objectForKey:@"quickActionCancelDownload"] ?: @(YES)) boolValue];
	quickActionCancelDownloadTitle = [tweakSettings objectForKey:@"quickActionCancelDownloadTitle"];
	quickActionCancelDownloadSubtitle = [tweakSettings objectForKey:@"quickActionCancelDownloadSubtitle"];

	quickActionHideApp = [([tweakSettings objectForKey:@"quickActionHideApp"] ?: @(YES)) boolValue];
	quickActionHideAppTitle = [tweakSettings objectForKey:@"quickActionHideAppTitle"];
	quickActionHideAppSubtitle = [tweakSettings objectForKey:@"quickActionHideAppSubtitle"];

	quickActionWidgets = [([tweakSettings objectForKey:@"quickActionWidgets"] ?: @(NO)) boolValue];
	quickActionDeleteApp = [([tweakSettings objectForKey:@"quickActionDeleteApp"] ?: @(YES)) boolValue];
	quickActionDeleteAppTitle = [tweakSettings objectForKey:@"quickActionDeleteAppTitle"];
	quickActionDeleteAppSubtitle = [tweakSettings objectForKey:@"quickActionDeleteAppSubtitle"];

	quickActionHideFolder = [([tweakSettings objectForKey:@"quickActionHideFolder"] ?: @(YES)) boolValue];
	quickActionHideFolderTitle = [tweakSettings objectForKey:@"quickActionHideFolderTitle"];
	quickActionHideFolderSubtitle = [tweakSettings objectForKey:@"quickActionHideFolderSubtitle"];

	quickActionRemoveApp = [([tweakSettings objectForKey:@"quickActionRemoveApp"] ?: @(YES)) boolValue];
	quickActionRemoveAppTitle = [tweakSettings objectForKey:@"quickActionRemoveAppTitle"];
	quickActionRemoveAppSubtitle = [tweakSettings objectForKey:@"quickActionRemoveAppSubtitle"];

	quickActionRemoveWidget = [([tweakSettings objectForKey:@"quickActionRemoveWidget"] ?: @(YES)) boolValue];
	quickActionRemoveWidgetTitle = [tweakSettings objectForKey:@"quickActionRemoveWidgetTitle"];
	quickActionRemoveWidgetSubtitle = [tweakSettings objectForKey:@"quickActionRemoveWidgetSubtitle"];

	quickActionConfigureWidget = [([tweakSettings objectForKey:@"quickActionConfigureWidget"] ?: @(YES)) boolValue];
	quickActionConfigureWidgetTitle = [tweakSettings objectForKey:@"quickActionConfigureWidgetTitle"];
	quickActionConfigureWidgetSubtitle = [tweakSettings objectForKey:@"quickActionConfigureWidgetSubtitle"];

	quickActionConfigureStack = [([tweakSettings objectForKey:@"quickActionConfigureStack"] ?: @(YES)) boolValue];
	quickActionConfigureStackTitle = [tweakSettings objectForKey:@"quickActionConfigureStackTitle"];
	quickActionConfigureStackSubtitle = [tweakSettings objectForKey:@"quickActionConfigureStackSubtitle"];

	quickActionAddToHomeScreen = [([tweakSettings objectForKey:@"quickActionAddToHomeScreen"] ?: @(YES)) boolValue];
	quickActionAddToHomeScreenTitle = [tweakSettings objectForKey:@"quickActionAddToHomeScreenTitle"];
	quickActionAddToHomeScreenSubtitle = [tweakSettings objectForKey:@"quickActionAddToHomeScreenSubtitle"];

	copyBundleID = [([tweakSettings objectForKey:@"copyBundleID"] ?: @(YES)) boolValue];
	copyBundleIDTitle = [tweakSettings objectForKey:@"copyBundleIDTitle"];
	copyBundleIDSubtitle = [tweakSettings objectForKey:@"copyBundleIDSubtitle"];
}

%hook SBIconView
-(void)setApplicationShortcutItems:(NSArray *)arg1 {
	NSString* bundleId;
	if([self respondsToSelector:@selector(applicationBundleIdentifierForShortcuts)]) {
		bundleId = [self applicationBundleIdentifierForShortcuts];
	}
	NSMutableArray *shortcutItems = [[NSMutableArray alloc] init];
	if ( enableTweak ) {
		for (SBSApplicationShortcutItem *shortcutItem in arg1) {
//	Apple uses both prefixes for system shortcuts:
//	- com.apple.springboardhome.application-shotcut-item - with typo "shotcut" name
//	- com.apple.springboardhome.application-shortcut-item - with correct "shortcut" name
//	- so let's detect both of them in one run:
			if ( [shortcutItem.type hasPrefix:@"com.apple.springboardhome.application-"] ) {
				if ( [shortcutItem.type hasSuffix:@"rearrange-icons"] ) {
					if ( quickActionEditHomeScreen ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionEditHomeScreenTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionEditHomeScreenTitle;
						}
						if ( quickActionEditHomeScreenSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionEditHomeScreenSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"rename-folder"] ) {
					if ( quickActionRenameFolder ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionRenameFolderTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionRenameFolderTitle;
						}
						if ( quickActionRenameFolderSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionRenameFolderSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"hide-folder"] ) {
					if ( quickActionHideFolder ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionHideFolderTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionHideFolderTitle;
						}
						if ( quickActionHideFolderSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionHideFolderSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"item.share"] ) {
					if ( quickActionShare ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionShareTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionShareTitle;
						}
						if ( quickActionShareSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionShareSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"delete-app"] ) {
					if ( quickActionDeleteApp ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionDeleteAppTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionDeleteAppTitle;
						}
						if ( quickActionDeleteAppSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionDeleteAppSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"remove-app"] ) {
					if ( quickActionRemoveApp ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionRemoveAppTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionRemoveAppTitle;
						}
						if ( quickActionRemoveAppSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionRemoveAppSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"pause-download"] ) {
					if ( quickActionPauseDownload ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionPauseDownloadTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionPauseDownloadTitle;
						}
						if ( quickActionPauseDownloadSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionPauseDownloadSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"cancel-download"] ) {
					if ( quickActionCancelDownload ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionCancelDownloadTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionCancelDownloadTitle;
						}
						if ( quickActionCancelDownloadSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionCancelDownloadSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"prioritize-download"] ) {
					if ( quickActionPrioritizeDownload ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionPrioritizeDownloadTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionPrioritizeDownloadTitle;
						}
						if ( quickActionPrioritizeDownloadSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionPrioritizeDownloadSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"hide-app"] || [shortcutItem.type hasSuffix:@"hide-app-suggestion"] ) {
					if ( quickActionHideApp ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionHideAppTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionHideAppTitle;
						}
						if ( quickActionHideAppSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionHideAppSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"configure-stack"] ) {
					if ( quickActionConfigureStack ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionConfigureStackTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionConfigureStackTitle;
						}
						if ( quickActionConfigureStackSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionConfigureStackSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"configure-widget"] ) {
					if ( quickActionConfigureWidget ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionConfigureWidgetTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionConfigureWidgetTitle;
						}
						if ( quickActionConfigureWidgetSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionConfigureWidgetSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"remove-widget"] ) {
					if ( quickActionRemoveWidget ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionRemoveWidgetTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionRemoveWidgetTitle;
						}
						if ( quickActionRemoveWidgetSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionRemoveWidgetSubtitle;
						}
					}
					continue;
				}
				if ( [shortcutItem.type hasSuffix:@"add-to-home-screen"] ) {
					if ( quickActionAddToHomeScreen ) {
						[shortcutItems addObject: shortcutItem];
						if ( quickActionAddToHomeScreenTitle.length > 0 ) {
							shortcutItem.localizedTitle = quickActionAddToHomeScreenTitle;
						}
						if ( quickActionAddToHomeScreenSubtitle.length > 0 ) {
							shortcutItem.localizedSubtitle = quickActionAddToHomeScreenSubtitle;
						}
					}
					continue;
				}
			}
			bool appSpecificQuickActions = [[tweakSettings objectForKey:[NSString stringWithFormat:@"appSpecificQuickActions-%@", bundleId]] boolValue];
			if ( [tweakSettings objectForKey:[NSString stringWithFormat:@"appSpecificQuickActions-%@", bundleId]] == nil ) {
				[shortcutItems addObject: shortcutItem];
			} else if ( appSpecificQuickActions ) {
				[shortcutItems addObject: shortcutItem];
			}
		}
		if ( copyBundleID && bundleId ) {
			SBSApplicationShortcutItem *copyBundleIDAction = [%c(SBSApplicationShortcutItem) alloc];
			copyBundleIDAction.type = @"com.tomaszpoliszuk.springboardhome.application-shortcut-item.copy-bundle-id";
			if ( copyBundleIDTitle.length > 0 ) {
				copyBundleIDAction.localizedTitle = copyBundleIDTitle;
			} else {
				copyBundleIDAction.localizedTitle = @"Copy Bundle ID";
			}
			if ( copyBundleIDSubtitle.length > 0 ) {
				copyBundleIDAction.localizedSubtitle = copyBundleIDSubtitle;
			} else {
				copyBundleIDAction.localizedSubtitle = bundleId;
			}
			[shortcutItems addObject: copyBundleIDAction];
		}
		%orig(shortcutItems);
	} else {
		%orig;
	}

}
- (bool)shouldActivateApplicationShortcutItem:(SBSApplicationShortcutItem*)arg1 atIndex:(unsigned long long)arg2 {
	bool origValue = %orig;
	NSString* bundleId;
	if( [self respondsToSelector:@selector(applicationBundleIdentifierForShortcuts)] && [[arg1 type] isEqualToString:@"com.tomaszpoliszuk.springboardhome.application-shortcut-item.copy-bundle-id"] ) {
		bundleId = [self applicationBundleIdentifierForShortcuts];
		[UIPasteboard generalPasteboard].string = bundleId;
		return NO;
	}
	return origValue;
}
%end
}
%end

//	app quick actions
%hook SBHHomeScreenSettings
-(bool)showWidgets {
	bool origValue = %orig;
	if ( enableTweak ) {
		return quickActionWidgets;
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

//	this part is from https://github.com/EthanRDoesMC/Dawn tweak made by https://github.com/EthanRDoesMC
%hook SBHIconViewContextMenuWrapperViewController
-(void)viewDidLoad {
	if ( enableTweak && uiStyle != 999 ) {
		[self setOverrideUserInterfaceStyle:uiStyle];
	}
	%orig;
}
%end
//	end of part from Dawn

%hook _UIInterfaceActionVibrantSeparatorView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && !showSeparators && iOSversion.majorVersion == 13 ) {
		if (
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBIconController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatingDockRootViewController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatyFolderController)]
		) {
			return YES;
		}
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && !showSeparators && iOSversion.majorVersion == 13 ) {
		if (
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBIconController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatingDockRootViewController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatyFolderController)]
		) {
			arg1 = YES;
		}
	}
	%orig;
}
%end

%hook _UIContextMenuActionsListSeparatorView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && !showSeparators && iOSversion.majorVersion == 14 ) {
		if (
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBIconController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatingDockRootViewController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatyFolderController)]
		) {
			return YES;
		}
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && !showSeparators && iOSversion.majorVersion == 14 ) {
		if (
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBIconController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatingDockRootViewController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatyFolderController)]
		) {
			arg1 = YES;
		}
	}
	%orig;
}
%end

%hook _UIInterfaceActionBlankSeparatorView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && !showSeparators && iOSversion.majorVersion == 13 ) {
		if (
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBIconController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatingDockRootViewController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatyFolderController)]
		) {
			return YES;
		}
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && !showSeparators && iOSversion.majorVersion == 13 ) {
		if (
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBIconController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatingDockRootViewController)]
			||
			[[self _viewControllerForAncestor] isKindOfClass:%c(SBFloatyFolderController)]
		) {
			arg1 = YES;
		}
	}
	%orig;
}
%end

%ctor {
	TweakSettingsChanged();
	CFNotificationCenterAddObserver(
		CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		(CFNotificationCallback)TweakSettingsChanged,
		CFSTR("com.tomaszpoliszuk.homescreenquickactions.settingschanged"),
		NULL,
		CFNotificationSuspensionBehaviorDeliverImmediately
	);
	%init;
}
