//
//  Constants.h
//  BetterTransit
//
//  Created by Yaogang Lian on 8/15/10.
//  Copyright 2010 Happen Next. All rights reserved.
//

#define AppDelegate (BTTransitDelegate *)[[UIApplication sharedApplication] delegate]

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

// List tags
#define TAG_LIST_STARTUP_SCREEN 0
#define TAG_LIST_MAX_NUM_NEARBY_STOPS   1

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
