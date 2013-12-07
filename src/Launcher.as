package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.net.Socket;
    
    import commons.GlobalContext;
    import commons.MySocket;
    import commons.buses.NetBus;
    import commons.debug.Debug;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.module.ModuleManager;
    
    import mud.MudModule;
    import mud.protos.BlessProtoOut;
    import mud.protos.TestProtoIn;
    import mud.protos.TestProtoOut;
    
    import webgame.core.GlobalContext;
    import webgame.ui.GixButton;

    /**
     * 启动器
     * @author Junho
     * <br/>Create: 2013.07.07
     */
    [SWF(width = "1000", height = "600", frameRate = 30
        , backgroundColor = "0x000000")]
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
            //testing
            _context.config.serverAddr = "127.0.0.1";
            _context.config.serverPort = 8360;
            //...
        }

        private function onAddedToStage(e:Event):void
        {
            initLauncher();
        }
        
        private function initLauncher():void
        {
            commons.GlobalContext.init(this);
            
            initModules();
            initSocket();
            initBuses();
        }
        
        private function initModules():void
        {
            var moduleMgr:ModuleManager = new ModuleManager();
            ManagerHub.getInstance().register(ManagerGlobalName.ModuleManager, moduleMgr);
            
            moduleMgr.addModule(new MudModule());
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
            NetBus.getInstance();
            
            NetBus.getInstance().addCallback("12345", function(inc:TestProtoIn):void
            {
                Debug.log("收到{0}协议. name: {1}, value: {2}, msg: {3}"
                    , inc.head, inc.name, inc.value, inc.msg);
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
            
            var btn:GixButton = new GixButton();
            btn.init();
            btn.width = 300;
            btn.height = 200;
            btn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
            {
                var proto:BlessProtoOut = new BlessProtoOut();
                proto.name = "俊壕、海霞的朋友";
                proto.msg = "祝你们白头偕老，永远恩爱！";
                NetBus.getInstance().send(proto);
            });
            addChild(btn);
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