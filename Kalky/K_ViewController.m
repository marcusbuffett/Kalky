#import "K_ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define PADDING 4
#define OP_BUTTON_DIFFERENCE .04f

#define COLOR_CALC_NORMAL 0
#define COLOR_CALC_HIGHLIGHTED 1
#define COLOR_OP_NORMAL 2
#define COLOR_OP_HIGHLIGHTED 3
#define COLOR_CALC_TEXT_NORMAL 4
#define COLOR_CALC_TEXT_HIGHLIGHTED 5
#define COLOR_OP_TEXT_NORMAL 6
#define COLOR_OP_TEXT_HIGHLIGHTED 7
#define COLOR_EXPRESSION_TEXT 8
#define COLOR_RESULT_TEXT 9
#define COLOR_OP_BORDER 10
#define COLOR_HELP_NORMAL 11

#define FONT_BUTTON_NORMAL 0
#define FONT_BUTTON_HIGHLIGHTED 1
#define FONT_OP_NORMAL 2
#define FONT_OP_HIGHLIGHTED 3
#define FONT_EXPRESSION 4
#define FONT_RESULT 5
#define FONT_HELP 6

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@interface K_ViewController ()

@end

@implementation K_ViewController

@synthesize calculatorButtons, functionCodes, expressionLabel, resultLabel, savedResultViews, scrollView, colors, fonts;

