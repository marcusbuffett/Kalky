/***
 Copyright (c) 2010 Samuel Tribehou.
 Licensed under: whatever license you want.
 ***/


#import <Foundation/Foundation.h>
#import "InfixToPostfix.h"
#import "PostfixCalculator.h"

@interface InfixCalculator : NSObject {
	InfixToPostfix *itp;
	PostfixCalculator *postCalc;
}

- (InfixCalculator*) init;
- (void) dealloc;
- (NSDecimalNumber*) computeExpression: (NSString*) infixExpression;

@end
