package src
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

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
            
            ba.position = 6;
            var str2:String = ba.readUTFBytes(ba.bytesAvailable);
            
            trace(str2);
        }
    }
}
