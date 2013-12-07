package commons.buses
{
    import flash.errors.IllegalOperationError;
    import flash.events.EventDispatcher;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    import commons.MySocket;
    import commons.manager.IProtoInManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.protos.ProtoInBase;
    import commons.protos.ProtoOutBase;
    
    /**
     * 网络总线
     * @author Junho
     * <br/>Create: 2013.11.27
     */    
    public final class NetBus extends EventDispatcher
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:NetBus = null;
        
        private var _protoInMgr:IProtoInManager;
        
        private var _protoCallbackListDic:Dictionary;
        
        private var _socket:MySocket;
        
        
        public function NetBus()
        {
            if(!_allowInstance)
                throw new IllegalOperationError("NetBus is a singleton class.");
            
            _protoInMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.ProtoInManager) as IProtoInManager;
            
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
        
        
        
        public function send(protoOut:ProtoOutBase):void
        {
            protoOut.ready();
            _socket.send(protoOut.data);
        }
        
        public function addCallback(protoHead:*, callback:Function):void
        {
            var protoCallbackList:Vector.<Function> = _protoCallbackListDic[protoHead] as Vector.<Function>;
            if (null == protoCallbackList)
            {
                protoCallbackList = new Vector.<Function>();
                _protoCallbackListDic[protoHead] = protoCallbackList;
            }
            protoCallbackList.push(callback);
        }
        
        public function removeCallback(protoHead:*, callback:Function):void
        {
            var protoCallbackList:Vector.<Function> = _protoCallbackListDic[protoHead] as Vector.<Function>;
            if (null == protoCallbackList)
                return;
            
            const idx:int = protoCallbackList.indexOf(callback);
            if (idx >= 0)
                protoCallbackList.splice(idx, 1);
            
            if (0 == protoCallbackList.length)
            {
                _protoCallbackListDic[protoHead] = null;
                delete _protoCallbackListDic[protoHead];
            }
        }
        
        
        
        private function handleProto(rawData:ByteArray):void
        {
            var protoInList:Vector.<ProtoInBase> = _protoInMgr.toProtoIn(rawData);
            if (null != protoInList && protoInList.length > 0)
            {
                const protoInListLen:uint = protoInList.length;
                for (var i:int = 0; i < protoInListLen; ++i)
                {
                    var protoIn:ProtoInBase = protoInList[i];
                    
                    var callbackList:Vector.<Function> = _protoCallbackListDic[protoIn.head] as Vector.<Function>;
                    if (null != callbackList)
                    {
                        const callbackListLen:uint = callbackList.length;
                        for (var j:int = 0; j < callbackListLen; ++j)
                        {
                            var callback:Function = callbackList[j];
                            if (null != callback)
                                callback(protoIn);
                        }
                    }
                }
            }
        }
    }
}