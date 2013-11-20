package src
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;

    /**
     * 启动器
     * @author Junho
     * <br/>Create: 2013.07.07
     */
    [SWF(width = "1000", height = "600", frameRate = 30
        , backgroundColor = "0x000000")]
    public class Launcher extends Sprite
    {
        private var _socket:Socket;


        public function Launcher()
        {
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onAddedToStage(e:Event):void
        {
            _socket = new Socket();
            _socket.addEventListener(Event.CONNECT, onSocketConnected);
            _socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
            _socket.connect("127.0.0.1", 5555);
        }
        
        private function onSocketConnected(e:Event):void
        {
            trace("----------------------");
        }
        
        private function onSocketData(e:ProgressEvent):void
        {
            var ba:ByteArray = new ByteArray();
            _socket.readBytes(ba);
            var str:String = ba.toString();
            ba.position = 0;
            var a1:int = ba.readByte();
            var a2:int = ba.readByte();
            var a3:int = ba.readByte();
            var a4:int = ba.readByte();
            var a5:int = ba.readByte();
            var a6:int = ba.readByte();
            
            var a7:int = ba.readByte();
            var a8:int = ba.readByte();
            var a9:int = ba.readByte();
            var a10:int = ba.readByte();
            var a11:int = ba.readByte();
            var a12:int = ba.readByte();
            str = ba.toString();
            trace(str);
        }
    }
}
