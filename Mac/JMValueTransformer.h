//
//  JMValueTransormer.h
//  CoreLib
//
//  Created by CoreCode on 12.03.12.
/*	Copyright © 2021 CoreCode Limited
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "CoreLib.h"


@interface InvalidEmailValueTransformer: NSValueTransformer @end
@interface ValidEmailValueTransformer: NSValueTransformer @end

@interface EmptyArrayValueTransformer: NSValueTransformer @end
@interface NonemptyArrayValueTransformer: NSValueTransformer @end


@interface BaseValueTransformer : NSValueTransformer @end

@interface OddValueTransformer: BaseValueTransformer @end
@interface EvenValueTransformer: BaseValueTransformer @end

@interface NumericComparisonValueTransformer : NSValueTransformer @end
@interface SmallerthanValueTransformer : NumericComparisonValueTransformer @end
@interface LargerthanValueTransformer : NumericComparisonValueTransformer @end
@interface EqualtoValueTransformer : NumericComparisonValueTransformer @end
@interface DifferenttoValueTransformer : NumericComparisonValueTransformer @end



#define COMPARISONTRANSFORMERS_INTERFACE(number) \
@interface Smallerthan ## number ## ValueTransformer: SmallerthanValueTransformer {} @end \
@interface Largerthan ## number ## ValueTransformer: LargerthanValueTransformer {} @end \
@interface Equalto ## number ## ValueTransformer: EqualtoValueTransformer {} @end \
@interface Differentto ## number ## ValueTransformer: DifferenttoValueTransformer {} @end



#define COMPARISONTRANSFORMERS_IMPLEMENTATION(number) \
@implementation Smallerthan ## number ## ValueTransformer @end \
@implementation Largerthan ## number ## ValueTransformer @end \
@implementation Equalto ## number ## ValueTransformer @end \
@implementation Differentto ## number ## ValueTransformer @end

COMPARISONTRANSFORMERS_INTERFACE(0)
COMPARISONTRANSFORMERS_INTERFACE(1)
COMPARISONTRANSFORMERS_INTERFACE(2)
COMPARISONTRANSFORMERS_INTERFACE(3)
COMPARISONTRANSFORMERS_INTERFACE(4)
COMPARISONTRANSFORMERS_INTERFACE(5)
COMPARISONTRANSFORMERS_INTERFACE(6)
COMPARISONTRANSFORMERS_INTERFACE(7)
COMPARISONTRANSFORMERS_INTERFACE(8)
COMPARISONTRANSFORMERS_INTERFACE(9)
COMPARISONTRANSFORMERS_INTERFACE(10)
COMPARISONTRANSFORMERS_INTERFACE(11)
COMPARISONTRANSFORMERS_INTERFACE(12)
COMPARISONTRANSFORMERS_INTERFACE(13)
COMPARISONTRANSFORMERS_INTERFACE(14)
COMPARISONTRANSFORMERS_INTERFACE(15)
COMPARISONTRANSFORMERS_INTERFACE(16)
COMPARISONTRANSFORMERS_INTERFACE(17)
COMPARISONTRANSFORMERS_INTERFACE(18)
COMPARISONTRANSFORMERS_INTERFACE(19)
COMPARISONTRANSFORMERS_INTERFACE(20)
COMPARISONTRANSFORMERS_INTERFACE(21)
COMPARISONTRANSFORMERS_INTERFACE(22)
COMPARISONTRANSFORMERS_INTERFACE(23)
COMPARISONTRANSFORMERS_INTERFACE(24)
COMPARISONTRANSFORMERS_INTERFACE(25)
COMPARISONTRANSFORMERS_INTERFACE(26)
COMPARISONTRANSFORMERS_INTERFACE(27)
COMPARISONTRANSFORMERS_INTERFACE(28)
COMPARISONTRANSFORMERS_INTERFACE(29)
COMPARISONTRANSFORMERS_INTERFACE(30)
COMPARISONTRANSFORMERS_INTERFACE(31)
COMPARISONTRANSFORMERS_INTERFACE(32)
COMPARISONTRANSFORMERS_INTERFACE(33)
COMPARISONTRANSFORMERS_INTERFACE(34)
COMPARISONTRANSFORMERS_INTERFACE(35)
COMPARISONTRANSFORMERS_INTERFACE(36)
COMPARISONTRANSFORMERS_INTERFACE(37)
COMPARISONTRANSFORMERS_INTERFACE(38)
COMPARISONTRANSFORMERS_INTERFACE(39)
COMPARISONTRANSFORMERS_INTERFACE(40)
COMPARISONTRANSFORMERS_INTERFACE(41)
COMPARISONTRANSFORMERS_INTERFACE(42)
COMPARISONTRANSFORMERS_INTERFACE(43)
COMPARISONTRANSFORMERS_INTERFACE(44)
COMPARISONTRANSFORMERS_INTERFACE(45)
COMPARISONTRANSFORMERS_INTERFACE(46)
COMPARISONTRANSFORMERS_INTERFACE(47)
COMPARISONTRANSFORMERS_INTERFACE(48)
COMPARISONTRANSFORMERS_INTERFACE(49)
COMPARISONTRANSFORMERS_INTERFACE(50)
COMPARISONTRANSFORMERS_INTERFACE(51)
COMPARISONTRANSFORMERS_INTERFACE(52)
COMPARISONTRANSFORMERS_INTERFACE(53)
COMPARISONTRANSFORMERS_INTERFACE(54)
COMPARISONTRANSFORMERS_INTERFACE(55)
COMPARISONTRANSFORMERS_INTERFACE(56)
COMPARISONTRANSFORMERS_INTERFACE(57)
COMPARISONTRANSFORMERS_INTERFACE(58)
COMPARISONTRANSFORMERS_INTERFACE(59)
COMPARISONTRANSFORMERS_INTERFACE(60)
COMPARISONTRANSFORMERS_INTERFACE(61)
COMPARISONTRANSFORMERS_INTERFACE(62)
COMPARISONTRANSFORMERS_INTERFACE(63)
COMPARISONTRANSFORMERS_INTERFACE(64)
COMPARISONTRANSFORMERS_INTERFACE(65)
COMPARISONTRANSFORMERS_INTERFACE(66)
COMPARISONTRANSFORMERS_INTERFACE(67)
COMPARISONTRANSFORMERS_INTERFACE(68)
COMPARISONTRANSFORMERS_INTERFACE(69)
COMPARISONTRANSFORMERS_INTERFACE(70)
COMPARISONTRANSFORMERS_INTERFACE(71)
COMPARISONTRANSFORMERS_INTERFACE(72)
COMPARISONTRANSFORMERS_INTERFACE(73)
COMPARISONTRANSFORMERS_INTERFACE(74)
COMPARISONTRANSFORMERS_INTERFACE(75)
COMPARISONTRANSFORMERS_INTERFACE(76)
COMPARISONTRANSFORMERS_INTERFACE(77)
COMPARISONTRANSFORMERS_INTERFACE(78)
COMPARISONTRANSFORMERS_INTERFACE(79)
COMPARISONTRANSFORMERS_INTERFACE(80)
COMPARISONTRANSFORMERS_INTERFACE(81)
COMPARISONTRANSFORMERS_INTERFACE(82)
COMPARISONTRANSFORMERS_INTERFACE(83)
COMPARISONTRANSFORMERS_INTERFACE(84)
COMPARISONTRANSFORMERS_INTERFACE(85)
COMPARISONTRANSFORMERS_INTERFACE(86)
COMPARISONTRANSFORMERS_INTERFACE(87)
COMPARISONTRANSFORMERS_INTERFACE(88)
COMPARISONTRANSFORMERS_INTERFACE(89)
COMPARISONTRANSFORMERS_INTERFACE(90)
COMPARISONTRANSFORMERS_INTERFACE(91)
COMPARISONTRANSFORMERS_INTERFACE(92)
COMPARISONTRANSFORMERS_INTERFACE(93)
COMPARISONTRANSFORMERS_INTERFACE(94)
COMPARISONTRANSFORMERS_INTERFACE(95)
COMPARISONTRANSFORMERS_INTERFACE(96)
COMPARISONTRANSFORMERS_INTERFACE(97)
COMPARISONTRANSFORMERS_INTERFACE(98)
COMPARISONTRANSFORMERS_INTERFACE(99)
