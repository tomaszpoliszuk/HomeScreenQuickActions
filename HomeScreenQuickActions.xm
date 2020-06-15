@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *type;
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
NSMutableDictionary *tweakSettings;

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

static BOOL copyBundleID;

static int uiStyle;

void TweakSettingsChanged() {
	NSUserDefaults *tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:domainString];
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
			continue;
		}
//	folders quick actions:
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.rename-folder"] ) {
			if ( quickActionRenameFolder ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}
//	app store apps quick actions:
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.share"] ) {
			if ( quickActionShare ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shotcut-item.delete-app"] ) {
			if ( quickActionDelete ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}
//	app quick actions visible while app is downloading from app store
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.pause-download"] ) {
			if ( quickActionPauseDownload ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.cancel-download"] ) {
			if ( quickActionCancelDownload ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.prioritize-download"] ) {
			if ( quickActionPrioritizeDownload ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}
//	dock app quick actions
		if ( enableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shotcut-item.hide-app"] ) {
			if ( quickActionHideApp ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}
//	every other app quick actions and also quick actions made by other tweaks
		[shortcutItems addObject:shortcutItem];
	}
	if ( enableTweak && copyBundleID ) {
		if (bundleId) {
			SBSApplicationShortcutItem *bundleIdAction = [%c(SBSApplicationShortcutItem) alloc];
			[UIPasteboard generalPasteboard].string = bundleId;

			bundleIdAction.localizedTitle = @"Copy Bundle ID";
			bundleIdAction.localizedSubtitle = bundleId;
			bundleIdAction.type = @"com.tomaszpoliszuk.springboardhome.application-shotcut-item.copy-bundle-id";

			[shortcutItems addObject: bundleIdAction];
		}
	}
	%orig(shortcutItems);
}
- (bool)shouldActivateApplicationShortcutItem:(SBSApplicationShortcutItem*)item atIndex:(unsigned long long)arg2 {
	BOOL origValue = %orig;
	if([[item type] isEqualToString:@"com.tomaszpoliszuk.springboardhome.application-shotcut-item.copy-bundle-id"]) {
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
