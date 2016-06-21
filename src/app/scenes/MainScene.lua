--创建一个场景类 这个MinScene类不是继承自某个类 而是通过一个方法来创建
--这是因为 Scene 场景对象必须是一个 C++ 的对象，而 C++ 的对象是无法直接派生出 Lua 的类的，
--所以我们只有用一个函数把它创建出来，然后再为它添加相应的方法。
local MainScene = class("MainScene", function()
	--在 Quick 中，display 模块封装了绝大部分与显示有关的功能，并负责根据 config.lua 中定义的分辨率设定计算屏幕的设计分辨率。
	--display 模块提供了众多的方法和属性，
	--比如创建层（display.newLayer），创建精灵（display.newSprite），以及恢复暂停切换场景等等。
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	--增加一个lable标签
-- 	其中 cc.ui 模块中封装了大量符合脚本风格的 Cocos2d-x 控件，包含 UILabel、UIImage、UISlider 等等。
-- 所以正如上述代码一样，我们可以通过调用cc.ui.UILabel.new()来实例化一个新的 UILabel 控件。其先有参数分别表示：
-- UILabelType：创建文本对象所使用的方式。 
-- 1 表示使用位图字体创建文本显示对象，返回对象是 LabelBMFont。 
-- 2 表示使用 TTF 字体创建文字显示对象，返回对象是 Label。
-- text：要显示的文本。
-- size：文字尺寸。
    -- cc.ui.UILabel.new({
    --         UILabelType = 2, text = "文博,你一定要开发一个游戏啊", size = 32})
    --     :align(display.CENTER, display.cx, display.cy)--在屏幕上显示的位置 和对齐方式
    --     :addTo(self) --添加到场景中
    display.newSprite("image/main.jpg")
    :pos(display.cx, display.cy)
    :addTo(self)
    -- 添加一个上下跳动的精灵
    local beginButton = display.newSprite("image/title.png")
    	:pos(display.cx/2*3, display.cy)
    	:addTo(self)
    -- 上下晃动 0.5秒
    local move1 = cc.MoveBy:create(0.5,cc.p(0,10))
    local move2 = cc.MoveBy:create(0.5,cc.p(0,-10))
    -- 序列循环
    local sequAction = cc.Sequence:create(move1,move2)
    transition.execute(beginButton,cc.RepeatForever:create(sequAction))
    -- 添加开始按钮
    cc.ui.UIPushButton.new({normal="image/start1.png",pressed="image/start2.png"})
    :onButtonClicked(function ()
    	-- body
    	-- print("开始游戏")
    	-- 跳转场景
        audio.playSound("sound/button.wav")
        print("点击跳转到游戏页面")
    	app:enterScene("GameScene", nil, "SLIDEINT", 1.0)
    end)
    :pos(display.cx/2, display.cy/2)
    :addTo(self)
end

-- enterScene(sceneName, args, transitionType, time, more)
-- 它的参数分别是：

-- sceneName：表示跳转场景的场景名，也就是我们将要进入的场景的场景名。
-- args：表示跳转场景传给该场景类构造函数的参数，args需要是一个table。
-- transitionType：表示场景切换的过渡动画类型，lua中定义的过渡动画类型差不多有30种.
-- time：表示从当前场景跳转到 sceneName 场景的过渡时间。
-- more：表示过渡效果附加参数。
-- 所以，app:enterScene("GameScene", nil, "SLIDEINT", 1.0)表示从当前场景切换到 GameScene 场景，
-- 切换的过渡动画是 SLIDEINT 类型（新场景 GameScene 从顶部进入，同时现有场景 MainScene 从底部退出），整个切换过程用时1秒。


function MainScene:onEnter()
	-- 进入场景的时候调用
end

function MainScene:onExit()
	-- 退出游戏的时候调用 一般在这里释放资源
end

return MainScene
