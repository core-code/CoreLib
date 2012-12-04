//
//  NSFileHandle+CoreCode.m
//  iEDWare
//
//  Created by Julian Mayer on 28.11.12.
//  Copyright (c) 2012 EDAG. All rights reserved.
//

#import "NSFileHandle+CoreCode.h"

@implementation NSFileHandle (CoreCode)

- (float)readFloat
{
    float ret;
    [[self readDataOfLength:sizeof(float)] getBytes:&ret length:sizeof(float)];
    return ret;
}
- (int)readInt
{
    int ret;
    [[self readDataOfLength:sizeof(int)] getBytes:&ret length:sizeof(int)];
    return ret;
}
@end
