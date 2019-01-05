//
//  JMActionSheet.h
//  CoreLib
//
//  Created by CoreCode on 03.12.11.
/*	Copyright © 2019 CoreCodeLimited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "CoreLib.h"


@interface JMActionSheet : UIAlertController

+ (instancetype _Nonnull )actionSheetWithTitle:(nullable NSString *)title
                                viewController:(UIViewController *_Nonnull)viewController
                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                             otherButtonTitles:(nullable NSArray <NSString *> *)otherButtonTitles;

@property (copy, nonatomic) BasicBlock _Nullable cancelBlock;
@property (copy, nonatomic) BasicBlock _Nullable destructiveBlock;
@property (copy, nonatomic) IntInBlock _Nullable alternativeBlock;


- (void)showFromToolbar:(UIToolbar *_Nonnull)view;
- (void)showFromTabBar:(UITabBar *_Nonnull)view;
- (void)showFromBarButtonItem:(UIBarButtonItem *_Nonnull)item animated:(BOOL)animated;
- (void)showFromRect:(CGRect)rect inView:(UIView *_Nonnull)view animated:(BOOL)animated;
- (void)showInView:(UIView *_Nonnull)view;

@end
