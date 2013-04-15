@interface JMChoiceController : UITableViewController <UIPopoverControllerDelegate>

- (id)initWithCompletionBlock:(void (^)(NSString *choice, NSInteger index))completionBlock;

@property (assign, nonatomic) float minWidth;
@property (assign, nonatomic) float maxWidth;
@property (assign, nonatomic) BOOL canRemove;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) NSString *topTitle;

@property (copy, nonatomic) NSArray *choices;
@property (copy, nonatomic) NSArray *detail;
@property (copy, nonatomic) void (^completionBlock)(NSString *choice, NSInteger index);
@property (copy, nonatomic) void (^dismissBlock)();
@property (copy, nonatomic) void (^deleteBlock)(NSString *choice, NSInteger index);

@end
