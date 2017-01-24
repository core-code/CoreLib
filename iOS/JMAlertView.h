//
//  JMAlertView.h
//  CoreLib
//
//  Created by CoreCode on 21.12.11.
/*	Copyright © 2017 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "CoreLib.h"


@interface JMAlertView : UIAlertView <UIAlertViewDelegate>

@property (copy, nonatomic) BasicBlock cancelBlock;
@property (copy, nonatomic) IntInBlock otherBlock;

+ (JMAlertView *)localizedAlertWithName:(NSString *)name;

- (JMAlertView *)initWithTitle:(NSString *)title
			message:(NSString *)message
		cancelBlock:(BasicBlock)cancelBlock
  cancelButtonTitle:(NSString *)cancelButtonTitle
		 otherBlock:(IntInBlock)otherBlock
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
