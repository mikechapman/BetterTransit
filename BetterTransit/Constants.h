//
//  Constants.h
//  BetterTransit
//
//  Created by Yaogang Lian on 8/15/10.
//  Copyright 2010 Happen Next. All rights reserved.
//

#define AppDelegate (BTTransitDelegate *)[[UIApplication sharedApplication] delegate]

// Alert View Tags
#define TAG_BUY_ADS_FREE_VERSION 1

// Cell states
#define CELL_STATE_INITIALIZED 0
#define CELL_STATE_UPDATING 1
#define CELL_STATE_UPDATED 2

// Notification names
#define kStartUpdatingLocationNotification @"kStartUpdatingLocationNotification"
#define kDidUpdateToLocationNotification @"kDidUpdateToLocationNotification"
#define kDidFailToUpdateLocationNotification @"kDidFailToUpdateLocationNotification"
#define kLocationDidNotChangeNotification @"kLocationDidNotChangeNotification"
#define kRemoveAdsNotification @"kRemoveAdsNotification"

// Table view cell content offsets
#define kCellLeftOffset			12.0
#define kCellTopOffset			8.0
#define kCellHeight				22.0
#define kLabelFontSize			17

// List tags
#define TAG_LIST_STARTUP_SCREEN 0
#define TAG_LIST_MAX_NUM_NEARBY_STOPS   1

// Colors
#define COLOR_AD_REMOVAL [UIColor colorWithRed:0.639 green:0.851 blue:1.0 alpha:1.0]
//#define COLOR_AD_REMOVAL [UIColor colorWithRed:0.729 green:0.876 blue:1.0 alpha:1.0]
#define COLOR_DARK_RED [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0]

// NSUserDefault keys
#define KEY_STARTUP_SCREEN @"firstPage"
#define KEY_MAX_NUM_NEARBY_STOPS @"nearbyNumber"
#define KEY_LIFETIME_ADS_FREE @"KEY_LIFETIME_ADS_FREE"

// Misc.
#define kStringDelimitingCharacter		@"|||"
#define KEY_HAVE_SHOWN_TOOLTIP @"KEY_HAVE_SHOWN_TOOLTIP"

// Modes of view controllers
#define MODE_MODAL 0
#define MODE_PUSHED 1

// Download status
#define DOWNLOAD_STATUS_INIT 0
#define DOWNLOAD_STATUS_SUCCEEDED 1
#define DOWNLOAD_STATUS_FAILED 2