-(instancetype)init
{
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    functionCodes = [NSArray arrayWithObjects:@"+", @"−", @"×", @"÷", nil];
    savedResultViews = [[NSMutableArray alloc] init];
    
    colors = [[NSMutableArray alloc] init];
    [colors addObject:[UIColor colorWithWhite:0.067 alpha:1.000]]; // calc button background
    [colors addObject:[UIColor colorWithWhite:0.033 alpha:1.000]]; // calc button background highlighted
    [colors addObject:[UIColor colorWithWhite:0.204 alpha:1.000]]; // op button background
    [colors addObject:[UIColor colorWithWhite:0.144 alpha:1.000]]; // op button background highlighted
    [colors addObject:[UIColor colorWithWhite:0.874 alpha:1.000]]; // calc button text
    [colors addObject:[UIColor colorWithWhite:0.897 alpha:1.000]]; // calc button text highlighted
    [colors addObject:[UIColor colorWithWhite:0.807 alpha:1.000]]; // op button text
    [colors addObject:[UIColor colorWithWhite:0.999 alpha:1.000]]; // op button text highlighted
    [colors addObject:[UIColor colorWithWhite:0.286 alpha:1.000]]; // expression text
    [colors addObject:[UIColor colorWithWhite:0.284 alpha:1.000]]; // result text
    [colors addObject:[UIColor colorWithWhite:0.605 alpha:1.000]]; // op border
    [colors addObject:[UIColor colorWithWhite:0.242 alpha:1.000]]; // calc button background
    
    fonts = [[NSMutableArray alloc] init];
    [fonts addObject:[UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:50]]; // calc button text
    [fonts addObject:[UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:60]]; // calc button text highlighted
    [fonts addObject:[UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:60]]; // op button text
    [fonts addObject:[UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:70]]; // op button text highlighted
    [fonts addObject:[UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:30]]; // expression text
    [fonts addObject:[UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:60]]; // result text
    [fonts addObject:[UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:30]]; // result text
    
    if (IS_IPHONE5)
    {
        for (int i = 0; i <= 2; i++) {
            for (int j = 0; j <= 2; j++) {
                UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];

                [button addTarget:self action:@selector(calcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                int number = 7-3*j+i;
                [button setTitle:[NSString stringWithFormat:@"%i", number] forState:UIControlStateNormal];
                [button setTitleColor:[colors objectAtIndex:COLOR_CALC_TEXT_NORMAL] forState:UIControlStateNormal];
                [button setFrame:CGRectMake(107*i, 226+86*j, 106, 85)];
                [button addTarget:self action:@selector(calcButtonHighlight:) forControlEvents:UIControlEventTouchDown];
                [button addTarget:self action:@selector(calcButtonNormal:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
                button.backgroundColor = [colors objectAtIndex:COLOR_CALC_NORMAL];
                button.titleLabel.font = [fonts objectAtIndex:FONT_BUTTON_NORMAL];
                [self.view addSubview:button];
            }
        }
        
        CGFloat maxWhite = .20f;
        CGFloat difference = .015f;
        
        for (int i = 0; i < 4; i++)
        {
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(calcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:[NSString stringWithFormat:@"%@", [functionCodes objectAtIndex:i]] forState:UIControlStateNormal];
            [button setTitleColor:[colors objectAtIndex:COLOR_OP_TEXT_NORMAL] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(80*i, 146, 80, 80)];
            button.backgroundColor = [colors objectAtIndex:COLOR_OP_NORMAL];
            
            button.titleLabel.font = [fonts objectAtIndex:FONT_OP_NORMAL];
            
            button.backgroundColor = [UIColor colorWithWhite:maxWhite-difference*i alpha:1.0f];
            
            [button addTarget:self action:@selector(operandButtonHighlight:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(operandButtonNormal:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
            [self.view addSubview:button];
        }
        
        
        
        UIButton* zero = [UIButton buttonWithType:UIButtonTypeCustom];
        [zero addTarget:self action:@selector(calcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        zero.backgroundColor = [colors objectAtIndex:COLOR_CALC_NORMAL];
        [zero setFrame:CGRectMake(0, 484, 213, 85)];
        [zero setTitle:@"0" forState:UIControlStateNormal];
        zero.titleLabel.font = [fonts objectAtIndex:FONT_BUTTON_NORMAL];
        [zero addTarget:self action:@selector(calcButtonHighlight:) forControlEvents:UIControlEventTouchDown];
        [zero addTarget:self action:@selector(calcButtonNormal:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
        [self.view addSubview:zero];
        
        UIButton* decimal = [UIButton buttonWithType:UIButtonTypeCustom];
        [decimal addTarget:self action:@selector(calcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        decimal.backgroundColor = [colors objectAtIndex:COLOR_CALC_NORMAL];
        [decimal setFrame:CGRectMake(214, 484, 106, 85)];
        [decimal setTitle:@"." forState:UIControlStateNormal];
        decimal.titleLabel.font = [fonts objectAtIndex:FONT_BUTTON_NORMAL];
        [decimal addTarget:self action:@selector(calcButtonHighlight:) forControlEvents:UIControlEventTouchDown];
        [decimal addTarget:self action:@selector(calcButtonNormal:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
        [self.view addSubview:decimal];
        
        expressionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 310, 41)];
        expressionLabel.text = @"";
        expressionLabel.font = [fonts objectAtIndex:FONT_EXPRESSION];
        expressionLabel.textAlignment = NSTextAlignmentLeft;
        expressionLabel.textColor = [colors objectAtIndex:COLOR_EXPRESSION_TEXT];
        expressionLabel.adjustsFontSizeToFitWidth = true;
        expressionLabel.minimumScaleFactor = .5;
        [self.view addSubview:expressionLabel];
        
        resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 36, 312, 82)];
        resultLabel.font = [fonts objectAtIndex:FONT_RESULT];
        resultLabel.textAlignment = NSTextAlignmentRight;
        resultLabel.textColor = [colors objectAtIndex:COLOR_RESULT_TEXT];
        resultLabel.text = @"0";
        resultLabel.adjustsFontSizeToFitWidth = true;
        resultLabel.minimumScaleFactor = .5;
        [self.view addSubview:resultLabel];
        
        UIButton* helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [helpButton addTarget:self action:@selector(showTutorial) forControlEvents:UIControlEventTouchUpInside];
        helpButton.backgroundColor = [colors objectAtIndex:COLOR_HELP_NORMAL];
        [helpButton setFrame:CGRectMake(0, 53, 21, 40)];
        [helpButton setTitle:@"?" forState:UIControlStateNormal];
        helpButton.titleLabel.font = [fonts objectAtIndex:FONT_HELP];
        [self.view addSubview:helpButton];

        UISwipeGestureRecognizer* clearGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipeDetected)];
        clearGesture.direction = UISwipeGestureRecognizerDirectionDown;
        [self.view addGestureRecognizer:clearGesture];
        
        UISwipeGestureRecognizer* saveGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(saveCurrentResult)];
        saveGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:saveGesture];
        
        UISwipeGestureRecognizer* undoGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backSwipeDetected)];
        undoGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:undoGesture];

        UISwipeGestureRecognizer* lockGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipeDetected)];
        lockGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:lockGesture];
        
        UITapGestureRecognizer* saveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveCurrentResult)];
        resultLabel.userInteractionEnabled = true;
        [resultLabel addGestureRecognizer:saveTap];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, 320, 40)];
        scrollView.contentSize = CGSizeMake(310, 40);
        scrollView.contentInset = UIEdgeInsetsMake(0, 4.0f, 0, 4.0f);
        scrollView.showsHorizontalScrollIndicator = false;
        [self.view addSubview:scrollView];
    }
    
    else
    {
        for (int i = 0; i <= 2; i++) {
            for (int j = 0; j <= 2; j++) {
                UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [button addTarget:self action:@selector(calcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                int number = 7-3*j+i;
                [button setTitle:[NSString stringWithFormat:@"%i", number] forState:UIControlStateNormal];
                [button setTitleColor:[colors objectAtIndex:COLOR_CALC_TEXT_NORMAL] forState:UIControlStateNormal];
                [button setFrame:CGRectMake(107*i, 205+69*j, 106, 68)];
                [button addTarget:self action:@selector(calcButtonHighlight:) forControlEvents:UIControlEventTouchDown];
                [button addTarget:self action:@selector(calcButtonNormal:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
                button.backgroundColor = [colors objectAtIndex:COLOR_CALC_NORMAL];
                button.titleLabel.font = [fonts objectAtIndex:FONT_BUTTON_NORMAL];
                [self.view addSubview:button];
            }
        }
        
        CGFloat maxWhite = .20f;
        CGFloat difference = .015f;
        
        for (int i = 0; i < 4; i++)
        {
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(calcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:[NSString stringWithFormat:@"%@", [functionCodes objectAtIndex:i]] forState:UIControlStateNormal];
            [button setTitleColor:[colors objectAtIndex:COLOR_OP_TEXT_NORMAL] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(80*i, 146, 80, 59)];
            button.backgroundColor = [colors objectAtIndex:COLOR_OP_NORMAL];
            
            button.titleLabel.font = [fonts objectAtIndex:FONT_OP_NORMAL];
            
            button.backgroundColor = [UIColor colorWithWhite:maxWhite-difference*i alpha:1.0f];
            
            [button addTarget:self action:@selector(operandButtonHighlight:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(operandButtonNormal:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
            [self.view addSubview:button];
        }
        
        
        
        UIButton* zero = [UIButton buttonWithType:UIButtonTypeCustom];
        [zero addTarget:self action:@selector(calcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        zero.backgroundColor = [colors objectAtIndex:COLOR_CALC_NORMAL];
        [zero setFrame:CGRectMake(0, 412, 213, 68)];
        [zero setTitle:@"0" forState:UIControlStateNormal];
        zero.titleLabel.font = [fonts objectAtIndex:FONT_BUTTON_NORMAL];
        [zero addTarget:self action:@selector(calcButtonHighlight:) forControlEvents:UIControlEventTouchDown];
        [zero addTarget:self action:@selector(calcButtonNormal:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
        [self.view addSubview:zero];
        
        UIButton* decimal = [UIButton buttonWithType:UIButtonTypeCustom];
        [decimal addTarget:self action:@selector(calcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        decimal.backgroundColor = [colors objectAtIndex:COLOR_CALC_NORMAL];
        [decimal setFrame:CGRectMake(214, 412, 106, 68)];
        [decimal setTitle:@"." forState:UIControlStateNormal];
        decimal.titleLabel.font = [fonts objectAtIndex:FONT_BUTTON_NORMAL];
        [decimal addTarget:self action:@selector(calcButtonHighlight:) forControlEvents:UIControlEventTouchDown];
        [decimal addTarget:self action:@selector(calcButtonNormal:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
        [self.view addSubview:decimal];
        
        expressionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 310, 41)];
        expressionLabel.text = @"";
        expressionLabel.font = [fonts objectAtIndex:FONT_EXPRESSION];
        expressionLabel.textAlignment = NSTextAlignmentLeft;
        expressionLabel.textColor = [colors objectAtIndex:COLOR_EXPRESSION_TEXT];
        expressionLabel.adjustsFontSizeToFitWidth = true;
        expressionLabel.minimumScaleFactor = .5;
        [self.view addSubview:expressionLabel];
        
        resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 36, 312, 82)];
        resultLabel.font = [fonts objectAtIndex:FONT_RESULT];
        resultLabel.textAlignment = NSTextAlignmentRight;
        resultLabel.textColor = [colors objectAtIndex:COLOR_RESULT_TEXT];
        resultLabel.text = @"0";
        resultLabel.adjustsFontSizeToFitWidth = true;
        resultLabel.minimumScaleFactor = .5;
        [self.view addSubview:resultLabel];
        
        UIButton* helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [helpButton addTarget:self action:@selector(showTutorial) forControlEvents:UIControlEventTouchUpInside];
        helpButton.backgroundColor = [colors objectAtIndex:COLOR_HELP_NORMAL];
        [helpButton setFrame:CGRectMake(0, 53, 21, 40)];
        [helpButton setTitle:@"?" forState:UIControlStateNormal];
        helpButton.titleLabel.font = [fonts objectAtIndex:FONT_HELP];
        [self.view addSubview:helpButton];
        
        UISwipeGestureRecognizer* clearGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipeDetected)];
        clearGesture.direction = UISwipeGestureRecognizerDirectionDown;
        [self.view addGestureRecognizer:clearGesture];
        
        UISwipeGestureRecognizer* saveGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(saveCurrentResult)];
        saveGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:saveGesture];
        
        UISwipeGestureRecognizer* undoGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backSwipeDetected)];
        undoGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:undoGesture];
        
        UISwipeGestureRecognizer* lockGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipeDetected)];
        lockGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:lockGesture];
        
        UITapGestureRecognizer* saveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveCurrentResult)];
        resultLabel.userInteractionEnabled = true;
        [resultLabel addGestureRecognizer:saveTap];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, 320, 40)];
        scrollView.contentSize = CGSizeMake(310, 40);
        scrollView.contentInset = UIEdgeInsetsMake(0, 4.0f, 0, 4.0f);
        scrollView.showsHorizontalScrollIndicator = false;
        [self.view addSubview:scrollView];
    }
}

