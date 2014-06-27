/***
 Copyright (c) 2010 Samuel Tribehou.
 Licensed under: whatever license you want.
 ***/


#import "InfixCalculator.h"


@implementation InfixCalculator

- (InfixCalculator*) init{
	self = [super init];
	if (self){
		itp = [[InfixToPostfix alloc] init];
		postCalc = [[PostfixCalculator alloc] init];
	}
	return self;
}

- (void) dealloc
{
}

- (NSDecimalNumber*) computeExpression: (NSString*) infixExpression {
	NSString* postfixExpression = [itp parseInfix: infixExpression];
	
	if (postfixExpression) {
		return [postCalc compute: postfixExpression];
	}
	
	return nil;
}

@end
