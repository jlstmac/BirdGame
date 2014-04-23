/****************************************************************************
 Copyright (c) 2010 cocos2d-x.org

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/
#import <UIKit/UIKit.h>
#import "AppController.h"
#import "cocos2d.h"
#import "EAGLView.h"
#import "AppDelegate.h"

#import "RootViewController.h"
#import "GameCenterManager.h"
#import "iOSTools.h"

@implementation AppController
@synthesize gameCenterManager;

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;
static AppController* it;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    CGRect winRect = [[UIScreen mainScreen] bounds];
    window = [[UIWindow alloc] initWithFrame: winRect];
    CCEAGLView *__glView = [CCEAGLView viewWithFrame: [window bounds]
                                     pixelFormat: kEAGLColorFormatRGBA8
                                     depthFormat: GL_DEPTH_COMPONENT16
                              preserveBackbuffer: NO
                                      sharegroup: nil
                                   multiSampling: NO
                                 numberOfSamples: 0 ];

    [__glView setMultipleTouchEnabled:YES];
    // Use RootViewController manage CCEAGLView
    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    viewController.wantsFullScreenLayout = YES;
    viewController.view = __glView;

    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [window addSubview: viewController.view];
    }
    else
    {
        // use this method on ios6
        [window setRootViewController:viewController];
    }
    
    [window makeKeyAndVisible];

    [[UIApplication sharedApplication] setStatusBarHidden: YES];
    
    cocos2d::Application::getInstance()->run();
    
    //ADView
    CGRect rect = CGRectMake(0, 320 - 32, 0, 0);
    adView = [[ADBannerView alloc] initWithFrame:rect];
	adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
	[viewController.view addSubview:adView];
	adView.delegate = self;
	adView.hidden = YES;
    
	adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    
    //LeaderBoard

	if([GameCenterManager isGameCenterAvailable])
	{
		self.gameCenterManager= [[[GameCenterManager alloc] init] autorelease];
		[self.gameCenterManager setDelegate: self];
		[self.gameCenterManager authenticateLocalUser];
        
//        [self showLeaderboard];
		NSLog(@"111");
	}
	else
	{NSLog(@"222");
		[self showAlertWithTitle: @"Game Center Support Required!"
						 message: @"The current device does not support Game Center, which this sample requires."];
	}
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    cocos2d::Director::getInstance()->pause();
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    cocos2d::Director::getInstance()->resume();
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::Application::getInstance()->applicationDidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    cocos2d::Application::getInstance()->applicationWillEnterForeground();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
     cocos2d::Director::getInstance()->purgeCachedData();
}


- (void)dealloc {
    [super dealloc];
}

//***ADView
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{NSLog(@"vill load");}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"%d",adView.bannerLoaded);
	adView.hidden = NO;
	NSLog(@"did load");
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"error:%@",error);
}
-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    NSLog(@"should begin");
	return YES;
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{NSLog(@"did finish");}

//***Leaderboard
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[viewController dismissModalViewControllerAnimated: YES];
//	[viewController release];
    NSLog(@"leaderboard finish");
}

//***GameCenterManager


- (void) processGameCenterAuth: (NSError*) error{

}
- (void) scoreReported: (NSError*) error{}
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error{}
- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error{}
- (void) achievementResetResult: (NSError*) error{}
- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error{}

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: title message: message
                                                   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] autorelease];
	[alert show];
	
}

-(void) show{
    [self showLeaderboard];
};

- (void) showLeaderboard;
{
    if ([GameCenterManager isGameCenterAvailable]) {
        GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
        if (leaderboardController != NULL)
        {
            //            leaderboardController.category = self.currentLeaderBoard;
            leaderboardController.category = @"BestScore";
            leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
            leaderboardController.leaderboardDelegate = self;
            [viewController presentModalViewController: leaderboardController animated: YES];
//            [viewController.view addSubview:leaderboardController.view];
        }
    }else{
    }
    
}

+ (void) showTheLB{

}

+ (AppController*) instance{
    if (it == nil) {
        it = [[AppController alloc] init];
    }
    return it;
}
@end


