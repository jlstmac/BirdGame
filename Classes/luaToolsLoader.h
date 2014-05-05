//
//  luaToolsLoader.h
//  FlappyBird
//
//  Created by LinShan Jiang on 14-5-2.
//
//

#ifndef __FlappyBird__luaToolsLoader__
#define __FlappyBird__luaToolsLoader__

#include "luaTools.h"
#include "CCMenuLoader.h"
NS_CC_EXT_BEGIN

class CCBReader;

class luaToolsLoader : public cocosbuilder::MenuLoader {
    
public:
    virtual ~luaToolsLoader() {};
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(luaToolsLoader, loader);
    
protected:
    virtual Menu* createCCNode(cocos2d::Node * pParent, cocos2d::extension::CCBReader * pCCBReader) {
        return (Menu *)luaTools::create();
    }
};

NS_CC_EXT_END

#endif /* defined(__FlappyBird__luaToolsLoader__) */
