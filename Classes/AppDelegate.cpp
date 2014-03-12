#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"

using namespace CocosDenshion;

USING_NS_CC;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // initialize director
    auto director = Director::getInstance();
    director->setOpenGLView(EGLView::getInstance());
    Size frameSize = EGLView::getInstance()->getFrameSize();

//    EGLView::getInstance()->setDesignResolutionSize(288, 512, ResolutionPolicy::EXACT_FIT);

    if (frameSize.height == 640 && frameSize.width == 1136){
        CCLOG("1111");
        EGLView::getInstance()->setDesignResolutionSize(1136, 640, ResolutionPolicy::NO_BORDER);
    }else{CCLOG("2222");
        EGLView::getInstance()->setDesignResolutionSize(960, 640, ResolutionPolicy::NO_BORDER);
    }
    std::vector<std::string> searchPath = FileUtils::getInstance()->getSearchPaths();
    searchPath.push_back("iPhoneHD");
    FileUtils::getInstance()->setSearchPaths(searchPath);

    // turn on display FPS
    director->setDisplayStats(false);

    // set FPS. the default value is 1.0/60 if you don't call this
    director->setAnimationInterval(1.0 / 60);

    // register lua engine
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    
    //The call was commented because it will lead to ZeroBrane Studio can't find correct context when debugging
    //engine->executeScriptFile("hello.lua");
    engine->executeString("require 'main.lua'");

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}
