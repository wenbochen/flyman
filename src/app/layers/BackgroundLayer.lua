--
-- Author: wenbo
-- Date: 2016-06-19 21:15:22
--
local Heart = require("app.objects.Heart")
local Airship = require("app.objects.Airship")
local Bird = require("app.objects.Bird")

BackgroundLayer = class("BackgroundLayer",function()
    return display.newLayer()
end)
 
function BackgroundLayer:ctor()
	self.distanceBg = {}
   self.nearbyBg = {}
   self.tiledMapBg = {}
   self.bird = {} --存放所有的鸟对象
   self:createBackgrounds()

    local width = self.map:getContentSize().width
    local height1 = self.map:getContentSize().height * 9 / 10
    local height2 = self.map:getContentSize().height * 3 / 16

    local sky = display.newNode()
    local bodyTop = cc.PhysicsBody:createEdgeSegment(cc.p(0, height1), cc.p(width, height1), cc.PhysicsMaterial(0.0, 0.0, 0.0))

    bodyTop:setCategoryBitmask(0x1000)
    bodyTop:setContactTestBitmask(0x0000)
    bodyTop:setCollisionBitmask(0x0001)

    sky:setPhysicsBody(bodyTop)
    self:addChild(sky)

    local ground = display.newNode()
    local bodyBottom = cc.PhysicsBody:createEdgeSegment(cc.p(0, height2), cc.p(width, height2), cc.PhysicsMaterial(0.0, 0.0, 0.0))
    bodyBottom:setCategoryBitmask(0x1000)
    bodyBottom:setContactTestBitmask(0x0001)
    bodyBottom:setCollisionBitmask(0x0011)

    ground:setTag(GROUND_TAG)
    ground:setPhysicsBody(bodyBottom)
    self:addChild(ground)
end

function BackgroundLayer:startGame()
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.scrollBackgrounds))
    self:scheduleUpdate()
end

function BackgroundLayer:createBackgrounds()
	local bg = display.newSprite("image/bj2.jpg")
	:pos(display.cx, display.cy)
	:addTo(self,-4)
	-- 我们把布幕背景的z-order设置为-4，确保它位于场景的最下层
	-- body
	-- 创建远景背景
local bg1 = display.newSprite("image/b2.png")
    :align(display.BOTTOM_LEFT, display.left , display.bottom + 10)
    :addTo(self, -3)
local bg2 = display.newSprite("image/b2.png")
    :align(display.BOTTOM_LEFT, display.left + bg1:getContentSize().width, display.bottom + 10)
    :addTo(self, -3)
 
table.insert(self.distanceBg, bg1) -- 把创建的bg1插入到了 self.distanceBg 中
table.insert(self.distanceBg, bg2) -- 把创建的bg2插入到了 self.distanceBg 中
-- 创建近景背景
	local bg3 = display.newSprite("image/b1.png")
		:align(display.BOTTOM_LEFT, display.left, display.bottom)
		:addTo(self, -2)
	local bg4 = display.newSprite("image/b1.png")
		:align(display.BOTTOM_LEFT, display.left + bg3:getContentSize().width, display.bottom)
		:addTo(self, -2)
	print(bg4:getAnchorPoint().x, bg4:getAnchorPoint().y)

	table.insert(self.nearbyBg, bg3)
	table.insert(self.nearbyBg, bg4)
	-- 背景层中还有一个重要的滚动项，那就是容纳了障碍物和奖励品的 TMX 类型的背景。
self.map = cc.TMXTiledMap:create("image/map.tmx")
    :align(display.BOTTOM_LEFT, display.left, display.bottom)
    :addTo(self, -1)

    self:addBody("heart", Heart)
    self:addBody("airship", Airship)
    self:addBody("bird", Bird)
end
 -- 实现背景滚动的方法 dt是时间间隔
 function BackgroundLayer:scrollBackgrounds(dt)
