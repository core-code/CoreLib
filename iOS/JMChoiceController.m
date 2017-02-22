//
//  JMChoiceController.m
//  CoreLib
//
//  Created by CoreCode on 13.08.12.
/*	Copyright © 2017 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMChoiceController.h"

@implementation JMChoiceController

- (id)init
{
    return [self initWithCompletionBlock:nil];
}

- (id)initWithCompletionBlock:(void (^)(NSString *choice, NSInteger index))completionBlock
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.completionBlock = completionBlock;
        self.minWidth = 320;
        self.maxWidth = 320;
        self.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.tableView.delegate = self;
    self.title = self.topTitle;

    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    CGFloat ourWidth;
    
    if (IS_DOUBLE_EQUAL((double)self.minWidth,(double)self.maxWidth))
        ourWidth = self.minWidth;
    else
    {
        CGFloat max = 0;
        
        for (NSString *entry in self.choices)
        {
            CGSize s = [entry sizeWithAttributes:@{NSFontAttributeName: self.font}];
            if (s.width > max)
                max = s.width;
        }
        
        ourWidth = CLAMP(max+20, self.minWidth, self.maxWidth);
    }
	self.preferredContentSize = (CGSize){ourWidth, [self.choices count] * 44};

//	self.tableView.backgroundColor = [UIColor colorWithWhite:230.0f / 255.0f alpha:1.0f];
}

- (void)viewWillDisappear:(BOOL)animated
{   
	 if (self.dismissBlock)
    {
        self.dismissBlock();
    }
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark *** UITableViewDataSource protocol-methods ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.choices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:(self.detail ? UITableViewCellStyleValue1 : UITableViewCellStyleDefault)
								      reuseIdentifier:CellIdentifier];
#if ! __has_feature(objc_arc)
		[cell autorelease];
#endif
    }



    cell.textLabel.font = self.font;
    cell.textLabel.text = makeString(@"%@", [self.choices objectAtIndex:indexPath.row]);
    if (self.detail)
        cell.detailTextLabel.text = (self.detail)[indexPath.row];


	return cell;
}

#pragma mark *** UITableViewDelegate protocol-methods ***

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.completionBlock)
    {
        NSString *choice = [self.choices objectAtIndex:indexPath.row];

        self.completionBlock(choice, indexPath.row);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.canRemove;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *choice = [self.choices objectAtIndex:indexPath.row];

        self.deleteBlock(choice, indexPath.row);
    }
}

#pragma mark - UIPopoverController delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (self.dismissBlock)
    {
        self.dismissBlock();
    }
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    self.font = nil;
    self.topTitle = nil;
    self.choices = nil;
    self.detail = nil;
    self.completionBlock = nil;
    self.dismissBlock = nil;
    self.deleteBlock = nil;

    [super dealloc];
}
#endif

@end
