package commons
{
    import flash.errors.IllegalOperationError;
    import flash.events.ProgressEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    
    import commons.debug.Debug;
    
    /**
     * 自定义socket
     * @author Junho
     * <br/>Create: 2013.11.26
     */    
    public final class MySocket extends Socket
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:MySocket = null;
        
        private var _callbackList:Vector.<Function>;
        
        
        public function MySocket()
        {
            if(!_allowInstance)
                throw new IllegalOperationError("MySocket is a singleton class.");
            
            _callbackList = new Vector.<Function>();
            addEventListener(ProgressEvent.SOCKET_DATA, onRecvData);
        }
        
        /**
         * 获取当前实例 
         * @return MySocket
         * 
         */	
        public static function getInstance():MySocket
        {
            if(null == _instance)
            {
                _allowInstance = true;
                _instance = new MySocket();
                _allowInstance = false;
            }
            
            return _instance;
        }
        
        public function addCallback(callback:Function):void
        {
            _callbackList.push(callback);
        }
        
        public function send(data:ByteArray):void
        {
            if (!connected)
                return;
            
            data.position = 0;
            writeBytes(data, 0, data.bytesAvailable);
            flush();
        }
        
        override public function connect(host:String, port:int):void
        {
            if (connected)
                return;
            super.connect(host, port);
        }
        
        
        
        private function onRecvData(e:ProgressEvent):void
        {
            var ba:ByteArray = new ByteArray();
            readBytes(ba);
            
            var str:String = ba.toString();
            Debug.log("收到服务端的原始数据：{0}", str);
            
            const callbackListLen:uint = _callbackList.length;
            for (var i:int = 0; i < callbackListLen; ++i)
            {
                ba.position = 0;
                if (null != _callbackList[i])
                    _callbackList[i](ba);
            }
        }
    }
}