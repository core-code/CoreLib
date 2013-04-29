//
//  JMCorrectTimer.h
//  CoreLib
//
//  Created by Julian Mayer on 28.04.13.
//  Copyright (c) 2013 CoreCode. All rights reserved.
//

@interface JMCorrectTimer : NSObject

- (id)initWithFireDate:(NSDate *)d timerBlock:(void (^)(void))timerBlock dropBlock:(void (^)(void))dropBlock;

@end
