--
-- Author: GeZiyang
-- Date: 2014-02-10
--

-- config
local flySpeed  = 2.5
local flyOffset = 5

local g_curveMoveTime = 8.0
local g_bgMoveTime = 120.0
local g_cloudMoveTime = 40.0

-- vars
g_flyTag = 1000

g_rateButton = nil
g_playButton = nil
g_rankButton = nil

g_soundButtonItem = nil

cc.FileUtils:getInstance():addSearchPath("res/")
local textureAtlas = cc.Director:getInstance():getTextureCache():addImage("atlas.png")

-- wingPath = cc.FileUtils:getInstance():fullPathForFilename("sfx_wing.wav")
-- hitPath = cc.FileUtils:getInstance():fullPathForFilename("sfx_hit.wav")
-- scorePath = cc.FileUtils:getInstance():fullPathForFilename("sfx_point.wav")
-- fallPath = cc.FileUtils:getInstance():fullPathForFilename("sfx_die.wav")
-- uiPath = cc.FileUtils:getInstance():fullPathForFilename("sfx_swooshing.wav")
wingPath = cc.FileUtils:getInstance():fullPathForFilename("key1.m4a")
hitPath = cc.FileUtils:getInstance():fullPathForFilename("sfx_hit.wav")
scorePath = cc.FileUtils:getInstance():fullPathForFilename("m1.m4a")
fallPath = cc.FileUtils:getInstance():fullPathForFilename("failure.m4a")
uiPath = cc.FileUtils:getInstance():fullPathForFilename("sfx_swooshing.wav")

cc.SimpleAudioEngine:getInstance():preloadEffect(wingPath)
cc.SimpleAudioEngine:getInstance():preloadEffect(hitPath)
cc.SimpleAudioEngine:getInstance():preloadEffect(scorePath)
cc.SimpleAudioEngine:getInstance():preloadEffect(fallPath)
cc.SimpleAudioEngine:getInstance():preloadEffect(uiPath)

visibleSize = cc.Director:getInstance():getVisibleSize()
print("visibleSize :"..visibleSize.width.." "..visibleSize.height)

