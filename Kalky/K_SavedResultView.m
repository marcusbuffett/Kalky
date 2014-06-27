#import "K_SavedResultView.h"
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
@implementation K_SavedResultView
@synthesize decimalNumber, maxWidth, resultView, deleteView, font, padding;
-(id)initWithNumber:(NSDecimalNumber *)num maxWidth:(int)w
{
    self = [super init];
    padding = 10;
    decimalNumber = num;

    maxWidth = w;
    CGSize sizeOfText = [self sizeOfText:[self stringFromNum]];

    resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeOfText.width+padding*2, 40)];
    [self addSubview:resultView];
    
    font = [UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:30];
    UILabel* resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, sizeOfText.width, sizeOfText.height)];
    resultLabel.font = font;
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.textColor = [UIColor colorWithRed:.85 green:.85 blue:.85 alpha:1.0];
    resultLabel.text = [self stringFromNum];
    [self addSubview:resultLabel];
    
    
    //TESTING
    CGSize sizeOfDelete = [self sizeOfText:@"×"];
    UILabel* deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(resultView.frame.size.width+padding, 0, sizeOfDelete.width, sizeOfDelete.height)];
    deleteLabel.font = font;
    deleteLabel.textAlignment = NSTextAlignmentCenter;
    deleteLabel.textColor = [UIColor colorWithRed:.85 green:.85 blue:.85 alpha:1.0];
    deleteLabel.text = @"×";
    
    deleteView = [[UIView alloc] initWithFrame:CGRectMake(resultView.frame.size.width, 0, sizeOfDelete.width+padding*2, 40)];
    [self addSubview:deleteView];
    [self addSubview:deleteLabel];
    self.frame = CGRectMake(0, 0, resultView.frame.size.width + deleteView.frame.size.width, 40);
    return self;
}

-(CGSize)sizeOfText:(NSString *)string
{
    return [string sizeWithAttributes: @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:30.0]}];
}

-(NSString *)stringFromNum
{
    NSDecimalNumberHandler* handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:3 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSString* stringOfNum = decimalNumber.stringValue;
    if ([self sizeOfText:stringOfNum].width > maxWidth)
    {
        for (int i = 10; i >= 0; i--)
        {
            handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:i raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            
            NSString* stringWithHandler = [decimalNumber decimalNumberByRoundingAccordingToBehavior:handler].stringValue;
            
            if ([self sizeOfText:stringWithHandler].width <= maxWidth)
            {
                return stringWithHandler;
            }
        }
        
        NSString* stringOfDigitsBeforeDecimal = [NSString stringWithString:stringOfNum];
        if ([stringOfNum rangeOfString:@"."].location != NSNotFound)
        {
            stringOfDigitsBeforeDecimal = [stringOfNum substringToIndex:[stringOfNum rangeOfString:@"."].location];
        }
        NSInteger iForExponent = stringOfDigitsBeforeDecimal.length-2;
        NSDecimalNumber* numDivided = [decimalNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithMantissa:10 exponent:iForExponent isNegative:NO]];
        
        for (int i = 10; i >= 0; i--)
        {
            handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:i raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            NSDecimalNumber * rounded = [numDivided decimalNumberByRoundingAccordingToBehavior:handler];
            NSString* exponentForm = [NSString stringWithFormat:@"%@e%zd", rounded.stringValue, iForExponent+1];
            
            if ([self sizeOfText:exponentForm].width <= maxWidth)
            {
                return exponentForm;
            }
        }
    }
    else
    {
        return decimalNumber.stringValue;
    }
    return nil;
}

-(CGRect)calculateFrame
{
    return CGRectMake(0, 0, 0, 0);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect resultRectangle = resultView.frame;
    CGContextSetRGBFillColor(context, 0.18f, 0.18f, 0.18f, 1.0f);
    CGContextFillRect(context, resultRectangle);
    
    CGRect deleteRectangle = deleteView.frame;
    CGContextSetRGBFillColor(context, 0.07f, 0.07f, 0.07f, 1.0f);
    CGContextFillRect(context, deleteRectangle);
    
}


@end
