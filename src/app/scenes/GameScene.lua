--
-- Author: wenbo
-- Date: 2016-06-19 00:24:33
--
local Player = require("app.objects.Player")
local GameScene = class("GameScene", function ()
--	return display.newScene("GameScene")
	return display.newPhysicsScene("GameScene")
end)

function GameScene:ctor()
	--播放背景音乐
	audio.playMusic("sound/background.mp3", true)
	-- cc.ui.UILabel.new({
 --            UILabelType = 2, text = "文博,你一定要开发一个游戏啊", size = 32})
 --        :align(display.CENTER, display.cx, display.cy)--在屏幕上显示的位置 和对齐方式
 --        :addTo(self) --添加到场景中
	-- 增加物理世界
	self.world = self:getPhysicsWorld()--默认带有重力
	self.world:setGravity(cc.p(0, -98.0))--大小为98
--	self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL) --这个注释掉后精灵不会显示边框了
	-- 加入背景场景
	self.backgroundLayer = BackgroundLayer.new()
	:addTo(self)
	-- 增加玩家对象
	self.player = Player.new()
	self.player:setPosition(-20, display.height * 2 / 3)
	self:addChild(self.player)
	self:playerFlyToScene()
	self.player:createProgress()
	self:addCollision()

end

function GameScene:playerFlyToScene()
	--开始往下掉
	local function startDrop()
		self.player:getPhysicsBody():setGravityEnable(true)
		self.player:drop()
		self.backgroundLayer:startGame()
	--增加触摸响应事件 将整个背景层添加触摸支持
		self.backgroundLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			return self:onTouch(event.name, event.x, event.y)
		end)
		self.backgroundLayer:setTouchEnabled(true)
	end
	--从缓存中获取动画一直循环播放
	local animation = display.getAnimationCache("flying")
	transition.playAnimationForever(self.player, animation)
	--创建一个动作
	local action = transition.sequence({
		--先移动到屏幕的(display.cx, display.height * 2 / 3)点，
		-- 在调用 startDrop 方法
		cc.MoveTo:create(4, cc.p(display.cx, display.height * 2 / 3)),
		cc.CallFunc:create(startDrop)
	})
	--player执行动作
	self.player:runAction(action)
end
--碰撞处理
function GameScene:addCollision()

	local function contactLogic(node)
		-- 4
		if node:getTag() == HEART_TAG then
			-- 给玩家增加血量，并添加心心消除特效，下章会加上
			local emitter = cc.ParticleSystemQuad:create("particles/stars.plist")
			emitter:setBlendAdditive(false)
			emitter:setPosition(node:getPosition())
			self.backgroundLayer.map:addChild(emitter)
			if self.player.blood < 100 then

				self.player.blood = self.player.blood + 2
				self.player:setProPercentage(self.player.blood)
			end
			audio.playSound("sound/heart.mp3")
			node:removeFromParent()
			-- 5
		elseif node:getTag() == GROUND_TAG then
			-- 减少玩家20点血量，并添加玩家受伤动画，下章会加上
			self.player:hit()
			self.player.blood = self.player.blood - 20
			self.player:setProPercentage(self.player.blood)
			audio.playSound("sound/ground.mp3")

		elseif node:getTag() == AIRSHIP_TAG then
			-- 减少玩家10点血量，并添加玩家受伤动画
			self.player:hit()
			self.player.blood = self.player.blood - 10
			self.player:setProPercentage(self.player.blood)
			audio.playSound("sound/hit.mp3")
		elseif node:getTag() == BIRD_TAG then
			-- 减少玩家5点血量，并添加玩家受伤动画
			self.player:hit()
			self.player.blood = self.player.blood - 5
			self.player:setProPercentage(self.player.blood)
			audio.playSound("sound/hit.mp3")
		end
	end

	local function onContactBegin(contact)   -- 1
	-- 2
	local a = contact:getShapeA():getBody():getNode()
	local b = contact:getShapeB():getBody():getNode()
	-- 3
	contactLogic(a)
	contactLogic(b)

	return true
	end

	local function onContactSeperate(contact)   -- 6
	-- 在这里检测当玩家的血量减少是否为0，游戏是否结束。
	if self.player.blood <= 0 then
		self.backgroundLayer:unscheduleUpdate()
		self.player:die()

		local over = display.newSprite("image/over.png")
		:pos(display.cx, display.cy)
		:addTo(self)
		self.player:removeFromParent()--游戏结束后删除玩家对象
		audio.stopMusic(true)--停止播放音乐并释放资源

		cc.Director:getInstance():getEventDispatcher():removeAllEventListeners()
	end
	end

	local contactListener = cc.EventListenerPhysicsContact:create()
	contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
	contactListener:registerScriptHandler(onContactSeperate, cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE)
	local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	eventDispatcher:addEventListenerWithFixedPriority(contactListener, 1)
end
--触摸触发  这里只对player处理
function GameScene:onTouch(event, x, y)
	if event == "began" then
--		开始的时候给玩家一个向上的加速度 即点击屏幕的时候小人往上跳
		self.player:flying()
		self.player:getPhysicsBody():setVelocity(cc.p(0, 98))

		return true
		-- elseif event == "moved" then
--	在触摸结束时，让 Player 下落就可以了
	elseif event == "ended" then
		self.player:drop()
		-- else event == "cancelled" then
	end
end

function GameScene:onEnter()
	-- body
end

function GameScene:onExit()
	-- body
end

return GameScene