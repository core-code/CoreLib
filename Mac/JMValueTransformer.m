//
//  JMValueTransormer.m
//  CoreLib
//
//  Created by CoreCode on 12.03.12.
/*	Copyright (c) 2014 CoreCode
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMValueTransformer.h"

@implementation BaseValueTransformer
+ (BOOL)allowsReverseTransformation { return NO; }
+ (Class)transformedValueClass { return [NSNumber class]; }
@end




@implementation OddValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] % 2 == 1); }
@end
@implementation EvenValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] % 2 == 0); }
@end


@implementation SmallerthanOneValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] < 1); }
@end
@implementation LargerthanOneValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] > 1); }
@end
@implementation EqualtoOneValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] == 1); }
@end
@implementation DifferenttoOneValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] != 1); }
@end

@implementation SmallerthanTwoValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] < 2); }
@end
@implementation LargerthanTwoValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] > 2); }
@end
@implementation EqualtoTwoValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] == 2); }
@end
@implementation DifferenttoTwoValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] != 2); }
@end

@implementation SmallerthanThreeValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] < 3); }
@end
@implementation LargerthanThreeValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] > 3); }
@end
@implementation EqualtoThreeValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] == 3); }
@end
@implementation DifferenttoThreeValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] != 3); }
@end

@implementation SmallerthanFourValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] < 4); }
@end
@implementation LargerthanFourValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] > 4); }
@end
@implementation EqualtoFourValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] == 4); }
@end
@implementation DifferenttoFourValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] != 4); }
@end

@implementation SmallerthanFiveValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] < 5); }
@end
@implementation LargerthanFiveValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] > 5); }
@end
@implementation EqualtoFiveValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] == 5); }
@end
@implementation DifferenttoFiveValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] != 5); }
@end

@implementation SmallerthanSixValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] < 6); }
@end
@implementation LargerthanSixValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] > 6); }
@end
@implementation EqualtoSixValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] == 6); }
@end
@implementation DifferenttoSixValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] != 6); }
@end

@implementation SmallerthanSevenValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] < 7); }
@end
@implementation LargerthanSevenValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] > 7); }
@end
@implementation EqualtoSevenValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] == 7); }
@end
@implementation DifferenttoSevenValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] != 7); }
@end

@implementation SmallerthanEightValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] < 8); }
@end
@implementation LargerthanEightValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] > 8); }
@end
@implementation EqualtoEightValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] == 8); }
@end
@implementation DifferenttoEightValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] != 8); }
@end

@implementation SmallerthanNineValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] < 9); }
@end
@implementation LargerthanNineValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] > 9); }
@end
@implementation EqualtoNineValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] == 9); }
@end
@implementation DifferenttoNineValueTransformer
- (id)transformedValue:(id)value { return @([value intValue] != 9); }
@end