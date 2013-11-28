package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.net.Socket;
    
    import commons.protos.TestProtoOut;
    import commons.singleton.GlobalContext;
    import commons.singleton.MySocket;
    import commons.singleton.buses.NetBus;

    /**
     * 启动器
     * @author Junho
     * <br/>Create: 2013.07.07
     */
    [SWF(width = "1000", height = "600", frameRate = 30
        , backgroundColor = "0x000000")]
    public class Launcher extends Sprite
    {
        private var _context:GlobalContext = GlobalContext.getInstance();
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
            _context.config.serverPort = 5555;
            //...
        }

        private function onAddedToStage(e:Event):void
        {
            initLauncher();
        }
        
        private function initLauncher():void
        {
            GlobalContext.init(this);
            initSocket();
            initBuses();
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
        }
        
        private function onConnect(e:Event):void
        {
            trace("socket连接成功");
            
            var btn:CustomSimpleButton = new CustomSimpleButton();
            btn.width = 300;
            btn.height = 200;
            btn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
            {
                var proto:TestProtoOut = new TestProtoOut();
                proto.msg = "客户端\n发来\n贺电！";
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