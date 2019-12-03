//
//  JMValueTransormer.m
//  CoreLib
//
//  Created by CoreCode on 12.03.12.
/*    Copyright © 2019 CoreCode Limited
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMValueTransformer.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-messaging-id"

@implementation InvalidEmailValueTransformer

+ (BOOL)allowsReverseTransformation { return NO; }
+ (Class)transformedValueClass { return [NSNumber class]; }

- (id)transformedValue:(id)value
{
    NSString *stringValue = value;
    if (!stringValue || ![stringValue respondsToSelector:@selector(isValidEmail)] || !stringValue.isValidEmails)
        return @TRUE;
    
    return @FALSE;
}
@end

@implementation ValidEmailValueTransformer

+ (BOOL)allowsReverseTransformation { return NO; }
+ (Class)transformedValueClass { return [NSNumber class]; }

- (id)transformedValue:(id)value
{
    NSString *stringValue = value;
    if (!stringValue || ![stringValue respondsToSelector:@selector(isValidEmail)] || !stringValue.isValidEmails)
        return @FALSE;

    return @TRUE;
}
@end

@implementation EmptyArrayValueTransformer
+ (BOOL)allowsReverseTransformation { return NO; }
+ (Class)transformedValueClass { return [NSNumber class]; }

- (id)transformedValue:(id)value
{
    if (!value || ![(NSObject *)value respondsToSelector:@selector(count)] || (((NSArray *) value).count))
        return @FALSE;
 
    return @TRUE;
}
@end

@implementation NonemptyArrayValueTransformer
+ (BOOL)allowsReverseTransformation { return NO; }
+ (Class)transformedValueClass { return [NSNumber class]; }

- (id)transformedValue:(id)value
{
    if (!value || ![(NSObject *)value respondsToSelector:@selector(count)] || (!((NSArray *) value).count))
        return @FALSE;
    
    return @TRUE;
}
@end

@implementation BaseValueTransformer
+ (BOOL)allowsReverseTransformation { return NO; }
+ (Class)transformedValueClass { return [NSNumber class]; }
+ (void)initialize
{
    Class class = [self class];
    NSString *className = NSStringFromClass(class);
    id obj = [[class alloc] init];

    [NSValueTransformer setValueTransformer:obj forName:className];
}
@end


@implementation OddValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] % 2 == 1); }
@end
@implementation EvenValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] % 2 == 0); }
@end



@interface NumericComparisonValueTransformer ()
@property (assign, nonatomic) NSInteger comparisonValue;
@end

@implementation NumericComparisonValueTransformer
- (instancetype)init
{
    if ((self = [super init]))
    {
        NSString *className = NSStringFromClass([self class]);
        className = [className stringByTrimmingLeadingCharactersInSet:[NSCharacterSet letterCharacterSet]];
        className = [className stringByTrimmingTrailingCharactersInSet:[NSCharacterSet letterCharacterSet]];
        self.comparisonValue = className.intValue;
    }
    return self;
}
@end


@implementation SmallerthanValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] < self.comparisonValue); }
@end
@implementation LargerthanValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] > self.comparisonValue); }
@end
@implementation EqualtoValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] == self.comparisonValue); }
@end
@implementation DifferenttoValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] != self.comparisonValue); }
@end



COMPARISONTRANSFORMERS_IMPLEMENTATION(0)
COMPARISONTRANSFORMERS_IMPLEMENTATION(1)
COMPARISONTRANSFORMERS_IMPLEMENTATION(2)
COMPARISONTRANSFORMERS_IMPLEMENTATION(3)
COMPARISONTRANSFORMERS_IMPLEMENTATION(4)
COMPARISONTRANSFORMERS_IMPLEMENTATION(5)
COMPARISONTRANSFORMERS_IMPLEMENTATION(6)
COMPARISONTRANSFORMERS_IMPLEMENTATION(7)
COMPARISONTRANSFORMERS_IMPLEMENTATION(8)
COMPARISONTRANSFORMERS_IMPLEMENTATION(9)
COMPARISONTRANSFORMERS_IMPLEMENTATION(10)
COMPARISONTRANSFORMERS_IMPLEMENTATION(11)
COMPARISONTRANSFORMERS_IMPLEMENTATION(12)
COMPARISONTRANSFORMERS_IMPLEMENTATION(13)
COMPARISONTRANSFORMERS_IMPLEMENTATION(14)
COMPARISONTRANSFORMERS_IMPLEMENTATION(15)
COMPARISONTRANSFORMERS_IMPLEMENTATION(16)
COMPARISONTRANSFORMERS_IMPLEMENTATION(17)
COMPARISONTRANSFORMERS_IMPLEMENTATION(18)
COMPARISONTRANSFORMERS_IMPLEMENTATION(19)
COMPARISONTRANSFORMERS_IMPLEMENTATION(20)
COMPARISONTRANSFORMERS_IMPLEMENTATION(21)
COMPARISONTRANSFORMERS_IMPLEMENTATION(22)
COMPARISONTRANSFORMERS_IMPLEMENTATION(23)
COMPARISONTRANSFORMERS_IMPLEMENTATION(24)
COMPARISONTRANSFORMERS_IMPLEMENTATION(25)
COMPARISONTRANSFORMERS_IMPLEMENTATION(26)
COMPARISONTRANSFORMERS_IMPLEMENTATION(27)
COMPARISONTRANSFORMERS_IMPLEMENTATION(28)
COMPARISONTRANSFORMERS_IMPLEMENTATION(29)
COMPARISONTRANSFORMERS_IMPLEMENTATION(30)
COMPARISONTRANSFORMERS_IMPLEMENTATION(31)
COMPARISONTRANSFORMERS_IMPLEMENTATION(32)
COMPARISONTRANSFORMERS_IMPLEMENTATION(33)
COMPARISONTRANSFORMERS_IMPLEMENTATION(34)
COMPARISONTRANSFORMERS_IMPLEMENTATION(35)
COMPARISONTRANSFORMERS_IMPLEMENTATION(36)
COMPARISONTRANSFORMERS_IMPLEMENTATION(37)
COMPARISONTRANSFORMERS_IMPLEMENTATION(38)
COMPARISONTRANSFORMERS_IMPLEMENTATION(39)
COMPARISONTRANSFORMERS_IMPLEMENTATION(40)
COMPARISONTRANSFORMERS_IMPLEMENTATION(41)
COMPARISONTRANSFORMERS_IMPLEMENTATION(42)
COMPARISONTRANSFORMERS_IMPLEMENTATION(43)
COMPARISONTRANSFORMERS_IMPLEMENTATION(44)
COMPARISONTRANSFORMERS_IMPLEMENTATION(45)
COMPARISONTRANSFORMERS_IMPLEMENTATION(46)
COMPARISONTRANSFORMERS_IMPLEMENTATION(47)
COMPARISONTRANSFORMERS_IMPLEMENTATION(48)
COMPARISONTRANSFORMERS_IMPLEMENTATION(49)
COMPARISONTRANSFORMERS_IMPLEMENTATION(50)
COMPARISONTRANSFORMERS_IMPLEMENTATION(51)
COMPARISONTRANSFORMERS_IMPLEMENTATION(52)
COMPARISONTRANSFORMERS_IMPLEMENTATION(53)
COMPARISONTRANSFORMERS_IMPLEMENTATION(54)
COMPARISONTRANSFORMERS_IMPLEMENTATION(55)
COMPARISONTRANSFORMERS_IMPLEMENTATION(56)
COMPARISONTRANSFORMERS_IMPLEMENTATION(57)
COMPARISONTRANSFORMERS_IMPLEMENTATION(58)
COMPARISONTRANSFORMERS_IMPLEMENTATION(59)
COMPARISONTRANSFORMERS_IMPLEMENTATION(60)
COMPARISONTRANSFORMERS_IMPLEMENTATION(61)
COMPARISONTRANSFORMERS_IMPLEMENTATION(62)
COMPARISONTRANSFORMERS_IMPLEMENTATION(63)
COMPARISONTRANSFORMERS_IMPLEMENTATION(64)
COMPARISONTRANSFORMERS_IMPLEMENTATION(65)
COMPARISONTRANSFORMERS_IMPLEMENTATION(66)
COMPARISONTRANSFORMERS_IMPLEMENTATION(67)
COMPARISONTRANSFORMERS_IMPLEMENTATION(68)
COMPARISONTRANSFORMERS_IMPLEMENTATION(69)
COMPARISONTRANSFORMERS_IMPLEMENTATION(70)
COMPARISONTRANSFORMERS_IMPLEMENTATION(71)
COMPARISONTRANSFORMERS_IMPLEMENTATION(72)
COMPARISONTRANSFORMERS_IMPLEMENTATION(73)
COMPARISONTRANSFORMERS_IMPLEMENTATION(74)
COMPARISONTRANSFORMERS_IMPLEMENTATION(75)
COMPARISONTRANSFORMERS_IMPLEMENTATION(76)
COMPARISONTRANSFORMERS_IMPLEMENTATION(77)
COMPARISONTRANSFORMERS_IMPLEMENTATION(78)
COMPARISONTRANSFORMERS_IMPLEMENTATION(79)
COMPARISONTRANSFORMERS_IMPLEMENTATION(80)
COMPARISONTRANSFORMERS_IMPLEMENTATION(81)
COMPARISONTRANSFORMERS_IMPLEMENTATION(82)
COMPARISONTRANSFORMERS_IMPLEMENTATION(83)
COMPARISONTRANSFORMERS_IMPLEMENTATION(84)
COMPARISONTRANSFORMERS_IMPLEMENTATION(85)
COMPARISONTRANSFORMERS_IMPLEMENTATION(86)
COMPARISONTRANSFORMERS_IMPLEMENTATION(87)
COMPARISONTRANSFORMERS_IMPLEMENTATION(88)
COMPARISONTRANSFORMERS_IMPLEMENTATION(89)
COMPARISONTRANSFORMERS_IMPLEMENTATION(90)
COMPARISONTRANSFORMERS_IMPLEMENTATION(91)
COMPARISONTRANSFORMERS_IMPLEMENTATION(92)
COMPARISONTRANSFORMERS_IMPLEMENTATION(93)
COMPARISONTRANSFORMERS_IMPLEMENTATION(94)
COMPARISONTRANSFORMERS_IMPLEMENTATION(95)
COMPARISONTRANSFORMERS_IMPLEMENTATION(96)
COMPARISONTRANSFORMERS_IMPLEMENTATION(97)
COMPARISONTRANSFORMERS_IMPLEMENTATION(98)
COMPARISONTRANSFORMERS_IMPLEMENTATION(99)

#pragma clang diagnostic pop
