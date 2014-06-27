/***
 Copyright (c) 2010 Samuel Tribehou.
 Licensed under: whatever license you want.
 ***/
	

#import <Foundation/Foundation.h>
#import "SimpleStack.h"

@interface PostfixCalculator : NSObject {
	NSArray* operators;
	SimpleStack* stack;
}


- (PostfixCalculator*) init;
- (void) dealloc;
- (NSDecimalNumber *) compute:(NSString*) postfixExpression;
@end
