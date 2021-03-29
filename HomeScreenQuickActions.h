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


static NSOperatingSystemVersion iOSversion = [[NSProcessInfo processInfo] operatingSystemVersion];
static NSString *const domainString = @"com.tomaszpoliszuk.homescreenquickactions";

#define userSettingsFile @"/var/mobile/Library/Preferences/com.tomaszpoliszuk.homescreenquickactions.plist"
#define packageName "com.tomaszpoliszuk.homescreenquickactions"


@interface UIView (HomeScreenQuickActions)
-(id)_viewControllerForAncestor;
@end

@interface SBFWindow : UIWindow
@end
@interface SBWindow : SBFWindow
@end
@interface SBMainScreenActiveInterfaceOrientationWindow : SBWindow
- (id)sb_rootViewController;
@end

@interface UIApplication (HomeScreenQuickActions)
- (void)applicationOpenURL:(id)arg1;
- (bool)launchApplicationWithIdentifier:(id)arg1 suspended:(bool)arg2;
@end

@interface UIImage (HomeScreenQuickActions)
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3;
@end

@interface UIWebClip : NSObject
@property (nonatomic, retain) NSURL *pageURL;
@property (nonatomic, readonly, retain) UIImage *iconImage;
@end

@interface SBIcon : NSObject
@property (nonatomic, readonly, copy) NSString *displayName;
@property (nonatomic, readonly) long long badgeValue;
- (bool)isApplicationIcon;
- (bool)isBookmarkIcon;
- (bool)isWidgetIcon;
- (bool)isWidgetStackIcon;
- (id)applicationBundleID;
@end

@interface SBLeafIcon : SBIcon
@end

@interface SBBookmarkIcon : SBLeafIcon
@property (nonatomic, readonly) UIWebClip *webClip;
@end

@interface SBFolder : NSObject
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, readonly, copy) NSArray *icons;
@end

@interface SBFolderIcon : SBIcon
@property (nonatomic, readonly) SBFolder *folder;
@end

@interface SBIconView : UIView
@property (nonatomic, retain) SBIcon *icon;
@property (nonatomic, retain) SBFolderIcon *folderIcon;
@property (nonatomic, readonly, copy) NSString *applicationBundleIdentifierForShortcuts;
- (bool)isFolderIcon;
- (long long)displayedLabelAccessoryType;
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

@interface SBSApplicationShortcutIcon : NSObject
@end
@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
- (id)initWithSystemImageName:(id)arg1;
@end

@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
- (id)initWithImageData:(id)arg1 dataType:(long long)arg2 isTemplate:(bool)arg3;
@end

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) SBSApplicationShortcutIcon *icon;
@end

@interface _LSQueryResult : NSObject
@end
@interface LSResourceProxy : _LSQueryResult
@end
@interface LSBundleProxy : LSResourceProxy
@property (nonatomic, readonly) NSURL *bundleURL;
@property (nonatomic, readonly) NSURL *dataContainerURL;
@end
@interface LSApplicationProxy : LSBundleProxy
@property (readonly) NSString * applicationType;
@property (nonatomic, readonly) NSNumber *staticDiskUsage;
@property (nonatomic, readonly) NSNumber *dynamicDiskUsage;
@property (nonatomic, readonly) NSString *applicationIdentifier;
@property (getter=isDeletable, nonatomic, readonly) bool deletable;
@property (getter=isInstalled, nonatomic, readonly) bool installed;
@property (setter=_setLocalizedName:, nonatomic, copy) NSString *localizedName;
+ (id)applicationProxyForIdentifier:(id)arg1;
@end

@interface LSApplicationWorkspace : NSObject
+ (id)defaultWorkspace;
- (id)allApplications;
@end

@interface IXAppInstallCoordinator : NSObject
+ (void)demoteAppToPlaceholderWithBundleID:(id)arg1 forReason:(unsigned long long)arg2 waitForDeletion:(bool)arg3 completion:(id /* block */)arg4;
@end

@interface SBApplication : NSObject
@property (nonatomic, copy) id badgeValue;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(id)arg1;
@end

@interface SBFTouchPassThroughViewController : UIViewController
@end
@interface SBFloatingDockViewController : SBFTouchPassThroughViewController
@end

@interface SBFloatingDockController : NSObject
@property (nonatomic, readonly) SBFloatingDockViewController *floatingDockViewController;
- (void)_dismissFloatingDockIfPresentedAnimated:(bool)arg1 completionHandler:(id /* block */)arg2;
- (void)_presentFloatingDockIfDismissedAnimated:(bool)arg1 completionHandler:(id /* block */)arg2;
@end

@interface SBHIconManager : NSObject
@property (nonatomic, retain) SBFloatingDockViewController *floatingDockViewController;
- (bool)isFloatingDockVisible;
@end

@interface SBIconController : UIViewController
@property (nonatomic, readonly) SBHIconManager *iconManager;
@property (nonatomic, readonly) SBFloatingDockController *floatingDockController;
@end
