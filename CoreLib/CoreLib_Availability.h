//
//  CoreLib_Availibility.h
//  CoreLib
//
//  Created by CoreCode on 02.06.14.
/*	Copyright (c) 2016 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#if ((__clang_major__) >= 8 || ((__clang_major__ == 7) && (__clang_major__ >= 3)))
 // we don't this need because xcode has it built in
#else
#ifdef NS_AVAILABLE
#error must include before Cocoa/Foundation/ObjCRuntime
#endif

#if __has_feature(modules)
#warning DOES NOT WORK WITH MODULES
#else

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
#if MAC_OS_X_VERSION_MIN_REQUIRED < 101100
#undef  AVAILABLE_MAC_OS_X_VERSION_10_11_AND_LATER
#define AVAILABLE_MAC_OS_X_VERSION_10_11_AND_LATER __attribute__((weak_import,deprecated("API is newer than Deployment Target.")))
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
#endif
#endif