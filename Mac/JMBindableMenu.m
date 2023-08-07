//
//  JMBindableMenu.m
//  CoreLib
//
//  Created by CoreCode on 03.05.23
/*    Copyright © 2023 CoreCodeLimited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMBindableMenu.h"

@interface JMBindableMenu ()

@property (strong, atomic) NSArray <NSString *> *menuTitles;

@end


@implementation JMBindableMenu

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self addObserver:self forKeyPath:@"menuTitles" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"menuTitles"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"menuTitles"])
    {
        dispatch_async_main(^ // we could be called on-non-main depending on where the value is changed
        {
            [self refreshMenu];
        });
    }
}

- (void)refreshMenu
{
    [self removeAllItems];
    
    NSMenu *sm = self.supermenu;
    NSMenuItem *aboveParent;
    NSMenuItem *parent;
    for (NSMenuItem *it in sm.itemArray)
    {
        if (it.submenu == self)
        {
            parent = it;
            break;
        }
        aboveParent = it;
    }
    
    int i = 1;
    
    if (self.firstMenuItemName.length)
    {
        NSMenuItem *item = [NSMenuItem new];
        item.title = self.firstMenuItemName;
        [self addItem:item];
    }
        
    for (NSString *name in self.menuTitles)
    {
        
        NSMenuItem *item = [NSMenuItem new];
        item.title = name;
        item.enabled = YES;
        
        // implicit behaviour: if the item above our menu has a numbered shortcut, continue with subsequent numbers
        if (aboveParent.keyEquivalent.intValue > 0 && aboveParent.keyEquivalent.intValue < 10)
        {
            let higherNumber = aboveParent.keyEquivalent.intValue + i;
            if (higherNumber < 10)
            {
                item.keyEquivalent = @(higherNumber).stringValue;
                item.keyEquivalentModifierMask = aboveParent.keyEquivalentModifierMask;
            }
        }

        
        // implicit behaviour: use action from parent
        item.action = parent.action;
        item.target = parent.target;
        
        // implicit behaviour: use subsequent tags to parent for our menu items
        item.tag = parent.tag + i++;
        

        [self addItem:item];
    }
    
    // disabling the menu will only work in case the supermenu has autoenables false
    let shouldBeEnabled = (BOOL)(self.menuTitles.count > 0);
    parent.enabled = shouldBeEnabled;
}


@end
