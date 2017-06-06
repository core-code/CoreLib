//
//  JMChoiceController.h
//  CoreLib
//
//  Created by CoreCode on 13.08.12.
/*	Copyright © 2017 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

@interface JMChoiceController : UITableViewController <UIPopoverControllerDelegate>

- (id)initWithCompletionBlock:(void (^)(NSString *choice, NSInteger index))completionBlock;

@property (assign, nonatomic) CGFloat minWidth;
@property (assign, nonatomic) CGFloat maxWidth;
@property (assign, nonatomic) BOOL canRemove;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) NSString *topTitle;

@property (copy, nonatomic) NSArray *choices;
@property (copy, nonatomic) NSArray *detail;
@property (copy, nonatomic) void (^completionBlock)(NSString *choice, NSInteger index);
@property (copy, nonatomic) void (^dismissBlock)(void);
@property (copy, nonatomic) void (^deleteBlock)(NSString *choice, NSInteger index);

@end
