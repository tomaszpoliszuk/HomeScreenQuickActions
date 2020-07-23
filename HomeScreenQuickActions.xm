@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *type;
- (void)setIcon:(SBSApplicationShortcutItem *)arg1;
@end

@interface PTSettings : NSObject
@end

@interface SBHHomeScreenSettings : PTSettings {}
- (bool)showWidgets;
@end


@interface SBIconView : UIView
@property (nonatomic, readonly, copy) NSString *applicationBundleIdentifierForShortcuts;
@end

@interface UIView (HomeScreenQuickActions)
-(void)setOverrideUserInterfaceStyle:(NSInteger)style;
@end

@interface UIInterfaceActionGroupView : UIView
-(void)updateTraitOverride;
@end

@interface _UIContextMenuActionsListView : UIInterfaceActionGroupView
-(void)updateTraitOverride;
@end

@interface SBHIconViewContextMenuWrapperViewController : UIViewController
-(void)updateTraitOverride;
@end

NSString *domainString = @"com.tomaszpoliszuk.homescreenquickactions";
NSUserDefaults *tweakSettings;

static id bundleId;
//	enable tweak
static BOOL enableTweak;
//	global quick actions:
static BOOL quickActionEditHomeScreen;
//	folders quick actions:
static BOOL quickActionRenameFolder;
//	app quick actions
static BOOL quickActionWidget;
//	app store apps quick actions:
static BOOL quickActionShare;
static BOOL quickActionDelete;
//	app quick actions visible while app is downloading from app store
static BOOL quickActionPauseDownload;
static BOOL quickActionCancelDownload;
static BOOL quickActionPrioritizeDownload;
//	dock app quick actions
static BOOL quickActionHideApp;
//	new actions
static BOOL copyBundleID;

static int uiStyle;

static BOOL reverseQuickActionsOrder;

//	global quick actions:
static NSString *quickActionEditHomeScreenTitle = @"";
static NSString *quickActionEditHomeScreenSubtitle = @"";
//	folders quick actions:
static NSString *quickActionRenameFolderTitle = @"";
static NSString *quickActionRenameFolderSubtitle = @"";
//	app store apps quick actions:
static NSString *quickActionShareTitle = @"";
static NSString *quickActionShareSubtitle = @"";
static NSString *quickActionDeleteTitle = @"";
static NSString *quickActionDeleteSubtitle = @"";
//	app quick actions visible while app is downloading from app store
static NSString *quickActionPauseDownloadTitle = @"";
static NSString *quickActionPauseDownloadSubtitle = @"";
static NSString *quickActionCancelDownloadTitle = @"";
static NSString *quickActionCancelDownloadSubtitle = @"";
static NSString *quickActionPrioritizeDownloadTitle = @"";
static NSString *quickActionPrioritizeDownloadSubtitle = @"";
//	dock app quick actions
static NSString *quickActionHideAppTitle = @"";
static NSString *quickActionHideAppSubtitle = @"";
//	new actions
static NSString *copyBundleIDTitle = @"Copy Bundle ID";
static NSString *copyBundleIDSubtitle = @"bundleID";

void TweakSettingsChanged() {
	tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:domainString];
//	enable tweak
	enableTweak = [[tweakSettings objectForKey:@"enableTweak"] boolValue];
//	global quick actions:
	quickActionEditHomeScreen = [[tweakSettings objectForKey:@"quickActionEditHomeScreen"] boolValue];
//	folders quick actions:
	quickActionRenameFolder = [[tweakSettings objectForKey:@"quickActionRenameFolder"] boolValue];
//	app quick actions
	quickActionWidget = [[tweakSettings objectForKey:@"quickActionWidget"] boolValue];
//	app store apps quick actions:
	quickActionShare = [[tweakSettings objectForKey:@"quickActionShare"] boolValue];
	quickActionDelete = [[tweakSettings objectForKey:@"quickActionDelete"] boolValue];
//	app quick actions visible while app is downloading from app store
	quickActionPauseDownload = [[tweakSettings objectForKey:@"quickActionPauseDownload"] boolValue];
	quickActionCancelDownload = [[tweakSettings objectForKey:@"quickActionCancelDownload"] boolValue];
	quickActionPrioritizeDownload = [[tweakSettings objectForKey:@"quickActionPrioritizeDownload"] boolValue];
//	dock app quick actions
	quickActionHideApp = [[tweakSettings objectForKey:@"quickActionHideApp"] boolValue];

	copyBundleID = [[tweakSettings objectForKey:@"copyBundleID"] boolValue];

	uiStyle = [[tweakSettings valueForKey:@"uiStyle"] integerValue];

	reverseQuickActionsOrder = [[tweakSettings objectForKey:@"reverseQuickActionsOrder"] boolValue];

//	global quick actions:
	quickActionEditHomeScreenTitle = [tweakSettings objectForKey:@"quickActionEditHomeScreenTitle"];
	quickActionEditHomeScreenSubtitle = [tweakSettings objectForKey:@"quickActionEditHomeScreenSubtitle"];
