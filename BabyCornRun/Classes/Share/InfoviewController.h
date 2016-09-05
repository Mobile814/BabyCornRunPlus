//
//  InfoviewController.h
//  SecretLabEscape

#import <UIKit/UIKit.h>

@interface InfoviewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *infoArray;
    NSMutableDictionary *dicsetImages;
}
@property (retain, nonatomic) IBOutlet UITableView *infoTbl;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *INDICATOR;
- (IBAction)RefreshBtnClicked:(id)sender;
- (IBAction)BackBtnClicked:(id)sender;
-(void)setData:(NSString *)message items:(NSMutableArray *)items Tag:(int)tag;
@end
