package commons.protos
{
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;

    /**
     * 输入协议列表
     * <br/>用于记录协议头与具体协议类的关系。
     * @author Junho
     * <br/>Create: 2013.11.29
     */    
    public class ProtoInList
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:ProtoInList = null;
        
        private var _protoDic:Dictionary;
        
        
        public function ProtoInList()
        {
            if(!_allowInstance)
                throw new IllegalOperationError("ProtoList is a singleton class.");
            
            _protoDic = new Dictionary();
        }
        
        /**
         * 获取当前实例 
         * @return ProtoList
         * 
         */	
        public static function getInstance():ProtoInList
        {
            if(null == _instance)
            {
                _allowInstance = true;
                _instance = new ProtoInList();
                _allowInstance = false;
            }
            
            return _instance;
        }
        
        
        
        public function bind(head:*, protoClass:Class):void
        {
            if (null != _protoDic[head])
                throw new IllegalOperationError("重复绑定相同协议头的协议类");
            
            _protoDic[head] = protoClass;
        }
        
        public function unbind(head:*):void
        {
            if (null != _protoDic[head])
            {
                _protoDic[head] = null;
                delete _protoDic[head];
            }
        }
        
        public function createProtoIn(head:*):ProtoInBase
        {
            if (null != _protoDic[head])
                return new _protoDic[head]();
            else
                return null;
        }
    }
}