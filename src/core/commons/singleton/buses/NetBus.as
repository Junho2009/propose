package commons.singleton.buses
{
    import flash.errors.IllegalOperationError;
    import flash.events.EventDispatcher;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    import commons.singleton.MySocket;
    
    /**
     * 网络总线
     * @author Junho
     * <br/>Create: 2013.11.27
     */    
    public final class NetBus extends EventDispatcher
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:NetBus = null;
        
        private var _protoCallbackListDic:Dictionary;
        
        private var _socket:MySocket;
        
        
        public function NetBus()
        {
            if(!_allowInstance)
                throw new IllegalOperationError("NetBus is a singleton class.");
            
            _protoCallbackListDic = new Dictionary();
            
            _socket = MySocket.getInstance();
            _socket.addCallback(handleProto);
        }
        
        /**
         * 获取当前实例 
         * @return NetBus
         * 
         */	
        public static function getInstance():NetBus
        {
            if(null == _instance)
            {
                _allowInstance = true;
                _instance = new NetBus();
                _allowInstance = false;
            }
            
            return _instance;
        }
        
        
        
        public function addCallback(protoNo:uint, callback:Function):void
        {
            var protoCallbackList:Vector.<Function> = _protoCallbackListDic[protoNo] as Vector.<Function>;
            if (null == protoCallbackList)
            {
                protoCallbackList = new Vector.<Function>();
                _protoCallbackListDic[protoNo] = protoCallbackList;
            }
            protoCallbackList.push(callback);
        }
        
        public function removeCallback(protoNo:uint, callback:Function):void
        {
            var protoCallbackList:Vector.<Function> = _protoCallbackListDic[protoNo] as Vector.<Function>;
            if (null == protoCallbackList)
                return;
            
            const idx:int = protoCallbackList.indexOf(callback);
            if (idx >= 0)
                protoCallbackList.splice(idx, 1);
            
            if (0 == protoCallbackList.length)
            {
                _protoCallbackListDic[protoNo] = null;
                delete _protoCallbackListDic[protoNo];
            }
        }
        
        
        
        private function handleProto(rawData:ByteArray):void
        {
            var str:String = rawData.toString();
            trace(str);
            
            _socket.writeUTFBytes("test abcdefg\n");
            _socket.flush();
        }
    }
}