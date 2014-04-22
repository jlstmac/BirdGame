//
//  iOSTools.h
//  FlappyBird
//
//  Created by LinShan Jiang on 14-4-19.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface iOSTools : NSObject
+(BOOL)isGameCenterAvailable;
+ (void) authenticateLocalPlayer;
@end
