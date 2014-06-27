#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "InfixCalculator.h"
#import "K_SavedResultView.h"
@interface K_ViewController : UIViewController

@property (nonatomic, retain) NSMutableArray* calculatorButtons;
@property (nonatomic, retain) NSMutableArray* savedResultViews;
@property (nonatomic, retain) NSArray* functionCodes;
@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic, retain) UILabel* expressionLabel;
@property (nonatomic, retain) UILabel* resultLabel;
@property (nonatomic, retain) NSMutableArray* colors;
@property (nonatomic, retain) NSMutableArray* fonts;
- (IBAction)calcButtonTapped:(id)sender;
- (void) addCharacterToExpression:(NSString*)c;
- (void) replaceLastCharacterInExpression:(NSString*)c;
- (bool) isOperand:(NSString*)c;
- (bool) lastCharacterIsOperand;
- (bool) lastCharacterIsDecimal;
- (bool) canAddDecimal;
- (bool) expressionEmpty;
- (NSDecimalNumber*) calculateResult;
- (void) calcButtonHighlight:(id)sender;
- (void) calcButtonNormal:(id)sender;
- (void) operandButtonHighlight:(id)sender;
- (void) operandButtonNormal:(id)sender;
- (void) parseExpression;
- (void) backSwipeDetected;
- (void) downSwipeDetected;
- (void) upSwipeDetected;
- (void) saveCurrentResult;
- (void) deleteSavedResult:(UITapGestureRecognizer*)tap;
- (void) useSavedResult:(UITapGestureRecognizer*)tap;
- (void) showTutorial;
- (void) hideTutorial:(id)sender;
@end
