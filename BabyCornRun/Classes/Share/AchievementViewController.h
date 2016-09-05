//
//  AchievementViewController.h
//  SecretLabEscape
//


#import <UIKit/UIKit.h>
#import "GameKitHelper.h"

@class AppDelegate;
@interface AchievementViewController : UIViewController<GKAchievementViewControllerDelegate>
{
    AppDelegate *App;
    int ViewTag;
    UIViewController    *myViewController;
}
@property(readwrite)int ViewTag;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock1;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock2;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock3;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock4;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock5;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock6;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock7;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock8;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock9;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock10;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock11;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock12;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock13;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock14;
@property (retain, nonatomic) IBOutlet UIImageView *Unlock15;
@property (retain, nonatomic) IBOutlet UIScrollView *ScrollView;

- (IBAction)BackBtnClicked:(id)sender;
-(IBAction)AchivementBtnClicked:(id)sender;
- (void) showAchievements;
@end
