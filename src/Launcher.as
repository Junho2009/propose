package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.external.ExternalInterface;
    import flash.net.Socket;
    
    import mx.utils.StringUtil;
    
    import commons.GlobalContext;
    import commons.GlobalLayers;
    import commons.MySocket;
    import commons.WindowGlobalName;
    import commons.anim.AnimManager;
    import commons.buses.InnerEventBus;
    import commons.buses.NetBus;
    import commons.cache.CacheManager;
    import commons.debug.Debug;
    import commons.load.FilePath;
    import commons.load.LoadManager;
    import commons.manager.IWindowManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.module.ModuleManager;
    import commons.timer.TimerManager;
    import commons.vo.BlessVO;
    
    import mud.MudModule;
    import mud.protos.BlessProtoIn;
    import mud.protos.BlessProtoIn_BlessList;
    import mud.protos.BlessProtoOut_ReqBlessList;
    import mud.protos.BlessProtoOut_SendBless;
    import mud.protos.TestProtoIn;
    
    import sound.SoundModule;
    
    import ui.UIModule;
    
    import webgame.core.GlobalContext;
    import webgame.ui.GixButton;

    /**
     * 启动器
     * @author Junho
     * <br/>Create: 2013.07.07
     */
    [SWF(width = "1000", height = "600", frameRate = 30
        , backgroundColor = "0x666666")]
    public class Launcher extends Sprite
    {
        private var _context:commons.GlobalContext = commons.GlobalContext.getInstance();
        private var _socket:Socket;


        public function Launcher()
        {
            var a1:int = 1234;
            var s1:String = String(a1);
            
            initConfig();
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
        
        
        private function initConfig():void
        {
            var hasExternalCfg:Boolean = false;
            
            if (ExternalInterface.available)
            {
                var cfgInfo:Object = ExternalInterface.call("config");
                if (null != cfgInfo)
                {
                    FilePath.redirect(cfgInfo.root_path);
                    _context.config.serverAddr = cfgInfo.ip;
                    _context.config.serverPort = cfgInfo.port;
                    
                    hasExternalCfg = true;
                }
            }
            
            if (!hasExternalCfg)
            {
                FilePath.redirect("./res/");
                _context.config.serverAddr = "127.0.0.1";
                _context.config.serverPort = 8360;
            }
        }

        private function onAddedToStage(e:Event):void
        {
            initLauncher();
        }
        
        private function initLauncher():void
        {
            initExternalModules();
            initModules();
            initSocket();
            initBuses();
        }
        
        private function initExternalModules():void
        {
            commons.GlobalContext.init(this);
        }
        
        private function initModules():void
        {
            var timerMgr:TimerManager = new TimerManager();
            ManagerHub.getInstance().register(ManagerGlobalName.TimerManager, timerMgr);
            
            var moduleMgr:ModuleManager = new ModuleManager();
            ManagerHub.getInstance().register(ManagerGlobalName.ModuleManager, moduleMgr);
            
            var cacheMgr:CacheManager = new CacheManager();
            ManagerHub.getInstance().register(ManagerGlobalName.CacheManager, cacheMgr);
            
            var loadMgr:LoadManager = new LoadManager();
            ManagerHub.getInstance().register(ManagerGlobalName.LoadManager, loadMgr);
            
            var animMgr:AnimManager = new AnimManager();
            ManagerHub.getInstance().register(ManagerGlobalName.AnimManager, animMgr);
            
            moduleMgr.addModule(new MudModule());
            moduleMgr.addModule(new UIModule());
            moduleMgr.addModule(new SoundModule());
            
//            FlowerEffect.getInstance().fallFlowers(50000);
            
//            //testing
//            var soundMgr:ISoundManager = ManagerHub.getInstance().getManager(ManagerGlobalName.SoundManager) as ISoundManager;
//            soundMgr.play(FilePath.root+"music/1.mp3", true);
        }
        
        private function initSocket():void
        {
            _socket = MySocket.getInstance();
            _socket.addEventListener(Event.CONNECT, onConnect);
            _socket.addEventListener(Event.CLOSE, onClose);
            _socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
            _socket.connect(_context.config.serverAddr, _context.config.serverPort);
        }
        
        private function initBuses():void
        {
            InnerEventBus.getInstance();
            NetBus.getInstance();
            
            //testing
            NetBus.getInstance().addCallback(TestProtoIn.HEAD, function(inc:TestProtoIn):void
            {
                Debug.log("收到{0}协议. name: {1}, value: {2}, msg: {3}"
                    , inc.head, inc.name, inc.value, inc.msg);
            });
            NetBus.getInstance().addCallback(BlessProtoIn.HEAD, function(inc:BlessProtoIn):void
            {
                var winMgr:IWindowManager = ManagerHub.getInstance().getManager(ManagerGlobalName.WindowManager) as IWindowManager;
                winMgr.open(WindowGlobalName.MSG_BOX, null
                    , StringUtil.substitute("{0}发来祝福：{1}", inc.authorName, inc.msg));
            });
            NetBus.getInstance().addCallback(BlessProtoIn_BlessList.HEAD, function(inc:BlessProtoIn_BlessList):void
            {
                var blessList:Vector.<BlessVO> = inc.blessList;
                const blessListLen:uint = blessList.length;
            });
        }
        
        private function onConnect(e:Event):void
        {
            trace("socket连接成功");
            
            //testing
            launcherSupportsLib();
        }
        
        private function launcherSupportsLib():void
        {
            webgame.core.GlobalContext.init(this);
            
            //testing
            var winMgr:IWindowManager = ManagerHub.getInstance().getManager(ManagerGlobalName.WindowManager) as IWindowManager;
            
            winMgr.open(WindowGlobalName.HOME_PAGE);
            
            var btn:GixButton = new GixButton();
            btn.init();
            btn.width = 300;
            btn.height = 200;
            btn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
            {
                /*var proto:BlessProtoOut_SendBless = new BlessProtoOut_SendBless();
                proto.name = "俊壕、海霞的朋友";
                proto.msg = "我们\n发来\n贺电~~";
                NetBus.getInstance().send(proto);*/
                var proto:BlessProtoOut_ReqBlessList = new BlessProtoOut_ReqBlessList();
                proto.page = 3;
                NetBus.getInstance().send(proto);
            });
            GlobalLayers.getInstance().windowLayer.addChild(btn);
        }
        
        private function onClose(e:Event):void
        {
            trace("socket已关闭");
        }
        
        private function onSocketIOError(e:IOErrorEvent):void
        {
            trace("socket发生IO错误");
        }
    }
}



import flash.display.Shape;
import flash.display.SimpleButton;


class CustomSimpleButton extends SimpleButton {
    private var upColor:uint   = 0xFFCC00;
    private var overColor:uint = 0xCCFF00;
    private var downColor:uint = 0x00CCFF;
    private var size:uint      = 80;
    
    public function CustomSimpleButton() {
        downState      = new ButtonDisplayState(downColor, size);
        overState      = new ButtonDisplayState(overColor, size);
        upState        = new ButtonDisplayState(upColor, size);
        hitTestState   = new ButtonDisplayState(upColor, size * 2);
        hitTestState.x = -(size / 4);
        hitTestState.y = hitTestState.x;
        useHandCursor  = true;
    }
}

class ButtonDisplayState extends Shape {
    private var bgColor:uint;
    private var size:uint;
    
    public function ButtonDisplayState(bgColor:uint, size:uint) {
        this.bgColor = bgColor;
        this.size    = size;
        draw();
    }
    
    private function draw():void {
        graphics.beginFill(bgColor);
        graphics.drawRect(0, 0, size, size);
        graphics.endFill();
    }
}