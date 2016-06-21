--
-- Created by IntelliJ IDEA.
-- User: bo.chen
-- Date: 2016/6/20
-- Time: 15:46
-- To change this template use File | Settings | File Templates.
--玩家类
local Player = class("Player",function()
    return display.newSprite("#flying1.png")
end)
--引擎封装了 Physics 接口后，Node 就自带了 body 属性，也就是每个 Sprite 都自带了 body 属性。
--所以我们要创建一个可受重力作用的 Sprite 是非常容易的，下面我们在 Player 的 ctor
--中加入如下的一段代码就可以为它绑定一个 body
function Player:ctor()
    local body = cc.PhysicsBody:createBox(self:getContentSize(), cc.PHYSICSBODY_MATERIAL_DEFAULT, cc.p(0,0))
    body:setCategoryBitmask(0x0111)
    body:setContactTestBitmask(0x1111)
    body:setCollisionBitmask(0x1001)
    self:setTag(PLAYER_TAG)
    self:setPhysicsBody(body)
    self:getPhysicsBody():setGravityEnable(false)
    --setGravityEnable 方法可以屏蔽物理世界中的刚体受到重力的影响。
    self:addAnimationCache()
end
--增加动画缓存
function Player:addAnimationCache()
    local animations = {"flying", "drop", "die"}--玩家的三种状态
    local animationFrameNum = {4, 2, 4}--帧数数组

    for i = 1, #animations do
        -- 1
        local frames = display.newFrames( animations[i] .. "%d.png", 1, animationFrameNum[i])
        -- 2
        local animation = display.newAnimation(frames, 0.3 / 4)--参数 0.3 / 4 表示 0.3 秒播放完 4 桢
        -- 3
        display.setAnimationCache(animations[i], animation)
    end
end

function Player:flying()
    transition.stopTarget(self)
    transition.playAnimationForever(self, display.getAnimationCache("flying"))
end

function Player:drop()
    transition.stopTarget(self)
    transition.playAnimationForever(self, display.getAnimationCache("drop"))
end

function Player:die()
    transition.stopTarget(self)
    transition.playAnimationForever(self, display.getAnimationCache("die"))
end
--增加血条
function Player:createProgress()
    self.blood = 100 -- 1
    local progressbg = display.newSprite("image/progress1.png") -- 2
    self.fill = display.newProgressTimer("image/progress2.png", display.PROGRESS_TIMER_BAR)  -- 3

    self.fill:setMidpoint(cc.p(0, 0.5))   -- 4
    self.fill:setBarChangeRate(cc.p(1.0, 0))   -- 5
    -- 6
    self.fill:setPosition(progressbg:getContentSize().width/2, progressbg:getContentSize().height/2)
    progressbg:addChild(self.fill)
    self.fill:setPercentage(self.blood) -- 7

    -- 8
    progressbg:setAnchorPoint(cc.p(0, 1))
    self:getParent():addChild(progressbg)
    progressbg:setPosition(cc.p(display.left, display.top))
end

function Player:setProPercentage(Percentage)
    self.fill:setPercentage(Percentage)  -- 9
end

--玩家受伤
--hit 方法的主要目的是创建一个帧动画，并且在播放完整个帧动画时移除自身
function Player:hit()
    local hit = display.newSprite()
    hit:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
    self:addChild(hit)
    local frames = display.newFrames("attack%d.png", 1, 6)
    local animation = display.newAnimation(frames, 0.3 / 6)
    local animate = cc.Animate:create(animation)

    local sequence = transition.sequence({
        animate,
        cc.CallFunc:create(function()
            hit:removeSelf()
        end)
    })

    hit:runAction(sequence)
    hit:setScale(0.6)

end
return Player

