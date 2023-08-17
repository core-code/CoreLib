//
//  JMBindableMenu.h
//  CoreLib
//
//  Created by CoreCode on 03.05.23
/*    Copyright © 2023 CoreCodeLimited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "CoreLib.h"


@interface JMBindableMenu : NSMenu

@property (strong, nonatomic) IBInspectable NSString * _Nullable firstMenuItemName;  // set only if you want a a fixed item above all those dynamic ones below


// better to use just those binding methods instead of -[NSObject bind:toObject:withKeyPath:options:] and -[NSObject unbind:] with @"menuTitles" so that possible forgotten unbinds can be tracked and fixed automatically
- (void)bindToObject:(id _Nonnull)observable withKeyPath:(NSString * _Nonnull)keyPath options:(nullable NSDictionary<NSBindingOption, id> *)options;
- (void)unbind;

@end
