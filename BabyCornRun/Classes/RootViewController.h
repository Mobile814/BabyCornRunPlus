//
//  RootViewController.h
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameKit/GameKit.h"
#import "FBConnect.h"
#import "GameCenterManager.h"

@class GameCenterManager;

@interface RootViewController : UIViewController<UIActionSheetDelegate, 
GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate,
GameCenterManagerDelegate, FBRequestDelegate,
FBDialogDelegate, FBSessionDelegate> {
    
    GameCenterManager *gameCenterManager;
    int64_t  currentScore;
    NSString* currentLeaderBoard;
    
    NSError* lastError;
    bool isGameCenterAvailable;
    
    Facebook *facebook;
    NSArray *permissions;
    
}

@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;

- (void) submitScore : (int) curScore;
- (void) checkAchievements :(int)checkType;
- (void) showLeaderboard;
- (void) showAchievements;
-(void) authenticate;
-(void)facebookCallback;



@end
