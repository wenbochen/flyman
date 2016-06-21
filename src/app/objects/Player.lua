--
-- Created by IntelliJ IDEA.
-- User: bo.chen
-- Date: 2016/6/20
-- Time: 15:46
-- To change this template use File | Settings | File Templates.
--�����
local Player = class("Player",function()
    return display.newSprite("#flying1.png")
end)
--�����װ�� Physics �ӿں�Node ���Դ��� body ���ԣ�Ҳ����ÿ�� Sprite ���Դ��� body ���ԡ�
--��������Ҫ����һ�������������õ� Sprite �Ƿǳ����׵ģ����������� Player �� ctor
--�м������µ�һ�δ���Ϳ���Ϊ����һ�� body
function Player:ctor()
    local body = cc.PhysicsBody:createBox(self:getContentSize(), cc.PHYSICSBODY_MATERIAL_DEFAULT, cc.p(0,0))
    body:setCategoryBitmask(0x0111)
    body:setContactTestBitmask(0x1111)
    body:setCollisionBitmask(0x1001)
    self:setTag(PLAYER_TAG)
    self:setPhysicsBody(body)
    self:getPhysicsBody():setGravityEnable(false)
    --setGravityEnable ���������������������еĸ����ܵ�������Ӱ�졣
    self:addAnimationCache()
end
--���Ӷ�������
function Player:addAnimationCache()
    local animations = {"flying", "drop", "die"}--��ҵ�����״̬
    local animationFrameNum = {4, 2, 4}--֡������

    for i = 1, #animations do
        -- 1
        local frames = display.newFrames( animations[i] .. "%d.png", 1, animationFrameNum[i])
        -- 2
        local animation = display.newAnimation(frames, 0.3 / 4)--���� 0.3 / 4 ��ʾ 0.3 �벥���� 4 ��
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
--����Ѫ��
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

--�������
--hit ��������ҪĿ���Ǵ���һ��֡�����������ڲ���������֡����ʱ�Ƴ�����
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

