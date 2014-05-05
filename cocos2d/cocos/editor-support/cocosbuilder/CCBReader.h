#ifndef _CCB_CCBREADER_H_
#define _CCB_CCBREADER_H_

#include <string>
#include <vector>
#include "CCNode.h"
#include "CCData.h"
#include "CCMap.h"

#include "CCBSequence.h"
//#include "/extensions/GUI/CCControlExtension/CCControl.h"
#include "CCControl.h"

#define CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(T, METHOD) static T * METHOD() { \
    T * ptr = new T(); \
    if(ptr != NULL) { \
        ptr->autorelease(); \
        return ptr; \
    } \
    CC_SAFE_DELETE(ptr); \
    return NULL; \
}

#define CCB_STATIC_NEW_AUTORELEASE_OBJECT_WITH_INIT_METHOD(T, METHOD) static T * METHOD() { \
    T * ptr = new T(); \
    if(ptr != NULL && ptr->init()) { \
        ptr->autorelease(); \
        return ptr; \
    } \
    CC_SAFE_DELETE(ptr); \
    return NULL; \
}

#define CCB_VERSION 5

namespace cocosbuilder {

/**
 * @addtogroup cocosbuilder
 * @{
 */

class CCBFile : public cocos2d::Node
{
private:
    cocos2d::Node *_CCBFileNode;
    
public:
    CCBFile();
    
    static CCBFile* create();
    
    cocos2d::Node* getCCBFileNode();
    void setCCBFileNode(Node *pNode); // retain
};

/* Forward declaration. */
class NodeLoader;
class NodeLoaderLibrary;
class NodeLoaderListener;
class CCBMemberVariableAssigner;
class CCBSelectorResolver;
class CCBAnimationManager;
class CCBKeyframe;

/**
 * @brief Parse CCBI file which is generated by CocosBuilder
 */
class CCBReader : public cocos2d::Object 
{
public:
    enum class PropertyType {
        POSITION = 0,
        SIZE,
        POINT,
        POINT_LOCK,
        SCALE_LOCK,
        DEGREES,
        INTEGER,
        FLOAT,
        FLOAT_VAR,
        CHECK,
        SPRITEFRAME,
        TEXTURE,
        BYTE,
        COLOR3,
        COLOR4F_VAR,
        FLIP,
        BLEND_MODE,
        FNT_FILE,
        TEXT,
        FONT_TTF,
        INTEGER_LABELED,
        BLOCK,
        ANIMATION,
        CCB_FILE,
        STRING,
        BLOCK_CONTROL,
        FLOAT_SCALE,
        FLOAT_XY
    };
    
    enum class FloatType {
        _0 = 0,
        _1,
        MINUS1,
        _05,
        INTEGER,
        FULL
    };
    
    enum class PlatformType {
        ALL = 0,
        IOS,
        MAC
    };
    
    enum class TargetType {
        NONE = 0,
        DOCUMENT_ROOT = 1,
        OWNER = 2,
    };
    
    enum class PositionType
    {
        RELATIVE_BOTTOM_LEFT,
        RELATIVE_TOP_LEFT,
        RELATIVE_TOP_RIGHT,
        RELATIVE_BOTTOM_RIGHT,
        PERCENT,
        MULTIPLY_RESOLUTION,
    };
    
    enum class SizeType
    {
        ABSOLUTE,
        PERCENT,
        RELATIVE_CONTAINER,
        HORIZONTAL_PERCENT,
        VERTICAL_PERCENT,
        MULTIPLY_RESOLUTION,
    };
    
    enum class ScaleType
    {
        ABSOLUTE,
        MULTIPLY_RESOLUTION
    };
    /**
     * @js NA
     * @lua NA
     */
    CCBReader(NodeLoaderLibrary *pNodeLoaderLibrary, CCBMemberVariableAssigner *pCCBMemberVariableAssigner = NULL, CCBSelectorResolver *pCCBSelectorResolver = NULL, NodeLoaderListener *pNodeLoaderListener = NULL);
    /**
     * @js NA
     * @lua NA
     */
    CCBReader(CCBReader *ccbReader);
    /**
     * @js NA
     * @lua NA
     */
    virtual ~CCBReader();
    /**
     * @js NA
     * @lua NA
     */
    CCBReader();
   
    void setCCBRootPath(const char* ccbRootPath);
    const std::string& getCCBRootPath() const;

    cocos2d::Node* readNodeGraphFromFile(const char *pCCBFileName);
    cocos2d::Node* readNodeGraphFromFile(const char *pCCBFileName, cocos2d::Object *pOwner);
    cocos2d::Node* readNodeGraphFromFile(const char *pCCBFileName, cocos2d::Object *pOwner, const cocos2d::Size &parentSize);
    /**
     * @js NA
     * @lua NA
     */
    cocos2d::Node* readNodeGraphFromData(std::shared_ptr<cocos2d::Data> data, cocos2d::Object *pOwner, const cocos2d::Size &parentSize);
   
    /**
     @lua NA
     */
    cocos2d::Scene* createSceneWithNodeGraphFromFile(const char *pCCBFileName);
    /**
     @lua NA
     */
    cocos2d::Scene* createSceneWithNodeGraphFromFile(const char *pCCBFileName, cocos2d::Object *pOwner);
    /**
     @lua NA
     */
    cocos2d::Scene* createSceneWithNodeGraphFromFile(const char *pCCBFileName, cocos2d::Object *pOwner, const cocos2d::Size &parentSize);
    
    /**
     * @js NA
     * @lua NA
     */
    CCBMemberVariableAssigner* getCCBMemberVariableAssigner();
    /**
     * @js NA
     * @lua NA
     */
    CCBSelectorResolver* getCCBSelectorResolver();
    
