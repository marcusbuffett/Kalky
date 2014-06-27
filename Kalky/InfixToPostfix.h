/***
 Copyright (c) 2010 Samuel Tribehou.
 Licensed under: whatever license you want.
 ***/


#import <Foundation/Foundation.h>
#import "SimpleStack.h"


@interface InfixToPostfix : NSObject {
	NSDictionary * operatorPrecedence;
}

- (InfixToPostfix*) init;
- (void) dealloc;

- (NSString*) parseInfix: (NSString*) infixExpression;

@end