//	folders quick actions:
	quickActionRenameFolderTitle = [tweakSettings objectForKey:@"quickActionRenameFolderTitle"];
	quickActionRenameFolderSubtitle = [tweakSettings objectForKey:@"quickActionRenameFolderSubtitle"];
//	app store apps quick actions:
	quickActionShareTitle = [tweakSettings objectForKey:@"quickActionShareTitle"];
	quickActionShareSubtitle = [tweakSettings objectForKey:@"quickActionShareSubtitle"];
	quickActionDeleteTitle = [tweakSettings objectForKey:@"quickActionDeleteTitle"];
	quickActionDeleteSubtitle = [tweakSettings objectForKey:@"quickActionDeleteSubtitle"];
//	app quick actions visible while app is downloading from app store
	quickActionPauseDownloadTitle = [tweakSettings objectForKey:@"quickActionPauseDownloadTitle"];
	quickActionPauseDownloadSubtitle = [tweakSettings objectForKey:@"quickActionPauseDownloadSubtitle"];
	quickActionCancelDownloadTitle = [tweakSettings objectForKey:@"quickActionCancelDownloadTitle"];
	quickActionCancelDownloadSubtitle = [tweakSettings objectForKey:@"quickActionCancelDownloadSubtitle"];
	quickActionPrioritizeDownloadTitle = [tweakSettings objectForKey:@"quickActionPrioritizeDownloadTitle"];
	quickActionPrioritizeDownloadSubtitle = [tweakSettings objectForKey:@"quickActionPrioritizeDownloadSubtitle"];
//	dock app quick actions
	quickActionHideAppTitle = [tweakSettings objectForKey:@"quickActionHideAppTitle"];
	quickActionHideAppSubtitle = [tweakSettings objectForKey:@"quickActionHideAppSubtitle"];
//	new actions
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
	for (SBSApplicationShortcutItem *shortcutItem in arg1) {
//	global quick actions:
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shotcut-item.rearrange-icons"] ) {
			if ( quickActionEditHomeScreen ) {
				[shortcutItems addObject: shortcutItem];
			}
			if ( quickActionEditHomeScreenTitle.length > 0 ) {
				shortcutItem.localizedTitle = quickActionEditHomeScreenTitle;
			}
			if ( quickActionEditHomeScreenSubtitle.length > 0 ) {
				shortcutItem.localizedSubtitle = quickActionEditHomeScreenSubtitle;
			}
			continue;
		}
//	folders quick actions:
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.rename-folder"] ) {
			if ( quickActionRenameFolder ) {
				[shortcutItems addObject: shortcutItem];
			}
			if ( quickActionRenameFolderTitle.length > 0 ) {
				shortcutItem.localizedTitle = quickActionRenameFolderTitle;
			}
			if ( quickActionRenameFolderSubtitle.length > 0 ) {
				shortcutItem.localizedSubtitle = quickActionRenameFolderSubtitle;
			}
			continue;
		}
//	app store apps quick actions:
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.share"] ) {
			if ( quickActionShare ) {
				[shortcutItems addObject: shortcutItem];
			}
			if ( quickActionShareTitle.length > 0 ) {
				shortcutItem.localizedTitle = quickActionShareTitle;
			}
			if ( quickActionShareSubtitle.length > 0 ) {
				shortcutItem.localizedSubtitle = quickActionShareSubtitle;
			}
			continue;
		}
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shotcut-item.delete-app"] ) {
			if ( quickActionDelete ) {
				[shortcutItems addObject: shortcutItem];
			}
			if ( quickActionDeleteTitle.length > 0 ) {
				shortcutItem.localizedTitle = quickActionDeleteTitle;
			}
			if ( quickActionDeleteSubtitle.length > 0 ) {
				shortcutItem.localizedSubtitle = quickActionDeleteSubtitle;
			}
			continue;
		}
//	app quick actions visible while app is downloading from app store
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.pause-download"] ) {
			if ( quickActionPauseDownload ) {
				[shortcutItems addObject: shortcutItem];
			}
			if ( quickActionPauseDownloadTitle.length > 0 ) {
				shortcutItem.localizedTitle = quickActionPauseDownloadTitle;
			}
			if ( quickActionPauseDownloadSubtitle.length > 0 ) {
				shortcutItem.localizedSubtitle = quickActionPauseDownloadSubtitle;
			}
			continue;
		}
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.cancel-download"] ) {
			if ( quickActionCancelDownload ) {
				[shortcutItems addObject: shortcutItem];
			}
			if ( quickActionCancelDownloadTitle.length > 0 ) {
				shortcutItem.localizedTitle = quickActionCancelDownloadTitle;
			}
			if ( quickActionCancelDownloadSubtitle.length > 0 ) {
				shortcutItem.localizedSubtitle = quickActionCancelDownloadSubtitle;
			}
			continue;
		}
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.prioritize-download"] ) {
			if ( quickActionPrioritizeDownload ) {
				[shortcutItems addObject: shortcutItem];
			}
			if ( quickActionPrioritizeDownloadTitle.length > 0 ) {
				shortcutItem.localizedTitle = quickActionPrioritizeDownloadTitle;
			}
			if ( quickActionPrioritizeDownloadSubtitle.length > 0 ) {
				shortcutItem.localizedSubtitle = quickActionPrioritizeDownloadSubtitle;
			}
			continue;
		}
