//
//  JMActionSheet.m
//  CoreLib
//
//  Created by CoreCode on 03.12.11.
/*	Copyright © 2019 CoreCodeLimited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "JMActionSheet.h"

@interface JMActionSheet ()

@property (weak, nonatomic) UIViewController *viewController;

@end



@implementation JMActionSheet

@synthesize cancelBlock, alternativeBlock, destructiveBlock;


+ (instancetype _Nonnull )actionSheetWithTitle:(nullable NSString *)title
                                viewController:(UIViewController *_Nonnull)viewController
                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                             otherButtonTitles:(nullable NSArray <NSString *> *)otherButtonTitles
{

    JMActionSheet *actionSheet = [JMActionSheet alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    actionSheet.viewController = viewController;

    if (cancelButtonTitle)
        [actionSheet addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
        {
            [actionSheet cancelButtonClicked];
            [viewController dismissViewControllerAnimated:YES completion:^
            {
            }];
        }]];

    if (destructiveButtonTitle)
        [actionSheet addAction:[UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
        {
            [actionSheet destuctiveButtonClicked];
            [viewController dismissViewControllerAnimated:YES completion:^
             {
             }];
        }]];

    if (otherButtonTitles)
    {
        for (NSUInteger i = 0; i < otherButtonTitles.count; i++)
        {
            NSString *otherButtonTitle = otherButtonTitles[i];

            [actionSheet addAction:[UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
            {
                [actionSheet otherButtonClicked:(int)i];
                [viewController dismissViewControllerAnimated:YES completion:^
                 {
                 }];
            }]];
        }
    }

    return actionSheet;
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

#pragma mark action methods


- (void)cancelButtonClicked
{
    if (self.cancelBlock)
        self.cancelBlock();
}

- (void)destuctiveButtonClicked
{
    if (self.destructiveBlock)
        self.destructiveBlock();
}

- (void)otherButtonClicked:(int)buttonIndex
{
    if (self.alternativeBlock)
        self.alternativeBlock(buttonIndex);
}

@end
