--
-- Created by IntelliJ IDEA.
-- User: bo.chen
-- Date: 2016/6/21
-- Time: 9:39
-- To change this template use File | Settings | File Templates.
--飞艇类
local Airship = class("Airship", function()
    return display.newSprite("#airship.png")
end)
-- 没有密度 摩擦力
local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

function Airship:ctor(x, y)

    local airshipSize = self:getContentSize() -- 得到Airship自身的尺寸大小

    local airshipBody = cc.PhysicsBody:createCircle(airshipSize.width / 2,
        MATERIAL_DEFAULT)

    airshipBody:setCategoryBitmask(0x0100)
    airshipBody:setContactTestBitmask(0x0100)
    airshipBody:setCollisionBitmask(0x1000)
    self:setTag(AIRSHIP_TAG)
    self:setPhysicsBody(airshipBody)
    self:getPhysicsBody():setGravityEnable(false)

    self:setPosition(x, y)
--    上下移动 增加难度
    local move1 = cc.MoveBy:create(3, cc.p(0, airshipSize.height / 2))
    local move2 = cc.MoveBy:create(3, cc.p(0, -airshipSize.height / 2))
    local SequenceAction = cc.Sequence:create( move1, move2 )
    transition.execute(self, cc.RepeatForever:create( SequenceAction ))

end

return Airship

