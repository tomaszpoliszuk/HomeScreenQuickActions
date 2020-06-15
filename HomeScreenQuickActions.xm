@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, retain) NSString *type;
@end

@interface PTSettings : NSObject
@end

@interface SBHHomeScreenSettings : PTSettings {}
- (bool)showWidgets;
@end

NSString *domainString = @"com.tomaszpoliszuk.homescreenquickactions";
NSMutableDictionary *tweakSettings;

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
}

%hook SBIconView
-(void)setApplicationShortcutItems:(NSArray *)arg1 {
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
	%orig(shortcutItems);
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

%ctor {
// Found in https://github.com/EthanRDoesMC/Dawn/commit/847cb5192dae9138a893e394da825e86be561a6b
	if ( [[[[NSProcessInfo processInfo] arguments] objectAtIndex:0] containsString:@"SpringBoard.app"] ) {
		TweakSettingsChanged();
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)TweakSettingsChanged, CFSTR("com.tomaszpoliszuk.homescreenquickactions.settingschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
		%init; // == %init(_ungrouped);
	}
}
