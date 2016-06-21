
require("config")
require("cocos.init")
require("framework.init")
require("app.layers.BackgroundLayer")
--MyApp继承自父类cc.mvc.AppBase
local MyApp = class("MyApp", cc.mvc.AppBase)
--构造函数
function MyApp:ctor()
    MyApp.super.ctor(self)--必须手动调用父类的构造方法
    --一般在个方法中初始化游戏信息
    print("游戏初始化完成~")
    --每当调用 XXClass.new() 创建对象实例时，也会自动执行ctor()函数。 
end

function MyApp:run()
	--从res目录下搜索资源文件
    cc.FileUtils:getInstance():addSearchPath("res/")
    --设置缩放因子
    cc.Director:getInstance():setContentScaleFactor(640/CONFIG_SCREEN_HEIGHT)
    display.addSpriteFrames("image/player.plist", "image/player.pvr.ccz")
    audio.preloadMusic("sound/background.mp3")
    audio.preloadSound("sound/button.wav")
    audio.preloadSound("sound/ground.mp3")
    audio.preloadSound("sound/heart.mp3")
    audio.preloadSound("sound/hit.mp3")
    --进入main场景 当然也可以进入其他场景 这里传入其他场景的名称即可
    self:enterScene("MainScene")
    --游戏场景默认必须放在 “src/app/scenes” 目录下，放到其他目录下是不能找到的。
end

return MyApp
