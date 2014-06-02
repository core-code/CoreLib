#ifdef NS_AVAILABLE
#error must include before Cocoa/Foundation/ObjCRuntime
#endif

#import <Foundation/NSObjCRuntime.h>

#ifndef MAC_OS_X_VERSION_MIN_REQUIRED
#error no deployment target set
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-macros"

#if MAC_OS_X_VERSION_MIN_REQUIRED < 1070
#undef  AVAILABLE_MAC_OS_X_VERSION_10_7_AND_LATER
#define AVAILABLE_MAC_OS_X_VERSION_10_7_AND_LATER __attribute__((weak_import,deprecated("API is newer than Deployment Target.")))
#endif
#if MAC_OS_X_VERSION_MIN_REQUIRED < 1080
#undef  AVAILABLE_MAC_OS_X_VERSION_10_8_AND_LATER
#define AVAILABLE_MAC_OS_X_VERSION_10_8_AND_LATER __attribute__((weak_import,deprecated("API is newer than Deployment Target.")))
#endif
#if MAC_OS_X_VERSION_MIN_REQUIRED < 1090
#undef  AVAILABLE_MAC_OS_X_VERSION_10_9_AND_LATER
#define AVAILABLE_MAC_OS_X_VERSION_10_9_AND_LATER __attribute__((weak_import,deprecated("API is newer than Deployment Target.")))
#endif
#if MAC_OS_X_VERSION_MIN_REQUIRED < 101000
#undef  AVAILABLE_MAC_OS_X_VERSION_10_10_AND_LATER
#define AVAILABLE_MAC_OS_X_VERSION_10_10_AND_LATER __attribute__((weak_import,deprecated("API is newer than Deployment Target.")))
#endif

#define AVAILABLE_MAC_OS_X_VERSION_NSURLSESSION_AVAILABLE_AND_LATER AVAILABLE_MAC_OS_X_VERSION_10_7_AND_LATER
#define AVAILABLE_MAC_OS_X_VERSION_NA_AND_LATER __attribute__((weak_import,deprecated("API unavailable.")))


#undef  NS_CLASS_AVAILABLE
#define NS_CLASS_AVAILABLE(_mac, _ios) AVAILABLE_MAC_OS_X_VERSION_##_mac##_AND_LATER
#undef NS_AVAILABLE_MAC
#define NS_AVAILABLE_MAC(_mac) AVAILABLE_MAC_OS_X_VERSION_##_mac##_AND_LATER
#undef NS_AVAILABLE
#define NS_AVAILABLE(_mac, ...) AVAILABLE_MAC_OS_X_VERSION_##_mac##_AND_LATER

#pragma clang diagnostic pop