-(void)showTutorial
{
    if (IS_IPHONE5)
    {
        UIButton* tutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tutorialButton addTarget:self action:@selector(hideTutorial:) forControlEvents:UIControlEventTouchUpInside];
        [tutorialButton setFrame:CGRectMake(0, 0, 320, 568)];
        [tutorialButton setImage:[UIImage imageNamed:@"portrait.png"] forState:UIControlStateNormal];
        [self.view addSubview:tutorialButton];
    }
    else
    {
        UIButton* tutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tutorialButton addTarget:self action:@selector(hideTutorial:) forControlEvents:UIControlEventTouchUpInside];
        [tutorialButton setFrame:CGRectMake(0, 0, 320, 480)];
        [tutorialButton setImage:[UIImage imageNamed:@"portrait.png"] forState:UIControlStateNormal];
        [self.view addSubview:tutorialButton];
    }
    
}

-(void)hideTutorial:(id)sender
{
    [sender removeFromSuperview];
}

-(void)calcButtonHighlight:(id)sender
{
    UIButton* tappedButton = (UIButton*)sender;
    tappedButton.backgroundColor = [colors objectAtIndex:COLOR_CALC_HIGHLIGHTED];
    tappedButton.titleLabel.font = [fonts objectAtIndex:FONT_BUTTON_HIGHLIGHTED];
}

