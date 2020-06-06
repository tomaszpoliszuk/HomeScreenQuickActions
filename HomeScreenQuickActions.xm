#define SettingsChangedNotification "com.tomaszpoliszuk.homescreenquickactions/TweakSettingsChanged"
#define UserSettingsFile @"/var/mobile/Library/Preferences/com.tomaszpoliszuk.homescreenquickactions.plist"
#define PackageName "com.tomaszpoliszuk.homescreenquickactions"

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, retain) NSString *type;
@end

@interface PTSettings : NSObject
@end

@interface SBHHomeScreenSettings : PTSettings {}
- (bool)showWidgets;
@end

NSMutableDictionary *TweakSettings;

//	enable tweak
static BOOL EnableTweak;

//	global quick actions:
static BOOL QuickActionEditHomeScreen;

//	folders quick actions:
static BOOL QuickActionRenameFolder;

//	app quick actions
static BOOL QuickActionWidget;

//	app store apps quick actions:
static BOOL QuickActionShare;
static BOOL QuickActionDelete;

//	app quick actions visible while app is downloading from app store
static BOOL QuickActionPauseDownload;
static BOOL QuickActionCancelDownload;
static BOOL QuickActionPrioritizeDownload;

//	dock app quick actions
static BOOL QuickActionHideApp;

void TweakSettingsChanged() {
	CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR(PackageName), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if(keyList) {
		TweakSettings = (NSMutableDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, CFSTR(PackageName), kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
		CFRelease(keyList);
	} else {
		TweakSettings = nil;
	}
	if (!TweakSettings) {
		TweakSettings = [NSMutableDictionary dictionaryWithContentsOfFile:UserSettingsFile];
	}

//	enable tweak
	EnableTweak = [([TweakSettings objectForKey:@"EnableTweak"] ?: @(NO)) boolValue];

//	global quick actions:
	QuickActionEditHomeScreen = [([TweakSettings objectForKey:@"QuickActionEditHomeScreen"] ?: @(NO)) boolValue];

//	folders quick actions:
	QuickActionRenameFolder = [([TweakSettings objectForKey:@"QuickActionRenameFolder"] ?: @(NO)) boolValue];

//	app quick actions
	QuickActionWidget = [([TweakSettings objectForKey:@"QuickActionWidget"] ?: @(NO)) boolValue];

//	app store apps quick actions:
	QuickActionShare = [([TweakSettings objectForKey:@"QuickActionShare"] ?: @(NO)) boolValue];
	QuickActionDelete = [([TweakSettings objectForKey:@"QuickActionDelete"] ?: @(NO)) boolValue];

//	app quick actions visible while app is downloading from app store
	QuickActionPauseDownload = [([TweakSettings objectForKey:@"QuickActionPauseDownload"] ?: @(NO)) boolValue];
	QuickActionCancelDownload = [([TweakSettings objectForKey:@"QuickActionCancelDownload"] ?: @(NO)) boolValue];
	QuickActionPrioritizeDownload = [([TweakSettings objectForKey:@"QuickActionPrioritizeDownload"] ?: @(NO)) boolValue];

//	dock app quick actions
	QuickActionHideApp = [([TweakSettings objectForKey:@"QuickActionHideApp"] ?: @(NO)) boolValue];

	[[NSNotificationCenter defaultCenter] postNotificationName:@SettingsChangedNotification object:nil userInfo:nil];
}

%hook SBIconView
-(void)setApplicationShortcutItems:(NSArray *)arg1 {
	NSMutableArray *shortcutItems = [[NSMutableArray alloc] init];
	for (SBSApplicationShortcutItem *shortcutItem in arg1) {

//	global quick actions:
		if ( EnableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shotcut-item.rearrange-icons"] ) {
			if ( QuickActionEditHomeScreen ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}

//	folders quick actions:
		if ( EnableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.rename-folder"] ) {
			if ( QuickActionRenameFolder ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}

//	app store apps quick actions:
		if ( EnableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.share"] ) {
			if ( QuickActionShare ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}
		if ( EnableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shotcut-item.delete-app"] ) {
			if ( QuickActionDelete ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}

//	app quick actions visible while app is downloading from app store
		if ( EnableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.pause-download"] ) {
			if ( QuickActionPauseDownload ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}
		if ( EnableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.cancel-download"] ) {
			if ( QuickActionCancelDownload ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}
		if ( EnableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shortcut-item.prioritize-download"] ) {
			if ( QuickActionPrioritizeDownload ) {
				[shortcutItems addObject: shortcutItem];
			}
			continue;
		}

//	dock app quick actions
		if ( EnableTweak && [shortcutItem.type isEqual: @"com.apple.springboardhome.application-shotcut-item.hide-app"] ) {
			if ( QuickActionHideApp ) {
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
	if ( EnableTweak ) {
		return QuickActionWidget;
	} else {
		return %orig;
	}
}
%end

%ctor {
	TweakSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:UserSettingsFile];
	TweakSettingsChanged();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)TweakSettingsChanged, CFSTR(SettingsChangedNotification), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	%init; // == %init(_ungrouped);
}
