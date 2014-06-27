/***
 Copyright (c) 2010 Samuel Tribehou.
 Licensed under: whatever license you want.
 ***/


#import "InfixToPostfix.h"

@interface InfixToPostfix ()
- (NSArray*) tokenize: (NSString*) expression;
- (NSUInteger) precedenceOf: (NSString*) operator;
- (BOOL) hasBalancedBrackets:(NSString *)expression;
- (BOOL) precedenceOf : (NSString*) operator isHigherOrEqualThan: (NSString*) otherOperator;
- (void) addNumber:(NSMutableString*) numberBuf andToken:(unichar) token toTokens : (NSMutableArray*) tokens; 

@end

@implementation InfixToPostfix

- (InfixToPostfix*) init{
	self = [super init];
	
	return self;
}

- (void) dealloc{
}

- (NSString*) parseInfix: (NSString*) infixExpression{
	if ( ! [self hasBalancedBrackets:infixExpression]){
		NSLog(@"Unbalanced brackets in expression");
	    return nil;
	}
		
	SimpleStack * opStack = [[SimpleStack alloc] init];
	NSMutableString * output = [NSMutableString stringWithCapacity:[infixExpression length]];

	[opStack print];
	
	NSArray * tokens = [self tokenize: infixExpression];
	for (NSString *token in tokens){
		if ([self precedenceOf:token] != 0){
			// token is an operator, pop all operators of higher or equal precedence off the stack, and append them to the output
			NSString *op = [opStack peek];
			while (op && [self precedenceOf:op] != 0 && 
				   [self precedenceOf: op isHigherOrEqualThan: token]) {
				[output appendString: [NSString stringWithFormat: @"%@ ", [opStack pop]]];
				op = [opStack peek];
			}
			// then push the operator on the stack
			[opStack push:token];
			
			[opStack print];

		} else if ([token compare: @"("] ==0){
			// push opening brackets on the stack, will be dismissed later
			[opStack push:token];
		} else if ([token compare: @")"] ==0) {
			// closing bracket : 
			// pop operators off the stack and append them to the output while the popped element is not the opening bracket
			NSString  * op = [opStack pop];
		    while ( op  && ([op compare: @"("] != 0)){
				[output appendString: [NSString stringWithFormat: @"%@ ", op]];
				op = [opStack pop];
			}
			if ( ! op || ([op compare: @"("]  != 0)){
				NSLog(@"Error : unbalanced brackets in expression");
				return nil;
			}
		} else {
			//token is an operand, append it to the output
			[output appendString: [NSString stringWithFormat: @"%@ ", token]];
		}
		
		[opStack print];
		
	}
	
	//pop remaining operators off the stack, and append them to the output
	while (! [opStack empty]) {
		[output appendString: [NSString stringWithFormat: @"%@ ", [opStack pop]]];
	}
	
	return [output stringByTrimmingCharactersInSet:
			[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


/* private methods */


- (NSArray*) tokenize: (NSString*) expression {
	NSMutableArray * tokens = [NSMutableArray arrayWithCapacity:[expression length]];
	
	unichar c;
	NSMutableString * numberBuf = [NSMutableString stringWithCapacity: 5];
	NSInteger length = [expression length];
	BOOL nextMinusSignIsNegativeOperator = YES;
	
	for (int i = 0; i< length; i++){
		c = [expression characterAtIndex: i];
		switch (c) {
			case '+':
			case '/':
			case '*':
			case '^':
				nextMinusSignIsNegativeOperator = YES;
				[self addNumber: numberBuf andToken: c toTokens:tokens];
				break;
			case '(':
		    case ')':
				nextMinusSignIsNegativeOperator = NO;
				[self addNumber: numberBuf andToken: c toTokens:tokens];
				break;
			case '-':
				if (nextMinusSignIsNegativeOperator){
					nextMinusSignIsNegativeOperator = NO;
					[numberBuf appendString : [NSString stringWithCharacters: &c length:1]];	
				} else {
					nextMinusSignIsNegativeOperator = YES;
					[self addNumber: numberBuf andToken: c toTokens:tokens];
				}
				
				break;
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
			case '8':
			case '9':
			case '0':
			case '.':
				nextMinusSignIsNegativeOperator = NO;
				[numberBuf appendString : [NSString stringWithCharacters: &c length:1]];
				break;
			case ' ':
				break;
			default:
				NSLog(@"Unsupported character in input expression : %c, discarding.", c);
				break;
		}
	}
	if ([numberBuf length] > 0)
		[tokens addObject:  [NSString stringWithString: numberBuf]];
	
	return tokens;
}

- (void) addNumber:(NSMutableString*) numberBuf andToken:(unichar) token toTokens : (NSMutableArray*) tokens{
	if ([numberBuf length] > 0){
		[tokens addObject:  [NSString stringWithString: numberBuf]];
		[numberBuf setString:@""];
	}
	[tokens addObject: [NSString stringWithCharacters: &token length:1]];			
}


- (BOOL) precedenceOf: (NSString*) operator isHigherOrEqualThan: (NSString*) otherOperator{
	return  [self precedenceOf: operator]  >=  [self precedenceOf: otherOperator];
}

- (NSUInteger) precedenceOf: (NSString*) operator{
	if ([operator compare: @"+"] == 0 )
		return 1;
	else if ([operator compare: @"-"] == 0 )
		return 1;
	else if ([operator compare: @"*"] == 0 )
		return 2;
	else if ([operator compare: @"/"] == 0 )
		return 2;		
	else if ([operator compare: @"^"] == 0 )
		return 3;
	else //invalid operator
		return 0;
}

- (BOOL) hasBalancedBrackets:(NSString*) expression{
	
	unichar c;
	int opened = 0, closed = 0;
	
	for (int i = 0; i< [expression length] ; i++){
		c = [expression characterAtIndex: i];
		if (c == '(') opened++;
		else if (c == ')') closed++;
	}
	
	
	return opened == closed;
}
						


@end
