#import "K_View.h"
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
@implementation K_View
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect rectangle = CGRectMake(0, 146, 320, 422);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, .2, .2, .2, 1.0);
//    CGContextSetRGBFillColor(context, .85, .85, .85, 1.0);
    CGContextFillRect(context, rectangle);
    
    CGRect secondRectangle = CGRectMake(0, 0, 320, 146);
    CGContextSetRGBFillColor(context, .85, .85, .85, 1.0);
    CGContextFillRect(context, secondRectangle);
}


@end
