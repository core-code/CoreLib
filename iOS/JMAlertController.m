//
//  JMAlertController.m
//  CoreLib
//
//  Created by CoreCode on 21.12.11.
/*	Copyright © 2017 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "JMAlertController.h"



@interface JMAlertController ()

@property (unsafe_unretained, nonatomic) UIViewController *viewController;

@end



@implementation JMAlertController


+ (instancetype)localizedAlertWithName:(NSString *)name viewController:(UIViewController *_Nonnull)viewController
{
    NSMutableArray <NSString *>*otherButtonTitles = makeMutableArray();

	int i = 2;
	do
	{
		NSString *buttonKey = [name stringByAppendingFormat:@"_BUTTON%i", i++];
		NSString *localizedButton = [[NSBundle mainBundle] localizedStringForKey:buttonKey value:nil table:nil];

		if (!localizedButton)
			break;

		[otherButtonTitles addObject:NSLocalizedString(localizedButton, nil)];
	} while (true);


    JMAlertController *alert = [JMAlertController alertControllerWithTitle:NSLocalizedString([name stringByAppendingString:@"_TITLE"], nil)
                                                viewController:(UIViewController *_Nonnull)viewController
                                                       message:NSLocalizedString([name stringByAppendingString:@"_MESSAGE"], nil)
                                                   cancelBlock:nil
                                             cancelButtonTitle:NSLocalizedString([name stringByAppendingString:@"_BUTTON"], nil)
                                                    otherBlock:nil
                                             otherButtonTitles:otherButtonTitles];

#if ! __has_feature(objc_arc)
    [otherButtonTitles release];
#endif
	return alert;
}



+ (instancetype)alertControllerWithTitle:(NSString *)title
                           viewController:(UIViewController *_Nonnull)viewController
                                  message:(NSString *)message
                              cancelBlock:(BasicBlock)cancelBlock
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                               otherBlock:(IntInBlock)otherBlock
                        otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles
{

    JMAlertController *alert = [JMAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    if (alert)
    {
        alert.viewController = viewController;

        if (cancelButtonTitle)
            [alert addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                             {
                                 [alert cancelButtonClicked];

                                 [viewController dismissViewControllerAnimated:YES completion:^{}];
                             }]];



        if (otherButtonTitles)
        {
            for (NSUInteger i = 0; i < otherButtonTitles.count; i++)
            {
                NSString *otherButtonTitle = otherButtonTitles[i];

                [alert addAction:[UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [alert otherButtonClicked:(int)i];

                                     [viewController dismissViewControllerAnimated:YES completion:^{}];
                                 }]];
            }
        }
    }
    

    return alert;
}


- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    UIView *view = [item valueForKey:@"view"];

    self.popoverPresentationController.sourceView = view;

    [self.viewController presentViewController:self animated:animated completion:nil];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
    self.popoverPresentationController.sourceRect = rect;

    [self.viewController presentViewController:self animated:animated completion:nil];
}

- (void)showFromTabBar:(UITabBar *)view
{
    self.popoverPresentationController.sourceView = view;

    [self.viewController presentViewController:self animated:YES completion:nil];
}

- (void)showFromToolbar:(UIToolbar *)view
{
    self.popoverPresentationController.sourceView = view;

    [self.viewController presentViewController:self animated:YES completion:nil];

}

- (void)showInView:(UIView *)view
{
    self.popoverPresentationController.sourceView = view;

    [self.viewController presentViewController:self animated:YES completion:nil];
    
}


- (void)cancelButtonClicked
{
    if (self.cancelBlock)
        self.cancelBlock();
}


- (void)otherButtonClicked:(int)buttonIndex
{
    if (self.otherBlock)
        self.otherBlock(buttonIndex);
}


#if ! __has_feature(objc_arc)
- (void)dealloc
{
	self.cancelBlock = nil;
	self.otherBlock = nil;
	
	[super dealloc];
}
#endif
@end