-(void)calcButtonNormal:(id)sender
{
    UIButton* tappedButton = (UIButton*)sender;
    tappedButton.backgroundColor = [colors objectAtIndex:COLOR_CALC_NORMAL];
    tappedButton.titleLabel.font = [fonts objectAtIndex:FONT_BUTTON_NORMAL];
}

-(void)operandButtonHighlight:(id)sender
{
    UIButton* tappedButton = (UIButton*)sender;
    CGFloat originalWhite;
    [tappedButton.backgroundColor getWhite:&originalWhite alpha:nil];
    tappedButton.backgroundColor = [UIColor colorWithWhite:originalWhite-OP_BUTTON_DIFFERENCE alpha:1.0f];
    tappedButton.titleLabel.font = [fonts objectAtIndex:FONT_OP_HIGHLIGHTED];
    [tappedButton setTitleColor:[colors objectAtIndex:COLOR_OP_TEXT_HIGHLIGHTED] forState:UIControlStateHighlighted];
}

-(void)operandButtonNormal:(id)sender
{
    UIButton* tappedButton = (UIButton*)sender;
    CGFloat originalWhite;
    [tappedButton.backgroundColor getWhite:&originalWhite alpha:nil];
    tappedButton.backgroundColor = [UIColor colorWithWhite:originalWhite+OP_BUTTON_DIFFERENCE alpha:1.0f];
    tappedButton.titleLabel.font = [fonts objectAtIndex:FONT_OP_NORMAL];
}

