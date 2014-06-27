#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface K_SavedResultView : UIView
@property (nonatomic, retain) NSDecimalNumber* decimalNumber;
@property (nonatomic, assign) int maxWidth;
@property (nonatomic, assign) int padding;
@property (nonatomic, retain) UIView* resultView;
@property (nonatomic, retain) UIView* deleteView;
@property (nonatomic, retain) UIFont* font;
-(id)initWithNumber:(NSDecimalNumber*)num maxWidth:(int)w;
-(NSString*)stringFromNum;
-(CGRect)calculateFrame;
-(CGSize)sizeOfText:(NSString*)string;
@end
