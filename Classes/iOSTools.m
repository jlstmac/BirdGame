//
//  iOSTools.m
//  FlappyBird
//
//  Created by LinShan Jiang on 14-4-19.
//
//

#import "iOSTools.h"


@implementation iOSTools

+(BOOL)isGameCenterAvailable{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);

    return (gcClass && osVersionSupported);
}

+ (void) authenticateLocalPlayer
{
         [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error){
         if (error == nil) {
             //成功处理
             NSLog(@"成功");
             NSLog(@"1--alias--.%@",[GKLocalPlayer localPlayer].alias);
             NSLog(@"2--authenticated--.%d",[GKLocalPlayer localPlayer].authenticated);
             NSLog(@"3--isFriend--.%d",[GKLocalPlayer localPlayer].isFriend);
             NSLog(@"4--playerID--.%@",[GKLocalPlayer localPlayer].playerID);
             NSLog(@"5--underage--.%d",[GKLocalPlayer localPlayer].underage);
         }else {
             //错误处理
             NSLog(@"失败  %@",error);
         }
     }];
 }
@end