-(void)saveCurrentResult
{
    K_SavedResultView *newSRView = [[K_SavedResultView alloc] initWithNumber:[self calculateResult] maxWidth:120];
    UITapGestureRecognizer * deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteSavedResult:)];
    UITapGestureRecognizer * useTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useSavedResult:)];
    newSRView.userInteractionEnabled = true;
    [newSRView.deleteView addGestureRecognizer:deleteTap];
    [newSRView.resultView addGestureRecognizer:useTap];
    [newSRView setNeedsDisplay];
    [savedResultViews insertObject:newSRView atIndex:0];
    
    [UIView transitionWithView:self.scrollView duration:0.3
                       options:UIViewAnimationOptionTransitionFlipFromBottom|UIViewAnimationOptionCurveEaseInOut
                    animations:^ { [self.scrollView addSubview:newSRView]; }
                    completion:nil];
    
    for (int i = 0; i < savedResultViews.count; i++)
    {
        K_SavedResultView *viewAtI = [savedResultViews objectAtIndex:i];
        if (i == 0)
        {
            viewAtI.frame = CGRectMake(0, 0, viewAtI.frame.size.width, viewAtI.frame.size.height);
        }
        else
        {
            K_SavedResultView *previousView = [savedResultViews objectAtIndex:i-1];
            viewAtI.frame = CGRectMake(previousView.frame.origin.x-viewAtI.frame.size.width-PADDING, 0, viewAtI.frame.size.width, viewAtI.frame.size.height);
        }
    }
    
    
    
    K_SavedResultView *lastView = [savedResultViews lastObject];
    K_SavedResultView *firstView = [savedResultViews firstObject];
    int contentSize = firstView.frame.origin.x+firstView.frame.size.width-lastView.frame.origin.x;
    if (contentSize < 310)
    {
        contentSize = 310;
    }
    scrollView.contentSize = CGSizeMake(contentSize, 40);
    int adjustmentAmount = scrollView.contentSize.width-(firstView.frame.origin.x+firstView.frame.size.width);
    for (K_SavedResultView* view in savedResultViews)
    {
        view.frame = CGRectMake(view.frame.origin.x+adjustmentAmount, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    }
    
    CGPoint bottomOffset = CGPointMake([scrollView contentSize].width-scrollView.bounds.size.width+scrollView.contentInset.right, 0);
    [scrollView setContentOffset:bottomOffset animated:YES];
}

-(void)useSavedResult:(UITapGestureRecognizer *)tap
{
    UIView* viewTapped = tap.view;
    K_SavedResultView* savedResultView = (K_SavedResultView*)[viewTapped superview];
    [self addCharacterToExpression:[NSString stringWithFormat:@"%@", savedResultView.decimalNumber.stringValue]];
    [self parseExpression];
}

