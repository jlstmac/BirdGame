#ifndef __APP_DELEGATE_H__
#define __APP_DELEGATE_H__

#include "cocos2d.h"
USING_NS_CC;

//typedef struct tagResource
//{
//    Size size;
//    char directory[100];
//}Resource;
//
//static Resource iPhoneResource  =  { Size(480, 320),   "iPhone" };
//static Resource iPhoneHDResource   =  { Size(480*2, 320*2),   "iPhoneHD" };
//static Resource iPhoneTallerResource = { Size(1136, 640),    "iPhoneTaller"};
//static Resource iPadResource =  { Size(1024, 768),  "iPad"   };
//static Resource iPadHDResource  =  { Size(2048, 1536), "iPadHD" };
//static Size designResolutionSize = Size(480, 320);
//static Size designTallerResolutionSize = Size(568, 320);

/**
@brief    The cocos2d Application.

The reason for implement as private inheritance is to hide some interface call by Director.
*/
class  AppDelegate : private cocos2d::Application
{
public:
    AppDelegate();
    virtual ~AppDelegate();

    /**
    @brief    Implement Director and Scene init code here.
    @return true    Initialize success, app continue.
    @return false   Initialize failed, app terminate.
    */
    virtual bool applicationDidFinishLaunching();

    /**
    @brief  The function be called when the application enter background
    @param  the pointer of the application
    */
    virtual void applicationDidEnterBackground();

    /**
    @brief  The function be called when the application enter foreground
    @param  the pointer of the application
    */
    virtual void applicationWillEnterForeground();
    
    AppDelegate* getInstance();

};

#endif  // __APP_DELEGATE_H__