//	dock app quick actions
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shotcut-item.hide-app"] ) {
			if ( quickActionHideApp ) {
				[shortcutItems addObject: shortcutItem];
			}
			if ( quickActionHideAppTitle.length > 0 ) {
				shortcutItem.localizedTitle = quickActionHideAppTitle;
			}
			if ( quickActionHideAppSubtitle.length > 0 ) {
				shortcutItem.localizedSubtitle = quickActionHideAppSubtitle;
			}
			continue;
		}
//	every other app quick actions and also quick actions made by other tweaks
		BOOL appSpecificQuickActions = [[tweakSettings objectForKey:[NSString stringWithFormat:@"appSpecificQuickActions-%@", bundleId]] boolValue];
		if ( !enableTweak ) {
			[shortcutItems addObject:shortcutItem];
		} else if ( [tweakSettings objectForKey:[NSString stringWithFormat:@"appSpecificQuickActions-%@", bundleId]] == nil ) {
			[shortcutItems addObject:shortcutItem];
		} else if ( enableTweak && appSpecificQuickActions ) {
			[shortcutItems addObject:shortcutItem];
		}
	}
	if ( enableTweak && copyBundleID ) {
		if (bundleId) {
			SBSApplicationShortcutItem *bundleIdAction = [%c(SBSApplicationShortcutItem) alloc];
			bundleIdAction.type = @"com.tomaszpoliszuk.springboardhome.application-shotcut-item.copy-bundle-id";
			if ( [copyBundleIDTitle isEqual:@"bundleID"] ) {
				bundleIdAction.localizedTitle = bundleId;
			} else if ( copyBundleIDTitle.length > 0 ) {
				bundleIdAction.localizedTitle = copyBundleIDTitle;
			}
			if ( [copyBundleIDSubtitle isEqual:@"bundleID"] ) {
				bundleIdAction.localizedSubtitle = bundleId;
			} else if ( copyBundleIDSubtitle.length > 0 ) {
				bundleIdAction.localizedSubtitle = copyBundleIDSubtitle;
			}
			[shortcutItems addObject: bundleIdAction];
		}
	}
	%orig(shortcutItems);
}
- (bool)shouldActivateApplicationShortcutItem:(SBSApplicationShortcutItem*)item atIndex:(unsigned long long)arg2 {
	NSString* bundleId;
	if([self respondsToSelector:@selector(applicationBundleIdentifierForShortcuts)]) {
		bundleId = [self applicationBundleIdentifierForShortcuts];
	}
	BOOL origValue = %orig;
	if([[item type] isEqualToString:@"com.tomaszpoliszuk.springboardhome.application-shotcut-item.copy-bundle-id"]) {
		[UIPasteboard generalPasteboard].string = bundleId;
		return NO;
	} else {
		return origValue;
	}
}
%end

//	app quick actions
%hook SBHHomeScreenSettings
-(bool)showWidgets {
	bool origValue = %orig;
	if ( enableTweak ) {
		return quickActionWidget;
	} else {
		return origValue;
	}
}
%end

%hook _UIContextMenuActionsListView
- (bool)reversesActionOrder {
	bool origValue = %orig;
	if ( enableTweak ) {
		return reverseQuickActionsOrder;
	} else {
		return origValue;
	}
}
%new
-(void)updateTraitOverride {
	if ( enableTweak && uiStyle > 0) {
		[self setOverrideUserInterfaceStyle:uiStyle];
	}
}
-(void)didMoveToWindow {
	if ( enableTweak && uiStyle > 0) {
		[self setOverrideUserInterfaceStyle:uiStyle];
	}
	%orig;
}
%end

%hook SBHIconViewContextMenuWrapperViewController
%new
-(void)updateTraitOverride {
	if ( enableTweak && uiStyle > 0) {
		[self setOverrideUserInterfaceStyle:uiStyle];
	}
}
-(id)init {
	if ((self = %orig)) {
		if ( enableTweak && uiStyle > 0) {
			[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateTraitOverride) name:@"com.tomaszpoliszuk.selectiveuistyle.override" object:nil];
			[self setOverrideUserInterfaceStyle:uiStyle];
		}
	}
	return self;
}
-(void)viewDidLoad {
	if ( enableTweak && uiStyle > 0) {
		[self setOverrideUserInterfaceStyle:uiStyle];
	}
	%orig;
}
%end


%ctor {
// Found in https://github.com/EthanRDoesMC/Dawn/commit/847cb5192dae9138a893e394da825e86be561a6b
	if ( [[[[NSProcessInfo processInfo] arguments] objectAtIndex:0] containsString:@"SpringBoard.app"] ) {
		TweakSettingsChanged();
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)TweakSettingsChanged, CFSTR("com.tomaszpoliszuk.homescreenquickactions.settingschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
		%init; // == %init(_ungrouped);
	}
}
