//
//  NewsviewController.h
//  SecretLabEscape


#import <UIKit/UIKit.h>

@interface NewsviewController : UIViewController
{
    NSMutableArray *newsArray;
    IBOutlet UIButton *backbtn;
}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *INDICATOR;

- (IBAction)BackBtnClicked:(id)sender;
-(void)setData:(NSString *)message items:(NSMutableArray *)items Tag:(int)tag;
@end
