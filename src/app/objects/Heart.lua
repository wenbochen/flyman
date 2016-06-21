--
-- Created by IntelliJ IDEA.
-- User: bo.chen
-- Date: 2016/6/20
-- Time: 16:19
-- To change this template use File | Settings | File Templates.
--
local Heart = class("Heart", function()
    return display.newSprite("image/heart.png")
end)
--�ܶȣ���������Ħ��������Ϊ0��Ϊ������ײ��ʱ�򲻷����κ������α䡣
local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

function Heart:ctor(x, y)

    local heartBody = cc.PhysicsBody:createCircle(self:getContentSize().width / 2,
        MATERIAL_DEFAULT)
    heartBody:setCategoryBitmask(0x0001)
    heartBody:setContactTestBitmask(0x0100)
    heartBody:setCollisionBitmask(0x0001)
    self:setTag(HEART_TAG)
    self:setPhysicsBody(heartBody)
    self:getPhysicsBody():setGravityEnable(false)

    self:setPosition(x, y)
end

return Heart