    /**
     * @js getActionManager
     * @lua getActionManager
     */
    CCBAnimationManager* getAnimationManager();
    /**
     * @js setActionManager
     * @lua setActionManager
     */
    void setAnimationManager(CCBAnimationManager *pAnimationManager);
    
    /**  Used in NodeLoader::parseProperties()
     * @js NA
     * @lua NA
     */
    std::set<std::string>* getAnimatedProperties();
    /**
     * @js NA
     * @lua NA
     */
    std::set<std::string>& getLoadedSpriteSheet();
    /**
     * @js NA
     * @lua NA
     */
    cocos2d::Object* getOwner();

    /* Utility methods. 
     * @js NA
     * @lua NA
     */
    static std::string lastPathComponent(const char* pString);
    /**
     * @js NA
     * @lua NA
     */
    static std::string deletePathExtension(const char* pString);
    /**
     * @js NA
     * @lua NA
     */
    static std::string toLowerCase(const char* pString);
    /**
     * @js NA
     * @lua NA
     */
    static bool endsWith(const char* pString, const char* pEnding);

    /* Parse methods. 
     * @js NA
     * @lua NA
     */
    int readInt(bool pSigned);
    /**
     * @js NA
     * @lua NA
     */
    unsigned char readByte();
    /**
     * @js NA
     * @lua NA
     */
    bool readBool();
    std::string readUTF8();
    /**
     * @js NA
     * @lua NA
     */
    float readFloat();
    /**
     * @js NA
     * @lua NA
     */
    std::string readCachedString();
    /**
     * @js NA
     * @lua NA
     */
    bool isJSControlled();
    
    bool readCallbackKeyframesForSeq(CCBSequence* seq);
    bool readSoundKeyframesForSeq(CCBSequence* seq);
    
    cocos2d::ValueVector getOwnerCallbackNames();
    cocos2d::Vector<cocos2d::Node*>& getOwnerCallbackNodes();
    cocos2d::ValueVector& getOwnerCallbackControlEvents();
    
    cocos2d::ValueVector getOwnerOutletNames();
    cocos2d::Vector<cocos2d::Node*>& getOwnerOutletNodes();
    cocos2d::Vector<cocos2d::Node*>& getNodesWithAnimationManagers();
    cocos2d::Vector<CCBAnimationManager*>& getAnimationManagersForNodes();
    
    typedef cocos2d::Map<cocos2d::Node*, CCBAnimationManager*> CCBAnimationManagerMap;
    typedef std::shared_ptr<CCBAnimationManagerMap> CCBAnimationManagerMapPtr;
    
    /**
     * @js NA
     * @lua NA
     */
    CCBAnimationManagerMapPtr getAnimationManagers();
    /**
     * @js NA
     * @lua NA
     */
    void setAnimationManagers(CCBAnimationManagerMapPtr x);
    /**
     * @js NA
     * @lua NA
     */
    void addOwnerCallbackName(const std::string& name);
    /**
     * @js NA
     * @lua NA
     */
    void addOwnerCallbackNode(cocos2d::Node *node);
    void addOwnerCallbackControlEvents(cocos2d::extension::Control::EventType type);
    /**
     * @js NA
     * @lua NA
     */
    void addDocumentCallbackName(const std::string& name);
    /**
     * @js NA
     * @lua NA
     */
    void addDocumentCallbackNode(cocos2d::Node *node);
    void addDocumentCallbackControlEvents(cocos2d::extension::Control::EventType eventType);
    /**
     * @js NA
     * @lua NA
     */
    static float getResolutionScale();
    static void setResolutionScale(float scale);
    /**
     * @js NA
     * @lua NA
     */
    cocos2d::Node* readFileWithCleanUp(bool bCleanUp, CCBAnimationManagerMapPtr am);
    
    void addOwnerOutletName(std::string name);
    void addOwnerOutletNode(cocos2d::Node *node);

private:
    void cleanUpNodeGraph(cocos2d::Node *pNode);
    bool readSequences();
    CCBKeyframe* readKeyframe(PropertyType type);
    
    bool readHeader();
    bool readStringCache();
    //void readStringCacheEntry();
    cocos2d::Node* readNodeGraph();
    cocos2d::Node* readNodeGraph(cocos2d::Node * pParent);

    bool getBit();
    void alignBits();

    bool init();
    
    friend class NodeLoader;

private:
    std::shared_ptr<cocos2d::Data> _data;
    unsigned char *_bytes;
    int _currentByte;
    int _currentBit;
    
    std::vector<std::string> _stringCache;
    std::set<std::string> _loadedSpriteSheets;
    
    cocos2d::Object *_owner;
    
    CCBAnimationManager* _animationManager; //retain
    CCBAnimationManagerMapPtr _animationManagers;
    
    std::set<std::string> *_animatedProps;
    
    NodeLoaderLibrary *_nodeLoaderLibrary;
    NodeLoaderListener *_nodeLoaderListener;
    CCBMemberVariableAssigner *_CCBMemberVariableAssigner;
    CCBSelectorResolver *_CCBSelectorResolver;
    
    std::vector<std::string> _ownerOutletNames;
    cocos2d::Vector<cocos2d::Node*> _ownerOutletNodes;
    cocos2d::Vector<cocos2d::Node*> _nodesWithAnimationManagers;
    cocos2d::Vector<CCBAnimationManager*> _animationManagersForNodes;
    
    std::vector<std::string> _ownerCallbackNames;
    cocos2d::Vector<cocos2d::Node*> _ownerCallbackNodes;
    cocos2d::ValueVector _ownerOwnerCallbackControlEvents;
    std::string _CCBRootPath;
    
    bool _jsControlled;
};

// end of effects group
/// @}

}

#endif