-(void)deleteSavedResult:(UITapGestureRecognizer *)tap
{
    K_SavedResultView* viewToDelete = (K_SavedResultView*)[tap.view superview];
    [savedResultViews removeObject:viewToDelete];
    
    [UIView transitionWithView:self.scrollView duration:0.15
                       options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut
                    animations:^ { [viewToDelete removeFromSuperview]; }
                    completion:nil];
    
    
    for (int i = 0; i < savedResultViews.count; i++)
    {
        K_SavedResultView *viewAtI = [savedResultViews objectAtIndex:i];
        if (i == 0)
        {
            viewAtI.frame = CGRectMake(0, 0, viewAtI.frame.size.width, viewAtI.frame.size.height);
        }
        else
        {
            K_SavedResultView *previousView = [savedResultViews objectAtIndex:i-1];
            viewAtI.frame = CGRectMake(previousView.frame.origin.x-viewAtI.frame.size.width-PADDING, 0, viewAtI.frame.size.width, viewAtI.frame.size.height);
        }
    }
    
    
    
    K_SavedResultView *lastView = [savedResultViews lastObject];
    K_SavedResultView *firstView = [savedResultViews firstObject];
    int contentSize = firstView.frame.origin.x+firstView.frame.size.width-lastView.frame.origin.x;
    if (contentSize < 310)
    {
        contentSize = 310;
    }
    scrollView.contentSize = CGSizeMake(contentSize, 40);
    int adjustmentAmount = scrollView.contentSize.width-(firstView.frame.origin.x+firstView.frame.size.width);
    for (K_SavedResultView* view in savedResultViews)
    {
        view.frame = CGRectMake(view.frame.origin.x+adjustmentAmount, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    }
    CGPoint bottomOffset = CGPointMake([scrollView contentSize].width-scrollView.bounds.size.width+scrollView.contentInset.right, 0);
    [scrollView setContentOffset:bottomOffset animated:YES];
}

-(void)upSwipeDetected
{
    NSDecimalNumber* num = [self calculateResult];
    if ([num isEqual:[NSDecimalNumber notANumber]])
    {
        return;
    }
    expressionLabel.text = [self calculateResult].stringValue;
}

-(void)downSwipeDetected
{
    expressionLabel.text = @"";
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.type = kCATransitionFade;
    animation.duration = 0.25;
    [resultLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];
    resultLabel.text = @"0";
}

-(void)backSwipeDetected
{
    NSInteger greatestIndex = 0;
    for (NSString* operand in functionCodes)
    {
        NSInteger location = [expressionLabel.text rangeOfString:operand options:NSBackwardsSearch].location;
        if (location != NSNotFound && location > greatestIndex)
        {
            greatestIndex = location;
        }
    }
    if (greatestIndex == 0)
    {
        expressionLabel.text = @"";
        resultLabel.text = @"0";
    }
    else if (greatestIndex == expressionLabel.text.length-1)
    {
        expressionLabel.text = [expressionLabel.text substringToIndex:expressionLabel.text.length-1];
    }
    else
    {
        expressionLabel.text = [expressionLabel.text substringToIndex:greatestIndex+1];
    }
    [self parseExpression];
    
}

-(void)calcButtonTapped:(id)sender
{
    UIButton* buttonTapped = (UIButton*)sender;
    NSString* characterToAdd = buttonTapped.titleLabel.text;
    if ([self expressionEmpty] && [self isOperand:characterToAdd])
    {
        return;
    }
    if (![self canAddDecimal] && [characterToAdd isEqualToString:@"."])
    {
        return;
    }
    else if ([self isOperand:characterToAdd] && [self lastCharacterIsOperand])
    {
        [self replaceLastCharacterInExpression:characterToAdd];
    }
    else
    {
        [self addCharacterToExpression:characterToAdd];
    }
    [self parseExpression];
    
}

-(void)addCharacterToExpression:(NSString*)c
{
    if (expressionLabel.text)
    {
        expressionLabel.text = [NSString stringWithFormat:@"%@%@", expressionLabel.text, c];
    }
    else
    {
        expressionLabel.text = [NSString stringWithFormat:@"%@", c];
    }
}

-(void)replaceLastCharacterInExpression:(NSString *)c
{
    expressionLabel.text = [NSString stringWithFormat:@"%@%@", [expressionLabel.text substringToIndex:expressionLabel.text.length-1], c];
}

-(bool)isOperand:(NSString *)c
{
    if ([functionCodes containsObject:c])
    {
        return true;
    }
    return false;
}

-(bool)expressionEmpty
{
    if ([expressionLabel.text isEqualToString:@""])
    {
        return true;
    }
    return false;
}

-(bool)lastCharacterIsOperand
{
    if ([expressionLabel.text isEqualToString:@""])
    {
        return false;
    }
    if ([functionCodes containsObject:[expressionLabel.text substringFromIndex:expressionLabel.text.length-1]])
    {
        return true;
    }
    return false;
}

-(bool)canAddDecimal
{
    if ([self lastCharacterIsDecimal])
    {
        return false;
    }
    if (![self lastCharacterIsOperand])
    {
        NSInteger greatestIndex = 0;
        for (NSString* o in functionCodes)
        {
            if ([expressionLabel.text rangeOfString:o].location != NSNotFound)
            {
                if ([expressionLabel.text rangeOfString:o options:NSBackwardsSearch].location > greatestIndex)
                {
                    greatestIndex = [expressionLabel.text rangeOfString:o options:NSBackwardsSearch].location;
                }
            }
        }
        NSString* stringAfterLastOperand = [expressionLabel.text substringFromIndex:greatestIndex];
        if ([stringAfterLastOperand rangeOfString:@"."].location != NSNotFound)
        {
            return false;
        }
    }
    return true;
}

-(bool)lastCharacterIsDecimal
{
    if ([expressionLabel.text isEqualToString:@""])
    {
        return false;
    }
    if ([expressionLabel.text rangeOfString:@"."].location != NSNotFound && [[expressionLabel.text substringFromIndex:expressionLabel.text.length-1] isEqualToString:@"."])
    {
        return true;
    }
    return false;
}

-(NSDecimalNumber *)calculateResult
{
    if ([expressionLabel.text isEqualToString:@""])
    {
        return [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    InfixCalculator* calculator = [[InfixCalculator alloc] init];
    NSString* expressionToUse = [expressionLabel.text stringByReplacingOccurrencesOfString:@"×" withString:@"*"];
    expressionToUse = [expressionToUse stringByReplacingOccurrencesOfString:@"÷" withString:@"/"];
    expressionToUse = [expressionToUse stringByReplacingOccurrencesOfString:@"−" withString:@"-"];
    if ([self lastCharacterIsOperand])
    {
        expressionToUse = [expressionToUse substringToIndex:expressionToUse.length-1];
    }
    NSDecimalNumber* num = [calculator computeExpression:expressionToUse];
    return num;
}

-(void)parseExpression
{
    if ([expressionLabel.text isEqualToString:@""])
    {
        return;
    }
    NSDecimalNumber* num = [self calculateResult];
    if (num)
    {
        NSDecimalNumberHandler* handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:3 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        
        NSString* stringOfNum = num.stringValue;
        if ([stringOfNum sizeWithAttributes: @{NSFontAttributeName : [fonts objectAtIndex:FONT_RESULT]}].width > resultLabel.frame.size.width)
        {
            for (int i = 10; i >= 0; i--)
            {
                handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:i raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                
                NSString* stringWithHandler = [num decimalNumberByRoundingAccordingToBehavior:handler].stringValue;
                
                if ([stringWithHandler sizeWithAttributes: @{NSFontAttributeName : [fonts objectAtIndex:FONT_RESULT]}].width <= resultLabel.frame.size.width)
                {

                    resultLabel.text = stringWithHandler;
                    return;
                }
            }
            
            NSString* stringOfDigitsBeforeDecimal = [NSString stringWithString:stringOfNum];
            if ([stringOfNum rangeOfString:@"."].location != NSNotFound)
            {
                stringOfDigitsBeforeDecimal = [stringOfNum substringToIndex:[stringOfNum rangeOfString:@"."].location];
            }
            NSInteger iForExponent = stringOfDigitsBeforeDecimal.length-2;
            if ([resultLabel.text rangeOfString:@"-"].location != NSNotFound)
            {
                iForExponent = stringOfDigitsBeforeDecimal.length-3;
            }
            NSDecimalNumber* numDivided = [num decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithMantissa:10 exponent:iForExponent isNegative:NO]];
            
            for (int i = 10; i >= 0; i--)
            {
                handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:i raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                NSDecimalNumber * rounded = [numDivided decimalNumberByRoundingAccordingToBehavior:handler];
                NSString* exponentForm = [NSString stringWithFormat:@"%@e%zd", rounded.stringValue, iForExponent+1];
                
                if ([exponentForm sizeWithAttributes: @{NSFontAttributeName : [fonts objectAtIndex:FONT_RESULT]}].width <= resultLabel.frame.size.width)
                {
                    resultLabel.text = exponentForm;
                    return;
                }
            }
        }
        else
        {
            if ([num isEqual:[NSDecimalNumber notANumber]])
            {
                resultLabel.text = @"Divide by zero ";
                return;
            }
            resultLabel.text = [NSString stringWithFormat:@"%@", num.stringValue];

        
        }
    }
    
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