local function generateSpriteLuaFile()
    -- body
    local atlasFile = io.open("atlas.txt", "r")
    local outFile = io.open("out.lua","w")
    outFile:write("a = {}\n")
    print("generateSpriteLuaFile")
    local line, tmpSprite

    for line in atlasFile:lines() do
        tmpSprite = {}
        for i in string.gmatch(line, "%S+") do
            tmpSprite[#tmpSprite + 1] = i
            cclog(i)
        end
        local name = tmpSprite[1]
        local width = tmpSprite[2]
        local height = tmpSprite[3]
        local x = math.floor(1024 * (tonumber(tmpSprite[4])) + 0.1)
        local y = math.floor(1024 * (tonumber(tmpSprite[5])) + 0.1)
        outFile:write(string.format("a[\"%s\"]={width=%s, height=%s, x=%s, y=%s}\n", name, width, height, x, y))
    end   
    outFile.close()
end

function createAtlasSprite(name)
    local tmpTable = a[name]

    -- fix 1px edge bug
    if name == "land" then
        tmpTable.x = tmpTable.x + 1            
    end

    local rect = cc.rect(tmpTable.x, tmpTable.y, tmpTable.width, tmpTable.height)
    local frame = cc.SpriteFrame:createWithTexture(textureAtlas, rect)
    local atlasSprite = cc.Sprite:createWithSpriteFrame(frame)

    return atlasSprite
end

function getSpriteSize(name)
    return cc.size(a[name].width, a[name].height)
end

-- function getSpriteSize(name)
--     print("createspritename:"..name)
--     local sp = cc.Sprite:create(name)
--     return sp:getContentSize()
-- end

-- a sprite ,run repeation aciton
function createBird()
    local randomIndex = math.random(0, 2)

    -- local birdFrames = {}
    -- for i=1,3 do
    --     local tmpTable = a["bird"..randomIndex.."_"..(i-1)]
    --     local rect = cc.rect(tmpTable.x, tmpTable.y, tmpTable.width, tmpTable.height)
    --     local frame = cc.SpriteFrame:createWithTexture(textureAtlas, rect)
    --     birdFrames[#birdFrames + 1] = frame
    -- end

    local birdFrames = {}
    for i=1,4 do
        local frame = cc.Sprite:create("bird_" .. i ..".png"):getSpriteFrame()
        birdFrames[#birdFrames + 1] = frame
    end

    local spriteBird = cc.Sprite:createWithSpriteFrame(birdFrames[1])       

    local animation = cc.Animation:createWithSpriteFrames(birdFrames, 0.2)
    local animate = cc.Animate:create(animation);
    spriteBird:runAction(cc.RepeatForever:create(animate))

    return spriteBird
end

function createCommonBackLayer()
    local layerBg = cc.Layer:create()

    local randomBgIndex = math.random(1, 4)
    local bgName = "bg_" .. randomBgIndex .. ".png"
    print("banem::%s",bgName)

    -- sun sprite
    local sun = cc.Sprite:create("sun@2x.png")
    sun:setPosition(ccp(visibleSize.width*0.6, visibleSize.height*0.88))
    layerBg:addChild(sun,101)

    -- sound button
    -- local itemOn = cc.MenuItemImage:create("sound_on@2x.png", "sound_on@2x.png")
    -- local itemOff = cc.MenuItemImage:create("sound_off@2x.png", "sound_off@2x.png")

    local function soundSettingButton()
        local isOn = getSettingState()
        changeTheSoundButton(not isOn)
    end

    g_soundButtonItem = cc.MenuItemImage:create("sound_on@2x.png", "sound_off@2x.png")
    g_soundButtonItem:registerScriptTapHandler(soundSettingButton)
    local soundMenu = cc.Menu:create()
    soundMenu:addChild(g_soundButtonItem)
    layerBg:addChild(soundMenu,1110)
    soundMenu:setPosition(ccp(visibleSize.width*0.08, visibleSize.height*0.94))

    changeTheSoundButton(getSettingState())

    local scoreLable = cc.Sprite:create("cha_score@2x.png")
    scoreLable:setPosition(cc.p(visibleSize.width*0.8, visibleSize.height*0.94))
    layerBg:addChild(scoreLable,1110)
    -- first moving land
    local landPosY = -visibleSize.height*0.02
    local land_1 = cc.Sprite:create("curve_land@2x.png")
    local contentSize = land_1:getContentSize()
    land_1:setAnchorPoint(cc.p(0.5,0))
    land_1:setPosition(contentSize.width / 2, landPosY)
    layerBg:addChild(land_1, 100)

    local move1 = cc.MoveTo:create(g_curveMoveTime, cc.p(- contentSize.width / 2, landPosY))
    local reset1 = cc.Place:create(cc.p(contentSize.width / 2, landPosY))
    land_1:runAction(cc.RepeatForever:create(cc.Sequence:create(move1, reset1)))

    -- second moving land
    local land_2 = cc.Sprite:create("curve_land@2x.png")
    land_2:setAnchorPoint(cc.p(0.5,0))
    land_2:setPosition(contentSize.width * 3 / 2, landPosY)
    layerBg:addChild(land_2, 100)

    local move2 = cc.MoveTo:create(g_curveMoveTime, cc.p(contentSize.width / 2, landPosY))
    local reset2 = cc.Place:create(cc.p(contentSize.width * 3 / 2, landPosY))
    land_2:runAction(cc.RepeatForever:create(cc.Sequence:create(move2, reset2)))

    -- first moving bg
    local bg_1 = cc.Sprite:create(bgName)
    local contentSizeBg = bg_1:getContentSize()
    bg_1:setAnchorPoint(cc.p(0.5,0))
    bg_1:setPosition(contentSizeBg.width / 2, 0)
    layerBg:addChild(bg_1, 50)

    local bgmove1 = cc.MoveTo:create(g_bgMoveTime, cc.p(- contentSizeBg.width / 2, 0))
    local bgreset1 = cc.Place:create(cc.p(contentSizeBg.width / 2, 0))
    bg_1:runAction(cc.RepeatForever:create(cc.Sequence:create(bgmove1, bgreset1)))

    -- second moving bg
    local bg_2 = cc.Sprite:create(bgName)
    bg_2:setAnchorPoint(cc.p(0.5,0))
    bg_2:setPosition(contentSizeBg.width * 3 / 2, 0)
    layerBg:addChild(bg_2, 50)

    local bgmove2 = cc.MoveTo:create(g_bgMoveTime, cc.p(contentSizeBg.width / 2, 0))
    local bgreset2 = cc.Place:create(cc.p(contentSizeBg.width * 3 / 2, 0))
    bg_2:runAction(cc.RepeatForever:create(cc.Sequence:create(bgmove2, bgreset2)))


    -- first cloud
    local cloud_1 = cc.Sprite:create("top_cloud_1@2x.png")
    -- local cloudwidth1 = 8*cloud_1:getContentSize().width
    local cloudwidth1 = 2*visibleSize.width
    local cloudPosY = visibleSize.height*0.8
    cloud_1:setPosition(cc.p(3*cloudwidth1 / 2, cloudPosY))
    layerBg:addChild(cloud_1, 102)

    local bgmove1 = cc.MoveTo:create(g_cloudMoveTime, cc.p(-3*cloudwidth1 , cloudPosY))
    local bgreset1 = cc.Place:create(cc.p(3*cloudwidth1 / 2, cloudPosY))
    cloud_1:runAction(cc.RepeatForever:create(cc.Sequence:create(bgmove1, bgreset1)))

    -- second cloud
    local cloud_2 = cc.Sprite:create("top_cloud_2@2x.png")
    -- local cloudwidth2 = 6*cloud_2:getContentSize().width
    local cloudwidth2 = 1*visibleSize.width

    cloud_2:setPosition(cc.p(cloudwidth2 * 3 / 2, cloudPosY))
    layerBg:addChild(cloud_2, 102)

    local bgmove2 = cc.MoveTo:create(g_cloudMoveTime + 100, cc.p(-3*cloudwidth2 , cloudPosY))
    local bgreset2 = cc.Place:create(cc.p(cloudwidth2 * 3 / 2, cloudPosY))
    cloud_2:runAction(cc.RepeatForever:create(cc.Sequence:create(bgmove2, bgreset2)))

    function stopBgActions()
        land_1:stopAllActions()
        land_2:stopAllActions()
        bg_1:stopAllActions()
        bg_2:stopAllActions()
        cloud_1:stopAllActions()
        cloud_2:stopAllActions()
    end

    return layerBg, land_1, land_2
end

-- action before start game
function createFlyAction(position)
    local moveUp   = cc.MoveTo:create(1.0 / flySpeed, cc.p(position.x, position.y + flyOffset))
    local moveDown = cc.MoveTo:create(1.0 / flySpeed, cc.p(position.x, position.y - flyOffset))

    local flyAction = cc.RepeatForever:create(cc.Sequence:create(moveUp, moveDown))
    flyAction:setTag(g_flyTag)
    return flyAction
end

local clickedButton = nil
local function checkMenuButton(button, name, point)
    cclog("checkMenuButton : "..name)
    local buttonSize = getSpriteSize(name)
    local buttonX = button:getPositionX()
    local buttonY = button:getPositionY()

    if math.abs(point.x - buttonX) < buttonSize.width / 2 and 
        math.abs(point.y - buttonY) < buttonSize.height / 2 then
        clickedButton = button
        return true
    end
    return false
end

-- listener
local touchBeginPoint = nil
function onCommonMenuLayerTouchBegan(touch, event)
    local location = touch:getLocation()
    cclog("onCommonMenuLayerTouchBegan: %0.2f, %0.2f", location.x, location.y)
    touchBeginPoint = {x = location.x, y = location.y}
    
    if g_rateButton ~= nil then
        checkMenuButton(g_rateButton, "button_rate", touchBeginPoint)
    end

    if g_playButton ~= nil then
        checkMenuButton(g_playButton, "button_play", touchBeginPoint)
    end

    if g_rankButton ~= nil then
        checkMenuButton(g_rankButton, "button_score", touchBeginPoint) 
    end     
    
    if clickedButton ~= nil then
        clickedButton:setPosition(cc.p(clickedButton:getPositionX(), clickedButton:getPositionY() - 3))
    end

     -- CCTOUCHBEGAN event must return true
    return true
end

function onCommonMenuLayerTouchEnded(touch, event)
    local location = touch:getLocation()
    cclog("onCommonMenuLayerTouchEnded: %0.2f, %0.2f", location.x, location.y)
    touchBeginPoint = nil

    if clickedButton ~= nil then
        clickedButton:setPosition(cc.p(clickedButton:getPositionX(), clickedButton:getPositionY() + 3))
        if clickedButton == g_rateButton then

        elseif clickedButton == g_playButton then
            local gameScene = nil 
            if g_initFlag == nil then
                gameScene = require("scripts.GameScene")
            else
                gameScene = createGameScene()
            end
            local trans = cc.TransitionFade:create(0.5, gameScene, cc.c3b(0,0,0))
            cc.Director:getInstance():replaceScene(trans)
            playEffectByName(uiPath)
        elseif clickedButton == g_rankButton then

        end

        clickedButton = nil
    end

end

--size : 1.big 2.small
--alignType : 1. mid 2. right
function CreateSpriteScore(rootNode, score, size, alignType)
    local function createScoreDigit(digit)
        if size == 1 then
            return createAtlasSprite("font_0"..(48 + digit))
        end
        return createAtlasSprite("number_score_0"..digit)
    end

    rootNode:removeAllChildren()

    local distance = 20
    if size == 2 then
        distance = 15
    end

    local digits = {}
    local tmpScore = score
    local dig = math.fmod(tmpScore, 10)
    digits[#digits + 1] = dig
    while math.floor(tmpScore / 10) ~= 0 do            
        tmpScore = math.floor(tmpScore / 10)
        dig = math.fmod(tmpScore, 10)
        digits[#digits + 1] = dig
    end

    local nowOffset = (#digits - 1) * distance / 2
    if alignType == 2 then
        nowOffset = 0
    end

    for i=1, #digits do
        local digitSprite = createScoreDigit(digits[i])
        digitSprite:setPosition(cc.p(nowOffset, 0))
        rootNode:addChild(digitSprite)
        nowOffset = nowOffset - distance
    end

end

function haveANewScore(newScore)
    local pRet = 0
    local userDefaults =  cc.UserDefault:getInstance()
    local launchedBefore = userDefaults:getBoolForKey("launchedBefore")
    if launchedBefore == false then
        userDefaults:setBoolForKey("launchedBefore", true)
        userDefaults:setIntegerForKey("bestScore", newScore)
        userDefaults:flush()
        pRet = 0
    else
        local oldScore = userDefaults:getIntegerForKey("bestScore", 0)
        pRet = oldScore
        if (newScore > oldScore) then
            userDefaults:setIntegerForKey("bestScore", newScore)
            userDefaults:flush()
        end
    end
    
    return pRet
end


function changeSettingState(isSoundON)
    local userDefaults =  cc.UserDefault:getInstance()
    local launchedBefore = userDefaults:setBoolForKey("isSoundOn", isSoundON)
    userDefaults:flush()
end

function getSettingState()
    local pRet = true
    local userDefaults =  cc.UserDefault:getInstance()
    local launchedBefore = userDefaults:getBoolForKey("launchedBefore")
    if launchedBefore == false then
        local launchedBefore = userDefaults:setBoolForKey("isSoundOn", true)
        userDefaults:flush()
        pRet = true
    else
        pRet = userDefaults:getBoolForKey("isSoundOn")
    end
    return pRet
end

function changeTheSoundButton(isOn)
    if isOn then
        g_soundButtonItem:unselected()
    else
        g_soundButtonItem:selected()
    end
    changeSettingState(isOn)
end

function playEffectByName(name)
    if getSettingState() == true then
        cc.SimpleAudioEngine:getInstance():playEffect(name)
    end
end