-- 当远景图片的x值小于0的时候 把它设置为0
    if self.distanceBg[2]:getPositionX() <= 0 then
        self.distanceBg[1]:setPositionX(0)
    end
 
    local x1 = self.distanceBg[1]:getPositionX() - 50*dt -- 50*dt 相当于速度
    local x2 = x1 + self.distanceBg[1]:getContentSize().width 
 
    self.distanceBg[1]:setPositionX(x1)
    self.distanceBg[2]:setPositionX(x2)
--以上的这段函数的作用就是让 self.distanceBg[1] 和 self.distanceBg[2] 的 X 坐标都向左移动 50 * dt
--（dt是时间间隔，两帧之间的时间间隔）个单位，self.distanceBg[2] 紧接在 self.distanceBg[1] 后面
--设置近景
     if self.nearbyBg[2]:getPositionX() <= 0 then
        self.nearbyBg[1]:setPositionX(0)
    end
--近景的速度快
    local x3 = self.nearbyBg[1]:getPositionX() - 150*dt
    local x4 = x3 + self.nearbyBg[1]:getContentSize().width 

    self.nearbyBg[1]:setPositionX(x3)
    self.nearbyBg[2]:setPositionX(x4)
if self.map:getPositionX()  <= display.width - self.map:getContentSize().width then
    self:unscheduleUpdate()  -- 禁用帧事件，停止整个背景层滚动
end
 
local x5 = self.map:getPositionX() - 130*dt
self.map:setPositionX(x5)
-- 不停的给小鸟加速度
-- self.addVelocityToBird()
 end
--根据地图数据创建心形对象
function BackgroundLayer:addHeart()
    local objects = self.map:getObjectGroup("heart"):getObjects() -- 1
    -- 2
    local  dict    = nil
    local  i       = 0
    local  len     = table.getn(objects)
    -- 3
    for i = 0, len-1, 1 do
        dict = objects[i + 1]
        -- 4
        if dict == nil then
            break
        end
        -- 5
        local key = "x"
        local x = dict["x"]
        local key = "y"
        local y = dict["y"]
        -- 6
        local sprite = Heart.new(x, y)
        self.map:addChild(sprite)
    end
end
-- 增加飞艇 小鸟到游戏场景中
function BackgroundLayer:addBody(objectGroupName,class)
    local objects = self.map:getObjectGroup(objectGroupName):getObjects()
    local  dict    = nil
    local  i       = 0
    local  len     = table.getn(objects)

    for i = 0, len-1, 1 do
        dict = objects[i + 1]

        if dict == nil then
            break
        end

        local key = "x"
        local x = dict["x"]
        key = "y"
        local y = dict["y"]

        local sprite = class.new(x, y)
        self.map:addChild(sprite)

        if objectGroupName == "bird" then
            table.insert(self.bird, sprite)
        end
    end
end

-- 给小鸟增加速度

--我们遍历 self.bird 数组中的所有 Bird 对象，当检测到某个 Bird 对象
--刚好要进入屏幕，且还没给过它任何速度时，我们会给它一个向左的速度，
--这个速度的范围从(-70, -40)到(-70, 40)。
--通俗一点就是说： Bird 对象将在横坐标上有一个大小为70，方向向左的速度；
--在纵坐标上有一个大小在(-40, 40)之间，方向不定的速度。
--其中math.random(-40, 40)可以产生-40到40的随机数。为了不产生相同的随机数
function BackgroundLayer:addVelocityToBird()
    local  dict    = nil
    local  i       = 0
    local  len    = table.getn(self.bird)
print("鸟的数量 "..len)
    for i = 0, len-1, 1 do
        dict = self.bird[i + 1]

        if dict == nil  then
            break
        end

        local x = dict:getPositionX()
        if x <= display.width  - self.map:getPositionX() then
            if dict:getPhysicsBody():getVelocity().x == 0 then
                dict:getPhysicsBody():setVelocity(cc.p(-70, math.random(-40, 40)))
            else
                table.remove(self.bird, i + 1)
            end
        end
    end
end

return BackgroundLayer