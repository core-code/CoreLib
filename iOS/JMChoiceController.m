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
    
    float ourWidth;
    
    if (_minWidth == _maxWidth)
        ourWidth = _minWidth;
    else
    {
        float max = 0;
        
        for (NSString *entry in _choices)
        {
            CGSize s = [entry sizeWithFont:_font];
            if (s.width > max)
                max = s.width;
        }
        
        ourWidth = CLAMP(max+20, _minWidth, _maxWidth);
    }
	self.contentSizeForViewInPopover = (CGSize){ourWidth, [self.choices count] * 44};
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
    }

    tableView.backgroundColor = [UIColor colorWithWhite:230.0f / 255.0f alpha:1.0f];

    cell.textLabel.font = _font;
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
    return _canRemove;
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
@end