package commons
{
    import flash.errors.IllegalOperationError;
    import flash.events.ProgressEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    
    /**
     * 自定义socket
     * @author Junho
     * <br/>Create: 2013.11.26
     */    
    public final class MySocket extends Socket
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:MySocket = null;
        
        public function MySocket()
        {
            if(!_allowInstance)
                throw new IllegalOperationError("MySocket is a singleton class.");
            
            super();
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
        }
    }
}